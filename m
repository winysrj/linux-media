Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:51628 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751695AbeEQMLA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 08:11:00 -0400
Received: by mail-wm0-f67.google.com with SMTP id j4-v6so8065423wme.1
        for <linux-media@vger.kernel.org>; Thu, 17 May 2018 05:10:59 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] media: rc: introduce BPF_PROG_RAWIR_EVENT
To: Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Y Song <ys114321@gmail.com>
References: <cover.1526504511.git.sean@mess.org>
 <92785c791057185fa5691f78cecfa4beae7fc336.1526504511.git.sean@mess.org>
From: Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <592262ad-e92f-2b53-f6bb-086257c21db0@netronome.com>
Date: Thu, 17 May 2018 13:10:56 +0100
MIME-Version: 1.0
In-Reply-To: <92785c791057185fa5691f78cecfa4beae7fc336.1526504511.git.sean@mess.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-05-16 22:04 UTC+0100 ~ Sean Young <sean@mess.org>
> Add support for BPF_PROG_RAWIR_EVENT. This type of BPF program can call
> rc_keydown() to reported decoded IR scancodes, or rc_repeat() to report
> that the last key should be repeated.
> 
> The bpf program can be attached to using the bpf(BPF_PROG_ATTACH) syscall;
> the target_fd must be the /dev/lircN device.
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/Kconfig           |  13 ++
>  drivers/media/rc/Makefile          |   1 +
>  drivers/media/rc/bpf-rawir-event.c | 363 +++++++++++++++++++++++++++++
>  drivers/media/rc/lirc_dev.c        |  24 ++
>  drivers/media/rc/rc-core-priv.h    |  24 ++
>  drivers/media/rc/rc-ir-raw.c       |  14 +-
>  include/linux/bpf_rcdev.h          |  30 +++
>  include/linux/bpf_types.h          |   3 +
>  include/uapi/linux/bpf.h           |  55 ++++-
>  kernel/bpf/syscall.c               |   7 +
>  10 files changed, 531 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/media/rc/bpf-rawir-event.c
>  create mode 100644 include/linux/bpf_rcdev.h
> 

[...]

Hi Sean,

Please find below some nitpicks on the documentation for the two helpers.

> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index d94d333a8225..243e141e8a5b 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h

[...]

> @@ -1902,6 +1904,35 @@ union bpf_attr {
>   *		egress otherwise). This is the only flag supported for now.
>   *	Return
>   *		**SK_PASS** on success, or **SK_DROP** on error.
> + *
> + * int bpf_rc_keydown(void *ctx, u32 protocol, u32 scancode, u32 toggle)
> + *	Description
> + *		Report decoded scancode with toggle value. For use in
> + *		BPF_PROG_TYPE_RAWIR_EVENT, to report a successfully

Could you please use bold RST markup for constants and function names?
Typically for BPF_PROG_TYPE_RAWIR_EVENT here and the enum below.

> + *		decoded scancode. This is will generate a keydown event,

s/This is will/This will/?

> + *		and a keyup event once the scancode is no longer repeated.
> + *
> + *		*ctx* pointer to bpf_rawir_event, *protocol* is decoded
> + *		protocol (see RC_PROTO_* enum).

This documentation is intended to be compiled as a man page. Could you
please use a complete sentence here?
Also, this could do with additional markup as well: **struct
bpf_rawir_event**.

> + *
> + *		Some protocols include a toggle bit, in case the button
> + *		was released and pressed again between consecutive scancodes,
> + *		copy this bit into *toggle* if it exists, else set to 0.
> + *
> + *     Return

The "Return" lines here and in the second helper use space indent
instead as tabs (as all other lines do). Would you mind fixing it for
consistency?

> + *		Always return 0 (for now)

Other helpers use just "0" in that case, but I do not really mind.
Out of curiosity, do you have anything specific in mind for changing the
return value here in the future?

> + *
> + * int bpf_rc_repeat(void *ctx)
> + *	Description
> + *		Repeat the last decoded scancode; some IR protocols like
> + *		NEC have a special IR message for repeat last button,

s/repeat/repeating/?

> + *		in case user is holding a button down; the scancode is
> + *		not repeated.
> + *
> + *		*ctx* pointer to bpf_rawir_event.

Please use a complete sentence here as well, if you do not mind.

> + *
> + *     Return
> + *		Always return 0 (for now)
>   */
Thanks,
Quentin
