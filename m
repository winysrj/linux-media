Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab2E0Pyp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 11:54:45 -0400
Message-ID: <4FC24E34.3000406@redhat.com>
Date: Sun, 27 May 2012 12:54:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v3.5-rc1] media updates for v3.5
References: <4FBE5518.5090705@redhat.com> <CA+55aFyt2OFOsr5uCpQ6nrur4zhHhmWUJrvMgLH_Wy1niTbC6w@mail.gmail.com> <4FBEB72D.4040905@redhat.com> <CA+55aFyYQkrtgvG99ZOOhAzoKi8w5rJfRgZQy3Dqs39p1n=FPA@mail.gmail.com> <4FBF773B.10408@redhat.com> <20120526003856.7e4efd77@stein> <4FC23E73.3080901@redhat.com>
In-Reply-To: <4FC23E73.3080901@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-05-2012 11:47, Mauro Carvalho Chehab escreveu:
> Em 25-05-2012 19:38, Stefan Richter escreveu:
>> On May 25 Mauro Carvalho Chehab wrote:
>>> A simple way to solve it seems to make those options dependent on CONFIG_EXPERT.
>>>
>>> Not sure if all usual distributions disable it, but I guess most won't have
>>> EXPERT enabled.
>>>
>>> The enclosed patch does that. If nobody complains, I'll submit it together
>>> with the next git pull request.
>>
>> I only want dvb-core and firedtv.  But when I switch off
>> CONFIG_MEDIA_TUNER_CUSTOMISE, suddenly also
>>
>>   CC [M]  drivers/media/common/tuners/tuner-xc2028.o
>>   CC [M]  drivers/media/common/tuners/tuner-simple.o
>>   CC [M]  drivers/media/common/tuners/tuner-types.o
>>   CC [M]  drivers/media/common/tuners/mt20xx.o
>>   CC [M]  drivers/media/common/tuners/tda8290.o
>>   CC [M]  drivers/media/common/tuners/tea5767.o
>>   CC [M]  drivers/media/common/tuners/tea5761.o
>>   CC [M]  drivers/media/common/tuners/tda9887.o
>>   CC [M]  drivers/media/common/tuners/tda827x.o
>>   CC [M]  drivers/media/common/tuners/tda18271-maps.o
>>   CC [M]  drivers/media/common/tuners/tda18271-common.o
>>   CC [M]  drivers/media/common/tuners/tda18271-fe.o
>>   CC [M]  drivers/media/common/tuners/xc5000.o
>>   CC [M]  drivers/media/common/tuners/xc4000.o
>>   CC [M]  drivers/media/common/tuners/mc44s803.o
>>   LD [M]  drivers/media/common/tuners/tda18271.o
>>
>> are built.  Why is that?
> 
> Those are the tuners supported by the tuner_core logic. The tuner_core module
> is required by all TV drivers that have analog support.
> 
> After the tuner rework to allow a driver under drivers/media/dvb to use the
> same tuner module as the ../v4l modules, there are now pure dvb drivers that
> don't use tune_core.
> 
> So, it makes sense to add a new config for tuner_core that will be
> selected only for devices with analog TV support.

The correct fix for it seems to change the Kconfig menu to be like:

<m> Multimedia support  --->
   [ ]   Webcams and video grabbers support
   [ ]   Analog TV API and drivers support
   [ ]   Digital TV support
   [ ]   AM/FM radio receivers/transmitters support
   [ ]   Remote Controller support

and only select the tuner-core drivers if analog TV is selected.

I'll write some RFC patches for it for 3.6, posting them at linux-media.

Regards,
Mauro
