Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:59024 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756693Ab0GDDNV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Jul 2010 23:13:21 -0400
Subject: Re: Fwd: Firmware for HVR-1110
From: hermann pitton <hermann-pitton@arcor.de>
To: JD <jdg8tb@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTilBXOV-7d4mOtbwfZdiAy9qiWZiVB-aHR7x0OPm@mail.gmail.com>
References: <AANLkTimQqT99icH6wGhyizm-Zymg_wNrLhxS4yqGo1Wu@mail.gmail.com>
	 <AANLkTilBXOV-7d4mOtbwfZdiAy9qiWZiVB-aHR7x0OPm@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 04 Jul 2010 05:13:15 +0200
Message-Id: <1278213195.3229.11.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi JD,

Am Samstag, den 03.07.2010, 03:32 +0100 schrieb JD:
> I'm confused as to what firmware in needed for the HVR-1110.
> 
> Scouring the web, everywhere claims that the dvb-fe-tda10046 is
> required; however, dmesg logs show that this fails to be uploaded, and
> instead it is looking for dvb-fe-tda-10048:
> 
> If I use tda-10048 then this seems to successfully loaded, but I am
> unable to find any channels with a scan;  the dvb nodes within /dev/
> are created and modules loaded, but dvbscan fails to tune.
> 
> ------
> dmesg
> --------
> $ dmesg |grep firmware
> tda10048_firmware_upload: waiting for firmware upload
> (dvb-fe-tda10048-1.0.fw)...
> saa7134 0000:03:04.0: firmware: requesting dvb-fe-tda10048-1.0.fw
> tda10048_firmware_upload: firmware read 24878 bytes.
> tda10048_firmware_upload: firmware uploading
> tda10048_firmware_upload: firmware uploaded
> 
> Any tips?
> Thanks.
> --

all variants of the HVR-1110 have a tda 10046.

I can't see, how firmware loading can fail on auto detection of those
and even switch over to tda10048 as an alternative.

Do you force some card = number and are maybe on a not yet detected
HVR-1120?

Please provide the full dmesg log related to your card and make sure you
are on Michael Krufky's latest patches.

Cheers,
Hermann


