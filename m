Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:43876 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbeEOF1R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 01:27:17 -0400
MIME-Version: 1.0
In-Reply-To: <6ecdbd01b8c42c8784f2235c1e5109dac3dd86a5.1526331777.git.sean@mess.org>
References: <cover.1526331777.git.sean@mess.org> <6ecdbd01b8c42c8784f2235c1e5109dac3dd86a5.1526331777.git.sean@mess.org>
From: Y Song <ys114321@gmail.com>
Date: Mon, 14 May 2018 22:26:35 -0700
Message-ID: <CAH3MdRW7F40dxoZg2QMi6D0fd+f2UDwxb4Jo-V0MfVWJ=eLnmQ@mail.gmail.com>
Subject: Re: [PATCH v1 3/4] media: rc bpf: move ir_raw_event to uapi
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 14, 2018 at 2:11 PM, Sean Young <sean@mess.org> wrote:
> The context provided to a BPF_PROG_RAWIR_DECODER is a struct ir_raw_event;
> ensure user space has a a definition.
>
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  include/media/rc-core.h        | 19 +------------------
>  include/uapi/linux/bpf_rcdev.h | 24 ++++++++++++++++++++++++

Patch #2 already referenced this file. So if Patches #1 and #2
applied, there will be
a compilation error. Could you re-arrange your patchset so that after
sequentially
applying each patch, there is no compilation error?

>  2 files changed, 25 insertions(+), 18 deletions(-)
>  create mode 100644 include/uapi/linux/bpf_rcdev.h
>
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index 6742fd86ff65..5d31e31d8ade 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -21,6 +21,7 @@
>  #include <linux/kfifo.h>
>  #include <linux/time.h>
>  #include <linux/timer.h>
> +#include <uapi/linux/bpf_rcdev.h>
>  #include <media/rc-map.h>
>
>  /**
> @@ -299,24 +300,6 @@ void rc_keydown_notimeout(struct rc_dev *dev, enum rc_proto protocol,
>  void rc_keyup(struct rc_dev *dev);
>  u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode);
>
> -/*
> - * From rc-raw.c
> - * The Raw interface is specific to InfraRed. It may be a good idea to
> - * split it later into a separate header.
> - */
> -struct ir_raw_event {
> -       union {
> -               u32             duration;
> -               u32             carrier;
> -       };
> -       u8                      duty_cycle;
> -
> -       unsigned                pulse:1;
> -       unsigned                reset:1;
> -       unsigned                timeout:1;
> -       unsigned                carrier_report:1;
> -};
> -
>  #define DEFINE_IR_RAW_EVENT(event) struct ir_raw_event event = {}
>
>  static inline void init_ir_raw_event(struct ir_raw_event *ev)
> diff --git a/include/uapi/linux/bpf_rcdev.h b/include/uapi/linux/bpf_rcdev.h
> new file mode 100644
> index 000000000000..d8629ff2b960
> --- /dev/null
> +++ b/include/uapi/linux/bpf_rcdev.h
> @@ -0,0 +1,24 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/* Copyright (c) 2018 Sean Young <sean@mess.org>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of version 2 of the GNU General Public
> + * License as published by the Free Software Foundation.
> + */
> +#ifndef _UAPI__LINUX_BPF_RCDEV_H__
> +#define _UAPI__LINUX_BPF_RCDEV_H__
> +
> +struct ir_raw_event {
> +       union {
> +               __u32           duration;
> +               __u32           carrier;
> +       };
> +       __u8                    duty_cycle;
> +
> +       unsigned                pulse:1;
> +       unsigned                reset:1;
> +       unsigned                timeout:1;
> +       unsigned                carrier_report:1;
> +};
> +
> +#endif /* _UAPI__LINUX_BPF_RCDEV_H__ */
> --
> 2.17.0
>
