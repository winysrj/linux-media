Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:49996 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaGVFk1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 01:40:27 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N930098WMFDH880@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Jul 2014 01:40:25 -0400 (EDT)
Date: Tue, 22 Jul 2014 02:40:21 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Different Devices identical hardware
Message-id: <20140722024021.609dc76d.m.chehab@samsung.com>
In-reply-to: <53CDF7A7.8080005@gentoo.org>
References: <53CDF7A7.8080005@gentoo.org>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 22 Jul 2014 07:33:27 +0200
Matthias Schwarzott <zzam@gentoo.org> escreveu:

> Hi,
> 
> I want to add support for Hauppauge WinTV 930C-HD and PCTV QuatroStick 521e.
> The namess and USB-IDs are different, but the hardware is the same.
> 
> Should there be in this case one card entry in cx231xx driver or two?
> Two would have the advantage that the correct name of the device could
> be displayed, but some code related to the card entry would be duplicated.

One entry is enough. There are other similar cases on our tree. We
generally add both names at the string name, like:

	[EM2820_BOARD_PINNACLE_DVC_90] = {
		.name         = "Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker "

	[EM2820_BOARD_PROLINK_PLAYTV_USB2] = {
		.name         = "SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0",

and others.

Regards,
Mauro

> 
> Regards
> Matthias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
