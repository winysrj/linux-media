Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37137 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbaIVW6T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 18:58:19 -0400
Date: Mon, 22 Sep 2014 19:58:13 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-media@vger.kernel.org, crope@iki.fi
Subject: Re: [PATCH 7/7] si2165: do load firmware without extra header
Message-ID: <20140922195813.4cec3704@recife.lan>
In-Reply-To: <1409484912-19300-8-git-send-email-zzam@gentoo.org>
References: <1409484912-19300-1-git-send-email-zzam@gentoo.org>
	<1409484912-19300-8-git-send-email-zzam@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 31 Aug 2014 13:35:12 +0200
Matthias Schwarzott <zzam@gentoo.org> escreveu:

> The new file has a different name: dvb-demod-si2165-D.fw
> 
> Count blocks instead of reading count from extra header.
> Calculate CRC during upload and compare result to what chip calcuated.
> Use 0x01 instead of real patch version, because this is only used to
> check if something was uploaded but not to check the version of it.
> 
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---

...

> diff --git a/drivers/media/dvb-frontends/si2165_priv.h b/drivers/media/dvb-frontends/si2165_priv.h
> index 2b70cf1..fd778dc 100644
> --- a/drivers/media/dvb-frontends/si2165_priv.h
> +++ b/drivers/media/dvb-frontends/si2165_priv.h
> @@ -18,6 +18,6 @@
>  #ifndef _DVB_SI2165_PRIV
>  #define _DVB_SI2165_PRIV
>  
> -#define SI2165_FIRMWARE_REV_D "dvb-demod-si2165.fw"
> +#define SI2165_FIRMWARE_REV_D "dvb-demod-si2165-D.fw"

Please, don't do that. Changing the name of the firmware and breaking
the format is a bad idea, specially since you're not supporting anymore
the legacy one.

I would be ok if you were not breaking support for the old firmware
file.

Also, better to use lowercase for the firmware name.

PS.: I'm not applying patch 6/7 as this got rejected.

Regards,
Mauro
