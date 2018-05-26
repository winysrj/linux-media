Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53923 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031384AbeEZMRu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 May 2018 08:17:50 -0400
Date: Sat, 26 May 2018 13:17:46 +0100
From: Sean Young <sean@mess.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Y Song <ys114321@gmail.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH v4 2/3] media: rc: introduce BPF_PROG_LIRC_MODE2
Message-ID: <20180526121746.6epr54fgjdsl66ri@gofer.mess.org>
References: <cover.1526651592.git.sean@mess.org>
 <cd5140387a0f9c5ffc68d1846774f12fed45f34d.1526651592.git.sean@mess.org>
 <20180525204509.7jsnnk2qzws3bmyd@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180525204509.7jsnnk2qzws3bmyd@ast-mbp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 25, 2018 at 01:45:11PM -0700, Alexei Starovoitov wrote:
> On Fri, May 18, 2018 at 03:07:29PM +0100, Sean Young wrote:
> > Add support for BPF_PROG_LIRC_MODE2. This type of BPF program can call
> > rc_keydown() to reported decoded IR scancodes, or rc_repeat() to report
> > that the last key should be repeated.
> > 
> > The bpf program can be attached to using the bpf(BPF_PROG_ATTACH) syscall;
> > the target_fd must be the /dev/lircN device.
> > 
> > Signed-off-by: Sean Young <sean@mess.org>
> ...
> >  enum bpf_attach_type {
> > @@ -158,6 +159,7 @@ enum bpf_attach_type {
> >  	BPF_CGROUP_INET6_CONNECT,
> >  	BPF_CGROUP_INET4_POST_BIND,
> >  	BPF_CGROUP_INET6_POST_BIND,
> > +	BPF_LIRC_MODE2,
> >  	__MAX_BPF_ATTACH_TYPE
> >  };
> >  
> > @@ -1902,6 +1904,53 @@ union bpf_attr {
> >   *		egress otherwise). This is the only flag supported for now.
> >   *	Return
> >   *		**SK_PASS** on success, or **SK_DROP** on error.
> > + *
> > + * int bpf_rc_keydown(void *ctx, u32 protocol, u64 scancode, u32 toggle)
> > + *	Description
> > + *		This helper is used in programs implementing IR decoding, to
> > + *		report a successfully decoded key press with *scancode*,
> > + *		*toggle* value in the given *protocol*. The scancode will be
> > + *		translated to a keycode using the rc keymap, and reported as
> > + *		an input key down event. After a period a key up event is
> > + *		generated. This period can be extended by calling either
> > + *		**bpf_rc_keydown** () with the same values, or calling
> > + *		**bpf_rc_repeat** ().
> > + *
> > + *		Some protocols include a toggle bit, in case the button
> > + *		was released and pressed again between consecutive scancodes
> > + *
> > + *		The *ctx* should point to the lirc sample as passed into
> > + *		the program.
> > + *
> > + *		The *protocol* is the decoded protocol number (see
> > + *		**enum rc_proto** for some predefined values).
> > + *
> > + *		This helper is only available is the kernel was compiled with
> > + *		the **CONFIG_BPF_LIRC_MODE2** configuration option set to
> > + *		"**y**".
> > + *
> > + *	Return
> > + *		0
> > + *
> > + * int bpf_rc_repeat(void *ctx)
> > + *	Description
> > + *		This helper is used in programs implementing IR decoding, to
> > + *		report a successfully decoded repeat key message. This delays
> > + *		the generation of a key up event for previously generated
> > + *		key down event.
> > + *
> > + *		Some IR protocols like NEC have a special IR message for
> > + *		repeating last button, for when a button is held down.
> > + *
> > + *		The *ctx* should point to the lirc sample as passed into
> > + *		the program.
> > + *
> > + *		This helper is only available is the kernel was compiled with
> > + *		the **CONFIG_BPF_LIRC_MODE2** configuration option set to
> > + *		"**y**".
> 
> Hi Sean,
> 
> thank you for working on this. The patch set looks good to me.
> I'd only ask to change above two helper names to something more specific.
> Since BPF_PROG_TYPE_LIRC_MODE2 is the name of new prog type and kconfig.
> May be bpf_lirc2_keydown() and bpf_lirc2_repeat() ?

A little history might help here.

lirc and rc-core have non-obvious meanings. So, lirc was the original project
that dealt with IR. That project was rejected from mainline because it did
not send translated keycodes to input devices (it exposed its own interface
for keypresses).

Then rc-core was written which maps IR scancodes to keycodes (using rc
keymaps) and sends them to the input layer. The original lirc userspace ABI
for receiving and sending raw IR pulses and spaces was retained (mode2 as
it was called in lirc).

Reusing parts of the lirc ABI for BPF decoding raw IR makes sense, however
dispatching decoded scancodes was never part of lirc, only rc-core. In fact,
rc-core is reused in hdmi-cec for cec commands, which does not use lirc
at all. So for example, if we want to process cec messages in bpf, it would
want call rc_keydown().

I don't think this lirc/rc-core duality is particularly great, but I'm
not sure what the right answer to that is.

> > @@ -1576,6 +1577,8 @@ static int bpf_prog_attach(const union bpf_attr *attr)
> >  	case BPF_SK_SKB_STREAM_PARSER:
> >  	case BPF_SK_SKB_STREAM_VERDICT:
> >  		return sockmap_get_from_fd(attr, BPF_PROG_TYPE_SK_SKB, true);
> > +	case BPF_LIRC_MODE2:
> > +		return rc_dev_prog_attach(attr);
> ...
> > +	case BPF_LIRC_MODE2:
> > +		return rc_dev_prog_detach(attr);
> 
> and similar rename for internal function names that go into bpf core.

I agree with this.

> Please add accumulated acks when you respin.

Good point, will do.

Thanks,

Sean
