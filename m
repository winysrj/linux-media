Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:62506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab1BGMsc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Feb 2011 07:48:32 -0500
Message-ID: <4D4FEA03.7090109@redhat.com>
Date: Mon, 07 Feb 2011 10:48:03 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: matti.j.aaltonen@nokia.com, alsa-devel@alsa-project.org,
	lrg@slimlogic.co.uk, hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
Subject: Re: WL1273 FM Radio driver...
References: <1297075922.15320.31.camel@masi.mnp.nokia.com> <4D4FDED0.7070008@redhat.com> <20110207120234.GE10564@opensource.wolfsonmicro.com>
In-Reply-To: <20110207120234.GE10564@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-02-2011 10:02, Mark Brown escreveu:
> On Mon, Feb 07, 2011 at 10:00:16AM -0200, Mauro Carvalho Chehab wrote:
> 
>> the MFD part (for example, wl1273_fm_read_reg/wl1273_fm_write_cmd/wl1273_fm_write_data). 
>> The logic that are related to control the radio (wl1273_fm_set_audio,  wl1273_fm_set_volume,
>> etc) are not related to access the device via the MFD bus. They should be at
>> the media part of the driver, where they belong.
> 
> Those functions are being used by the audio driver.

Not sure if I understood your comments. Several media drivers have alsa drivers:
saa7134, em28xx, cx231xx, etc. The audio drivers for them are also under 
/drivers/media, as it is not easy to de-couple audio and video/radio part
on those devices. For bttv and some USB boards (that use snd-usb-audio), the audio
part is at /sound, as the audio part on them are independent and don't need to
share anything, as audio is provided by a completely independent group of
registers.

I suggest to use the same logic for wl1273.

Cheers,
Mauro.
