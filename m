Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:51542 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab1FVK7N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 06:59:13 -0400
Message-ID: <4E01CAFE.9070801@iki.fi>
Date: Wed, 22 Jun 2011 13:59:10 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: David <reality_es@yahoo.es>
CC: linux-media@vger.kernel.org
Subject: Re: Sveon stv22 patches
References: <BANLkTimY_RKO4TxSu5GQo84_7VCMjLEFDg@mail.gmail.com>
In-Reply-To: <BANLkTimY_RKO4TxSu5GQo84_7VCMjLEFDg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello
Comments below.

Could you use Git since you have latest Kernel? If that's too hard don't 
try it, I can leave without, but it will easy my work a little.

You have diffed wrong direction, those patches are removing lines rather 
than adding (- vs. +). Also you your signed off by is needed.
See:
http://linuxtv.org/wiki/index.php/Development:_Submitting_Patches

> --- ./rc-map.h	2011-06-21 11:16:55.000000000 +0200
> +++ ./include/media/rc-map.h	2011-06-21 12:41:34.114509214 +0200
> @@ -130,7 +130,6 @@
>   #define RC_MAP_RC6_MCE                   "rc-rc6-mce"
>   #define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"
>   #define RC_MAP_STREAMZAP                 "rc-streamzap"
> -#define RC_MAP_SVEON_STV22		 "rc-msi-digivox-iii"
>   #define RC_MAP_TBS_NEC                   "rc-tbs-nec"
>   #define RC_MAP_TECHNISAT_USB2            "rc-technisat-usb2"
>   #define RC_MAP_TERRATEC_CINERGY_XS       "rc-terratec-cinergy-xs"

That's wrong, it is not needed at all. All the other seems to be rather OK.

regards
Antti

-- 
http://palosaari.fi/
