Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:27237 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab1BGN1i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Feb 2011 08:27:38 -0500
Subject: Re: WL1273 FM Radio driver...
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	alsa-devel@alsa-project.org, lrg@slimlogic.co.uk,
	hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
In-Reply-To: <4D4FEA03.7090109@redhat.com>
References: <1297075922.15320.31.camel@masi.mnp.nokia.com>
	 <4D4FDED0.7070008@redhat.com>
	 <20110207120234.GE10564@opensource.wolfsonmicro.com>
	 <4D4FEA03.7090109@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 15:27:12 +0200
Message-ID: <1297085233.15320.39.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-02-07 at 10:48 -0200, ext Mauro Carvalho Chehab wrote:
> Em 07-02-2011 10:02, Mark Brown escreveu:
> > On Mon, Feb 07, 2011 at 10:00:16AM -0200, Mauro Carvalho Chehab wrote:
> > 
> >> the MFD part (for example, wl1273_fm_read_reg/wl1273_fm_write_cmd/wl1273_fm_write_data). 
> >> The logic that are related to control the radio (wl1273_fm_set_audio,  wl1273_fm_set_volume,
> >> etc) are not related to access the device via the MFD bus. They should be at
> >> the media part of the driver, where they belong.
> > 
> > Those functions are being used by the audio driver.
> 
> Not sure if I understood your comments. Several media drivers have alsa drivers:
> saa7134, em28xx, cx231xx, etc. The audio drivers for them are also under 
> /drivers/media, as it is not easy to de-couple audio and video/radio part
> on those devices. For bttv and some USB boards (that use snd-usb-audio), the audio
> part is at /sound, as the audio part on them are independent and don't need to
> share anything, as audio is provided by a completely independent group of
> registers.
> 
> I suggest to use the same logic for wl1273.

So you are suggesting a more or less complete rewrite, so that I'd
create a directory like media/radio/wl1273 and then place there all of
the driver files: wl1273-radio.c, wl1273-alsa.c and maybe wl1273-core.c?

Cheers,
Matti

> 
> Cheers,
> Mauro.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


