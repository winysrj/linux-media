Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41990 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab0JTTai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 15:30:38 -0400
Received: by pvh1 with SMTP id 1so84100pvh.19
        for <linux-media@vger.kernel.org>; Wed, 20 Oct 2010 12:30:38 -0700 (PDT)
Subject: Re: [PATCH] Support for Elgato Video Capture
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <4CBECAA5.9060804@realvnc.com>
Date: Wed, 20 Oct 2010 15:30:53 -0400
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <E21A9C8A-F27B-4E7A-A875-3121D81482EC@wilsonet.com>
References: <4CBECAA5.9060804@realvnc.com>
To: Adrian Taylor <adrian.taylor@realvnc.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Oct 20, 2010, at 6:55 AM, Adrian Taylor wrote:

> This patch allows this device successfully to show video, at least from
> its composite input.
> 
> I have no information about the true hardware contents of this device and so
> this patch is based solely on fiddling with things until it worked. The
> chip appears to be em2860, and the closest device with equivalent inputs
> is the Typhoon DVD Maker. Copying the settings for that device appears
> to do the trick. That's what this patch does.
> 
> Signed-off-by: Adrian Taylor <adrian.taylor@realvnc.com>

Patch probably needs to be redone against the staging/v2.6.37 branch of the v4l/dvb media_tree, since there's already a device 76 there (I know, because I added it. ;). Simple update though. Otherwise, looks sane.

For reference:
http://git.linuxtv.org/media_tree.git?a=shortlog;h=refs/heads/staging/v2.6.37
http://git.linuxtv.org/media_tree.git?a=commitdiff;h=7e48b30af033076c85ab48a8306b5588faf5fb4b


> ---
> drivers/media/video/em28xx/em28xx-cards.c |   16 ++++++++++++++++
> drivers/media/video/em28xx/em28xx.h       |    1 +
> 2 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
> index 3a4fd85..5806f62 100644
> --- a/drivers/media/video/em28xx/em28xx-cards.c
> +++ b/drivers/media/video/em28xx/em28xx-cards.c
> @@ -1667,6 +1667,20 @@ struct em28xx_board em28xx_boards[] = {
>        .tuner_gpio    = reddo_dvb_c_usb_box,
>        .has_dvb       = 1,
>    },
> +   [EM2860_BOARD_ELGATO_VIDEO_CAPTURE] = {
> +       .name         = "Elgato Video Capture",
> +       .decoder      = EM28XX_SAA711X,
> +       .tuner_type   = TUNER_ABSENT,   /* Capture only device */
> +       .input        = { {
> +           .type  = EM28XX_VMUX_COMPOSITE1,
> +           .vmux  = SAA7115_COMPOSITE0,
> +           .amux  = EM28XX_AMUX_LINE_IN,
> +       }, {
> +           .type  = EM28XX_VMUX_SVIDEO,
> +           .vmux  = SAA7115_SVIDEO3,
> +           .amux  = EM28XX_AMUX_LINE_IN,
> +       } },
> +   },
> };
> const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
> 
> @@ -1788,6 +1802,8 @@ struct usb_device_id em28xx_id_table[] = {
>            .driver_info = EM2820_BOARD_IODATA_GVMVP_SZ },
>    { USB_DEVICE(0xeb1a, 0x50a6),
>            .driver_info = EM2860_BOARD_GADMEI_UTV330 },
> +   { USB_DEVICE(0x0fd9, 0x0033),
> +           .driver_info = EM2860_BOARD_ELGATO_VIDEO_CAPTURE},
>    { },
> };
> MODULE_DEVICE_TABLE(usb, em28xx_id_table);
> diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
> index b252d1b..23733b8 100644
> --- a/drivers/media/video/em28xx/em28xx.h
> +++ b/drivers/media/video/em28xx/em28xx.h
> @@ -113,6 +113,7 @@
> #define EM2870_BOARD_REDDO_DVB_C_USB_BOX          73
> #define EM2800_BOARD_VC211A              74
> #define EM2882_BOARD_DIKOM_DK300         75
> +#define EM2860_BOARD_ELGATO_VIDEO_CAPTURE         76
> 
> /* Limits minimum and default number of buffers */
> #define EM28XX_MIN_BUF 4
> -- 
> 1.7.0.4


-- 
Jarod Wilson
jarod@wilsonet.com



