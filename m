Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2E1Li2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 07:38:28 -0400
Message-ID: <4FC363A5.1010802@redhat.com>
Date: Mon, 28 May 2012 08:38:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [RFC PATCH 0/3] Improve Kconfig selection for media devices
References: <4FC24E34.3000406@redhat.com> <1338137803-12231-1-git-send-email-mchehab@redhat.com> <20120528114803.0d1a4881@stein>
In-Reply-To: <20120528114803.0d1a4881@stein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-05-2012 06:48, Stefan Richter escreveu:
> On May 27 Mauro Carvalho Chehab wrote:
>> The Kconfig building system is improperly selecting some drivers,
>> like analog TV tuners even when this is not required.
>>
>> Rearrange the Kconfig in a way to prevent that.
>>
>> Mauro Carvalho Chehab (3):
>>   media: reorganize the main Kconfig items
>>   media: Remove VIDEO_MEDIA Kconfig option
>>   media: only show V4L devices based on device type selection
> 
> On 1/3 "media: reorganize the main Kconfig items":
> 
> a) I agree with Sylvester that the MEDIA_WEBCAM_SUPP variable, prompt
> text, and help text should be worded a bit more general.  Wouldn't this
> variable also cover industrial cameras and who knows what other kinds of
> video inputs?  I also agree with Sylvester about the SUPP vs. SUPPORT
> thing.
>
> b) Small typo in the MEDIA_ANALOG_TV_SUPP help text:  of -> or.

Ok, fixed both above issues. I'll post a version 2 patch series soon.

> c) The RC_CORE_SUPP help text gives the impression that RC core is
> always needed if there is hardware with an IR feature.  But the firedtv
> driver is a case where the driver directly works on top of the input
> subsystem rather than on RC core.  Maybe there are more such cases.

All other drivers use RC_CORE, as we've replaced the existing implementations
to use it, removing bad/inconsistent IR code implementations everywhere.
The only driver left is firedtv.

> (Currently we don't ask whether FireDTV owners want IR support; we
> silently build the IR part of firedtv in if CONFIG_INPUT is set, and
> silently omit the IR part of firedtv if CONFIG_INPUT was disabled, which
> requires CONFIG_EXPERT.)
> 
> How about turning the "Remote Controller support" option into merely a
> filter for standalone IR and RF receivers and transmitters, whereas
> Kconfig options in the analog and digital TV categories silently do
> "select RC_CORE if INPUT" for combined tuner + IR/RF rx/tx hardware?

The right thing to do is to convert drivers/media/dvb/firewire/firedtv-rc.c
to use rc-core. There are several issues with the current implementation:

	- IR keycode tables are hardcoded;
	- There is a "magic" to convert a 16 bits scancode (NEC protocol?)
	  into a key;
	- There's no way to replace the existing table to an user-provided
	  one;
	- The IR userspace tools won't work, as it doesn't export the
	  needed sysfs nodes to report an IR.

If you want, I can write a patch doing that, but I can't test it here, as
I don't have a firedtv device.

Regards,
Mauro
