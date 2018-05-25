Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:40796 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968275AbeEYUpP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 16:45:15 -0400
Date: Fri, 25 May 2018 13:45:11 -0700
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Y Song <ys114321@gmail.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH v4 2/3] media: rc: introduce BPF_PROG_LIRC_MODE2
Message-ID: <20180525204509.7jsnnk2qzws3bmyd@ast-mbp>
References: <cover.1526651592.git.sean@mess.org>
 <cd5140387a0f9c5ffc68d1846774f12fed45f34d.1526651592.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd5140387a0f9c5ffc68d1846774f12fed45f34d.1526651592.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 18, 2018 at 03:07:29PM +0100, Sean Young wrote:
> Add support for BPF_PROG_LIRC_MODE2. This type of BPF program can call
> rc_keydown() to reported decoded IR scancodes, or rc_repeat() to report
> that the last key should be repeated.
> 
> The bpf program can be attached to using the bpf(BPF_PROG_ATTACH) syscall;
> the target_fd must be the /dev/lircN device.
> 
> Signed-off-by: Sean Young <sean@mess.org>
...
>  enum bpf_attach_type {
> @@ -158,6 +159,7 @@ enum bpf_attach_type {
>  	BPF_CGROUP_INET6_CONNECT,
>  	BPF_CGROUP_INET4_POST_BIND,
>  	BPF_CGROUP_INET6_POST_BIND,
> +	BPF_LIRC_MODE2,
>  	__MAX_BPF_ATTACH_TYPE
>  };
>  
> @@ -1902,6 +1904,53 @@ union bpf_attr {
>   *		egress otherwise). This is the only flag supported for now.
>   *	Return
>   *		**SK_PASS** on success, or **SK_DROP** on error.
> + *
> + * int bpf_rc_keydown(void *ctx, u32 protocol, u64 scancode, u32 toggle)
> + *	Description
> + *		This helper is used in programs implementing IR decoding, to
> + *		report a successfully decoded key press with *scancode*,
> + *		*toggle* value in the given *protocol*. The scancode will be
> + *		translated to a keycode using the rc keymap, and reported as
> + *		an input key down event. After a period a key up event is
> + *		generated. This period can be extended by calling either
> + *		**bpf_rc_keydown** () with the same values, or calling
> + *		**bpf_rc_repeat** ().
> + *
> + *		Some protocols include a toggle bit, in case the button
> + *		was released and pressed again between consecutive scancodes
> + *
> + *		The *ctx* should point to the lirc sample as passed into
> + *		the program.
> + *
> + *		The *protocol* is the decoded protocol number (see
> + *		**enum rc_proto** for some predefined values).
> + *
> + *		This helper is only available is the kernel was compiled with
> + *		the **CONFIG_BPF_LIRC_MODE2** configuration option set to
> + *		"**y**".
> + *
> + *	Return
> + *		0
> + *
> + * int bpf_rc_repeat(void *ctx)
> + *	Description
> + *		This helper is used in programs implementing IR decoding, to
> + *		report a successfully decoded repeat key message. This delays
> + *		the generation of a key up event for previously generated
> + *		key down event.
> + *
> + *		Some IR protocols like NEC have a special IR message for
> + *		repeating last button, for when a button is held down.
> + *
> + *		The *ctx* should point to the lirc sample as passed into
> + *		the program.
> + *
> + *		This helper is only available is the kernel was compiled with
> + *		the **CONFIG_BPF_LIRC_MODE2** configuration option set to
> + *		"**y**".

Hi Sean,

thank you for working on this. The patch set looks good to me.
I'd only ask to change above two helper names to something more specific.
Since BPF_PROG_TYPE_LIRC_MODE2 is the name of new prog type and kconfig.
May be bpf_lirc2_keydown() and bpf_lirc2_repeat() ?

> @@ -1576,6 +1577,8 @@ static int bpf_prog_attach(const union bpf_attr *attr)
>  	case BPF_SK_SKB_STREAM_PARSER:
>  	case BPF_SK_SKB_STREAM_VERDICT:
>  		return sockmap_get_from_fd(attr, BPF_PROG_TYPE_SK_SKB, true);
> +	case BPF_LIRC_MODE2:
> +		return rc_dev_prog_attach(attr);
...
> +	case BPF_LIRC_MODE2:
> +		return rc_dev_prog_detach(attr);

and similar rename for internal function names that go into bpf core.

Please add accumulated acks when you respin.

Thanks
