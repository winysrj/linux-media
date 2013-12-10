Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:65496 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab3LJV1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 16:27:08 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MXM00MYM0X6EG00@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Dec 2013 16:27:06 -0500 (EST)
Date: Tue, 10 Dec 2013 19:27:02 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/7] em28xx: reduce the polling interval for buttons
Message-id: <20131210192702.6b2412ee@samsung.com>
In-reply-to: <1385932017-2276-5-git-send-email-fschaefer.oss@googlemail.com>
References: <1385932017-2276-1-git-send-email-fschaefer.oss@googlemail.com>
 <1385932017-2276-5-git-send-email-fschaefer.oss@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun,  1 Dec 2013 22:06:54 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> For GPI-connected buttons without (hardware) debouncing, the polling interval 
> needs to be reduced to detect button presses properly.
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-input.c |    2 +-
>  1 Datei geändert, 1 Zeile hinzugefügt(+), 1 Zeile entfernt(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> index ebc5387..c8f7ecb 100644
> --- a/drivers/media/usb/em28xx/em28xx-input.c
> +++ b/drivers/media/usb/em28xx/em28xx-input.c
> @@ -31,7 +31,7 @@
>  #include "em28xx.h"
>  
>  #define EM28XX_SNAPSHOT_KEY KEY_CAMERA
> -#define EM28XX_BUTTONS_QUERY_INTERVAL 500
> +#define EM28XX_BUTTONS_QUERY_INTERVAL 100
>  
>  static unsigned int ir_debug;
>  module_param(ir_debug, int, 0644);

I don't like this patch. If the reduced timeout is needed for the GPI
connected buttons, you should not change it for the other buttons, as
polling has a high cost, in terms of CPU sleep state (so, a more frequent
polling time drains more power - meaning a lower time when battery is in
usage).

-- 

Cheers,
Mauro
