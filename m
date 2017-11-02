Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:51577 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932196AbdKBN5X (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 09:57:23 -0400
Received: by mail-ot0-f193.google.com with SMTP id n74so1512434ota.8
        for <linux-media@vger.kernel.org>; Thu, 02 Nov 2017 06:57:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <33aff2c8fed7ea8fb30c58b5a255a4e8a0aad6d5.1509630639.git.andreyknvl@google.com>
References: <33aff2c8fed7ea8fb30c58b5a255a4e8a0aad6d5.1509630639.git.andreyknvl@google.com>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Thu, 2 Nov 2017 14:57:22 +0100
Message-ID: <CAAeHK+zB2J92N1w2Z_DuB14nCOizctTV7=_+-rmg2cUjDOCKXg@mail.gmail.com>
Subject: Re: [PATCH] media: pvrusb2: properly check endpoint types
To: Mike Isely <isely@pobox.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 2, 2017 at 2:52 PM, Andrey Konovalov <andreyknvl@google.com> wrote:
> As syzkaller detected, pvrusb2 driver submits bulk urb withount checking
> the the endpoint type is actually blunk. Add a check.
>
> usb 1-1: BOGUS urb xfer, pipe 3 != type 1
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 2713 at drivers/usb/core/urb.c:449 usb_submit_urb+0xf8a/0x11d0
> Modules linked in:
> CPU: 1 PID: 2713 Comm: pvrusb2-context Not tainted
> 4.14.0-rc1-42251-gebb2c2437d80 #210
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> task: ffff88006b7a18c0 task.stack: ffff880069978000
> RIP: 0010:usb_submit_urb+0xf8a/0x11d0 drivers/usb/core/urb.c:448
> RSP: 0018:ffff88006997f990 EFLAGS: 00010286
> RAX: 0000000000000029 RBX: ffff880063661900 RCX: 0000000000000000
> RDX: 0000000000000029 RSI: ffffffff86876d60 RDI: ffffed000d32ff24
> RBP: ffff88006997fa90 R08: 1ffff1000d32fdca R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 1ffff1000d32ff39
> R13: 0000000000000001 R14: 0000000000000003 R15: ffff880068bbed68
> FS:  0000000000000000(0000) GS:ffff88006c600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000001032000 CR3: 000000006a0ff000 CR4: 00000000000006f0
> Call Trace:
>  pvr2_send_request_ex+0xa57/0x1d80 drivers/media/usb/pvrusb2/pvrusb2-hdw.c:3645
>  pvr2_hdw_check_firmware drivers/media/usb/pvrusb2/pvrusb2-hdw.c:1812
>  pvr2_hdw_setup_low drivers/media/usb/pvrusb2/pvrusb2-hdw.c:2107
>  pvr2_hdw_setup drivers/media/usb/pvrusb2/pvrusb2-hdw.c:2250
>  pvr2_hdw_initialize+0x548/0x3c10 drivers/media/usb/pvrusb2/pvrusb2-hdw.c:2327
>  pvr2_context_check drivers/media/usb/pvrusb2/pvrusb2-context.c:118
>  pvr2_context_thread_func+0x361/0x8c0 drivers/media/usb/pvrusb2/pvrusb2-context.c:167
>  kthread+0x3a1/0x470 kernel/kthread.c:231
>  ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431
> Code: 48 8b 85 30 ff ff ff 48 8d b8 98 00 00 00 e8 ee 82 89 fe 45 89
> e8 44 89 f1 4c 89 fa 48 89 c6 48 c7 c7 40 c0 ea 86 e8 30 1b dc fc <0f>
> ff e9 9b f7 ff ff e8 aa 95 25 fd e9 80 f7 ff ff e8 50 74 f3
> ---[ end trace 6919030503719da6 ]---
>
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> ---

Note: this patch is based on a patch [1] by Takashi Iwai that adds
usb_urb_ep_type_check().

[1] https://www.spinics.net/lists/alsa-devel/msg68365.html

>  drivers/media/usb/pvrusb2/pvrusb2-hdw.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> index ad5b25b89699..44975061b953 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> @@ -3642,6 +3642,12 @@ static int pvr2_send_request_ex(struct pvr2_hdw *hdw,
>                                   hdw);
>                 hdw->ctl_write_urb->actual_length = 0;
>                 hdw->ctl_write_pend_flag = !0;
> +               if (usb_urb_ep_type_check(hdw->ctl_write_urb)) {
> +                       pvr2_trace(
> +                               PVR2_TRACE_ERROR_LEGS,
> +                               "Invalid write control endpoint");
> +                       return -EINVAL;
> +               }
>                 status = usb_submit_urb(hdw->ctl_write_urb,GFP_KERNEL);
>                 if (status < 0) {
>                         pvr2_trace(PVR2_TRACE_ERROR_LEGS,
> @@ -3666,6 +3672,12 @@ status);
>                                   hdw);
>                 hdw->ctl_read_urb->actual_length = 0;
>                 hdw->ctl_read_pend_flag = !0;
> +               if (usb_urb_ep_type_check(hdw->ctl_read_urb)) {
> +                       pvr2_trace(
> +                               PVR2_TRACE_ERROR_LEGS,
> +                               "Invalid read control endpoint");
> +                       return -EINVAL;
> +               }
>                 status = usb_submit_urb(hdw->ctl_read_urb,GFP_KERNEL);
>                 if (status < 0) {
>                         pvr2_trace(PVR2_TRACE_ERROR_LEGS,
> --
> 2.15.0.403.gc27cc4dac6-goog
>
