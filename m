Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab1BGMAe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Feb 2011 07:00:34 -0500
Message-ID: <4D4FDED0.7070008@redhat.com>
Date: Mon, 07 Feb 2011 10:00:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: matti.j.aaltonen@nokia.com
CC: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	lrg@slimlogic.co.uk, hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
Subject: Re: WL1273 FM Radio driver...
References: <1297075922.15320.31.camel@masi.mnp.nokia.com>
In-Reply-To: <1297075922.15320.31.camel@masi.mnp.nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-02-2011 08:52, Matti J. Aaltonen escreveu:
> Hello.
> 
> Mark Brown wrote:
>> On Wed, Feb 02, 2011 at 01:35:01PM -0200, Mauro 
>> Carvalho Chehab wrote:
>>
>> [Reflowed into 80 columns.]
>>> My concerns is that the V4L2-specific part of the code should be at
>>> drivers/media.  I prefer that the specific MFD I/O part to be at
>>> drivers/mfd, just like the other drivers.
>>
>> Currently that's not the case - the I/O functionality is not in any
>> meaningful sense included in the MFD, it's provided by the V4L portion.
> 
> I've been away for two and a half weeks so I haven't been able to
> comment...
> 
> But before I start to make changes, I'd still like to ask for a comment
> on my original plan, which was to have the I/O functions in the MFD
> driver and also have there things like interrupt handling etc.
> 
> My vision was that the MFD part would have the application logic and the
> child drivers would be just true interfaces to the core functionality,
> because I kind of saw the children to be of equal importance and because
> the codec and the v4l2 driver share some controls like for example the
> volume control. 
> 
> If you'd care to take a look an earlier version of the MFD driver here:
> 
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/23602/match=aaltonen
> 
> So the question is if I put only the I/O stuff into the MFD driver or
> can I have the other application logic there as well?

Matti,

Things that are required in order to access the device via MFD should be at
the MFD part (for example, wl1273_fm_read_reg/wl1273_fm_write_cmd/wl1273_fm_write_data). 
The logic that are related to control the radio (wl1273_fm_set_audio,  wl1273_fm_set_volume,
etc) are not related to access the device via the MFD bus. They should be at
the media part of the driver, where they belong.

One example that you could as reference for the mfd/media is the Timeberdale driver. 
The MFD-specific part is at:
	drivers/mfd/timberdale.c

The media part is at:
	drivers/media/video/timblogiw.c

All you'll see at the MFD part is the logic to access the MFD bus and a description
of the devices that will be coupled into it (in this case, it is a multi-function
board). In other words, I/O control and the needed glue to access the I2C devices.
All logic required to control the media driver is at timblogiw.c.

I hope that helps.

Thanks,
Mauro
