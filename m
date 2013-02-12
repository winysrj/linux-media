Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4511 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3BLIBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Feb 2013 03:01:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [PATCH] em28xx: bump driver version to 0.2.0
Date: Tue, 12 Feb 2013 09:00:47 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1360606075-3403-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1360606075-3403-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201302120900.47310.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon February 11 2013 19:07:55 Frank Schäfer wrote:
> The em28xx driver has changed much, especially since kernel 3.8.
> So it's time to bump the driver version.
> 
> Changes since kernel 3.8:
> - converted the driver to videobuf2
> - converted the driver to the v4l2-ctrl framework
> - added USB bulk transfer support
> - use USB bulk transfers by default for webcams (allows streaming from multiple devices at the same time)
> - added image quality bridge controls: contrast, brightness, saturation, blue balance, red balance, sharpness
> - removed dependency from module ir-kbd-i2c
> - cleaned up the frame data processing code
> - removed some unused/obsolete code
> - made remote controls of devices with external (i2c) receiver/decoder work again
> - fixed audio over USB for device "Terratec Cinergy 250"
> - several v4l2 compliance fixes and improvements (including fixes for ioctls enabling/disabling)
> - lots of further bug fixes and code improvements
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/usb/em28xx/em28xx-video.c |    2 +-
>  1 Datei geändert, 1 Zeile hinzugefügt(+), 1 Zeile entfernt(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 48b937d..93fc620 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -52,7 +52,7 @@
>  
>  #define DRIVER_DESC         "Empia em28xx based USB video device driver"
>  
> -#define EM28XX_VERSION "0.1.3"
> +#define EM28XX_VERSION "0.2.0"
>  
>  #define em28xx_videodbg(fmt, arg...) do {\
>  	if (video_debug) \
> 
