Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34463 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab3AMOYd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 09:24:33 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so1377809eaa.33
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2013 06:24:32 -0800 (PST)
Message-ID: <50F2C3C0.8000503@googlemail.com>
Date: Sun, 13 Jan 2013 15:25:04 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Subject: Re: [PATCH 1/3] em28xx: add missing IR RC slave address to the list
 of known i2c devices
References: <1358086508-6902-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1358086508-6902-1-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.01.2013 15:15, schrieb Frank Schäfer:
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-i2c.c |    1 +
>  1 Datei geändert, 1 Zeile hinzugefügt(+)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index 9ae8f60..8532c1d 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -534,6 +534,7 @@ static struct i2c_client em28xx_client_template = {
>   * incomplete list of known devices
>   */
>  static char *i2c_devs[128] = {
> +	[0x3e >> 1] = "remote IR sensor",
>  	[0x4a >> 1] = "saa7113h",
>  	[0x52 >> 1] = "drxk",
>  	[0x60 >> 1] = "remote IR sensor",

Sorry...I've made a mistake with "git format-patch"...
There are no patches 2/3 and 3/3.

Regards,
Frank
