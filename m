Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:53803 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbbCAPNs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Mar 2015 10:13:48 -0500
Message-ID: <54F32CAA.2040904@southpole.se>
Date: Sun, 01 Mar 2015 16:13:46 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Gilles Risch <gilles.risch@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Basic support for the Elgato EyeTV Hybrid INT 2008 USB
 Stick
References: <54F32A6D.5090909@gmail.com>
In-Reply-To: <54F32A6D.5090909@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/01/2015 04:04 PM, Gilles Risch wrote:
> This patch will add basic support for the Elgato EyeTV Hybrid INT
> 2008 USB Stick.
>
> Signed-off-by: Gilles Risch <gilles.risch@gmail.com>
>

[...]

> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -41,7 +41,7 @@
>   #include "mt352.h"
>   #include "mt352_priv.h" /* FIXME */
>   #include "tda1002x.h"
> -#include "drx39xyj/drx39xxj.h"
> +#include "drx39xxj.h"

This change looks unrelated.

The rest looks ok.

MvH
Benjamin Larsson
