Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47085 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaBJIZa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 03:25:30 -0500
Received: by mail-ob0-f174.google.com with SMTP id uy5so6839548obc.5
        for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 00:25:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfixUNkFOji-LO2moDkj+8oBgLVkWNbC-otBWNu9JQWw88A@mail.gmail.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
	<1344307634-11673-8-git-send-email-dheitmueller@kernellabs.com>
	<CAPLVkLv6JNvSdSFCY7YNRkmfzHv5+JD7Y5hxvjxdFtRT2JgE2A@mail.gmail.com>
	<CAGoCfixUNkFOji-LO2moDkj+8oBgLVkWNbC-otBWNu9JQWw88A@mail.gmail.com>
Date: Mon, 10 Feb 2014 17:25:30 +0900
Message-ID: <CAPLVkLtoos1FSiV-G8e=giN673Zmkyp7RAG-iKrkvLMz9BqRgw@mail.gmail.com>
Subject: Re: [PATCH 07/24] xc5000: properly report i2c write failures
From: Joonyoung Shim <dofmind@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

2014-02-07 22:46 GMT+09:00 Devin Heitmueller <dheitmueller@kernellabs.com>:
>
> > I can't load firmware like error of below link.
> >
> > https://bugs.launchpad.net/ubuntu/+source/linux-firmware-nonfree/+bug/1263837
> >
> > This error is related with this patch. This fix is right but above error is
> > created after this fix
> > because my device makes WatchDogTimer to 0 when load firmware.
> > Maybe it will be related with XREG_BUSY register but i can't check it.
> >
> > I removed this fix, but i have faced at other error with "xc5000: PLL not
> > running after fwload"
> > So i have commented like below.
> >
> > static const struct xc5000_fw_cfg xc5000a_1_6_114 = {
> >         .name = XC5000A_FIRMWARE,
> >         .size = 12401,
> >         //.pll_reg = 0x806c,
> > };
> >
> > Then, xc5000 device works well.
> >
> > I don't have xc5000 datasheet so i can't debug xc5000 driver anymore.
>
> Hi Joonyoung,
>
> Assuming this is the DViCO FusionHDTV7 device that uses the
> au0828/au8522, I suspect that what's happening here is your I2C
> controller is not stable.  The I2C clock stretching done by the xc5000
> often exposed bugs in various bridge drivers and the au0828 was no
> exception.  I had to work around these hardware bugs in the au0828
> driver but I made them specific to the HVR-950q since that was the
> only device I could test with.
>
> In other words, the xc5000 is most likely doing exactly what it is
> supposed to, and the increased robustness of the tuner driver with
> those two patches exposed intermittent I2C failures in au0828 that
> were previously being silently discarded (resulting in indeterminate
> behavior).
>
> I would recommending looking at the changes in au0828-cards.c for the
> HVR-950q and add the code necessary to make them also apply for the
> DVICO device, and that should resolve your problems (in particular the
> i2c_clk_divider field should be set).
>

As you said, i modified like below patch and it is working well.

Thanks for your advice.

diff --git a/drivers/media/usb/au0828/au0828-cards.c
b/drivers/media/usb/au0828/au0828-cards.c
index 0cb7c28..9936875 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -108,7 +108,7 @@ struct au0828_board au0828_boards[] = {
         .name    = "DViCO FusionHDTV USB",
         .tuner_type = UNSET,
         .tuner_addr = ADDR_UNSET,
-        .i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
+        .i2c_clk_divider = AU0828_I2C_CLK_20KHZ,
     },
     [AU0828_BOARD_HAUPPAUGE_WOODBURY] = {
         .name = "Hauppauge Woodbury",


- Joonyoung Shim
