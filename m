Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35960 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbcFULmj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2016 07:42:39 -0400
Received: by mail-io0-f177.google.com with SMTP id s63so9323254ioi.3
        for <linux-media@vger.kernel.org>; Tue, 21 Jun 2016 04:42:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1466449842-29502-23-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1466449842-29502-23-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 21 Jun 2016 12:32:10 +0200
Message-ID: <CAMuHMdVSLc7ngv+r7hNAZsYkBz-zK9JQ_wYBHFAc=YCOeCy4dw@mail.gmail.com>
Subject: Re: [PATCH 22/24] v4l: vsp1: wpf: Add flipping support
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Jun 20, 2016 at 9:10 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> Vertical flipping is available on both Gen2 and Gen3, while horizontal
> flipping is only available on Gen3.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -37,6 +37,95 @@ static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf,
>  }
>
>  /* -----------------------------------------------------------------------------
> + * Controls
> + */
> +
> +enum wpf_flip_ctrl {
> +       WPF_CTRL_VFLIP = 0,
> +       WPF_CTRL_HFLIP = 1,
> +       WPF_CTRL_MAX,
> +};
> +
> +static int vsp1_wpf_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +       struct vsp1_rwpf *wpf =
> +               container_of(ctrl->handler, struct vsp1_rwpf, ctrls);
> +       unsigned int i;
> +       u32 flip = 0;
> +
> +       switch (ctrl->id) {
> +       case V4L2_CID_HFLIP:
> +       case V4L2_CID_VFLIP:
> +               for (i = 0; i < WPF_CTRL_MAX; ++i) {
> +                       if (wpf->flip.ctrls[i])
> +                               flip |= wpf->flip.ctrls[i]->val ? BIT(i) : 0;
> +               }
> +
> +               spin_lock_irq(&wpf->flip.lock);

This spinlock doesn't seem to be initialized, or has been corrupted since
initialization:

+BUG: spinlock bad magic on CPU#1, swapper/0/1
+ lock: 0xeefa5a40, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
+CPU: 1 PID: 1 Comm: swapper/0 Not tainted
4.7.0-rc4-koelsch-03172-gb64ace16149cf394 #2802
+Hardware name: Generic R8A7791 (Flattened Device Tree)
+[<c020e080>] (unwind_backtrace) from [<c0209de0>] (show_stack+0x10/0x14)
+[<c0209de0>] (show_stack) from [<c03ccd24>] (dump_stack+0x7c/0x9c)
+[<c03ccd24>] (dump_stack) from [<c0256630>] (do_raw_spin_lock+0x20/0x190)
+[<c0256630>] (do_raw_spin_lock) from [<c055cda8>] (vsp1_wpf_s_ctrl+0x60/0x80)
+[<c055cda8>] (vsp1_wpf_s_ctrl) from [<c05454a4>]
(v4l2_ctrl_handler_setup+0xe0/0x104)
+[<c05454a4>] (v4l2_ctrl_handler_setup) from [<c055cf80>]
(vsp1_wpf_create+0x1b8/0x1f4)
+[<c055cf80>] (vsp1_wpf_create) from [<c05588a8>] (vsp1_probe+0x4dc/0x854)
+[<c05588a8>] (vsp1_probe) from [<c0485b7c>] (platform_drv_probe+0x50/0xa0)
+[<c0485b7c>] (platform_drv_probe) from [<c04843cc>]
(driver_probe_device+0x134/0x29c)
+[<c04843cc>] (driver_probe_device) from [<c04845b4>]
(__driver_attach+0x80/0xa4)
+[<c04845b4>] (__driver_attach) from [<c0482b2c>] (bus_for_each_dev+0x6c/0x90)
+[<c0482b2c>] (bus_for_each_dev) from [<c0483aa8>] (bus_add_driver+0xc8/0x1e4)
+[<c0483aa8>] (bus_add_driver) from [<c0484db0>] (driver_register+0x9c/0xe0)
+[<c0484db0>] (driver_register) from [<c02017ac>] (do_one_initcall+0xac/0x150)
+[<c02017ac>] (do_one_initcall) from [<c0c00d10>]
(kernel_init_freeable+0x124/0x1ec)
+[<c0c00d10>] (kernel_init_freeable) from [<c0692594>] (kernel_init+0x8/0x110)
+[<c0692594>] (kernel_init) from [<c0206ba8>] (ret_from_fork+0x14/0x2c)

Also seen on Salvator-X.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
