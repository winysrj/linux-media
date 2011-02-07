Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:58247 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab1BGOJ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Feb 2011 09:09:28 -0500
Subject: Re: WL1273 FM Radio driver...
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	alsa-devel@alsa-project.org, lrg@slimlogic.co.uk,
	hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
In-Reply-To: <4D4FF821.4010701@redhat.com>
References: <1297075922.15320.31.camel@masi.mnp.nokia.com>
	 <4D4FDED0.7070008@redhat.com>
	 <20110207120234.GE10564@opensource.wolfsonmicro.com>
	 <4D4FEA03.7090109@redhat.com>
	 <20110207131045.GG10564@opensource.wolfsonmicro.com>
	 <4D4FF821.4010701@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 16:09:04 +0200
Message-ID: <1297087744.15320.56.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-02-07 at 11:48 -0200, ext Mauro Carvalho Chehab wrote:
> Em 07-02-2011 11:10, Mark Brown escreveu:
> > On Mon, Feb 07, 2011 at 10:48:03AM -0200, Mauro Carvalho Chehab wrote:
> >> Em 07-02-2011 10:02, Mark Brown escreveu:
> >>> On Mon, Feb 07, 2011 at 10:00:16AM -0200, Mauro Carvalho Chehab wrote:
> > 
> >>>> the MFD part (for example, wl1273_fm_read_reg/wl1273_fm_write_cmd/wl1273_fm_write_data). 
> >>>> The logic that are related to control the radio (wl1273_fm_set_audio,  wl1273_fm_set_volume,
> >>>> etc) are not related to access the device via the MFD bus. They should be at
> >>>> the media part of the driver, where they belong.
> > 
> >>> Those functions are being used by the audio driver.
> > 
> >> Not sure if I understood your comments. Several media drivers have alsa drivers:
> > 
> > There is an audio driver for this chip and it is using those functions.
> 
> Where are the other drivers that depend on it?

There's the MFD driver driver/mfd/wl1273-core.c, which is to offer the
(I2C) I/O functions to the child drivers:
drivers/media/radio/radio-wl1273.c and sound/soc/codecs/wl1273.c.

Both children depend on the MFD driver for I/O and the codec also
depends on the presence of the radio-wl1273 driver because without the
v4l2 part nothing can be done...

Matti

> 
> Mauro
> 


