Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:42155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674Ab1EDARd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 20:17:33 -0400
Message-ID: <4DC09B15.8030704@redhat.com>
Date: Tue, 03 May 2011 21:17:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH] cx18: Clean up mmap() support for raw YUV
References: <4DBFDF71.5090705@redhat.com>	 <1304423860-12785-1-git-send-email-simon.farnsworth@onelan.co.uk>	 <b418b252-4152-4666-9c83-85e91613b493@email.android.com>	 <4DC08961.3060508@redhat.com> <1304465916.2648.3.camel@localhost>
In-Reply-To: <1304465916.2648.3.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-05-2011 20:38, Andy Walls escreveu:
> On Tue, 2011-05-03 at 20:01 -0300, Mauro Carvalho Chehab wrote:
>> Em 03-05-2011 19:51, Andy Walls escreveu:
>>> Simon Farnsworth <simon.farnsworth@onelan.co.uk> wrote:
>  
> 
>>> Simon,
>>>
>>> If these two changes are going in, please also bump the driver
>> version to 1.5.0 in cx18-version.c.  These changes are significant
>> enough perturbation.
>>>
>>> End users are going to look to driver version 1.4.1 as the first
>> version for proper analog tuner support of the HVR1600 model 74351.
>>>
>>> Mauro,
>>>
>>> Is cx18 v1.4.1 with HVR1600 model 74351 analog tuner support,
>> without these mmap() changes going to be visible in kernel
>> version .39 ?
>>
>> Hmm... This is what I have at my for_upstream tree:
>>
>> $ git grep -i 74351 drivers/media/video/cx18/
>> drivers/media/video/cx18/cx18-driver.c:   case 74351: /* OEM models */
>>
>> drivers/media/video/cx18/cx18-version.h:#define CX18_DRIVER_VERSION_MAJOR 1
>> drivers/media/video/cx18/cx18-version.h:#define CX18_DRIVER_VERSION_MINOR 4
>> drivers/media/video/cx18/cx18-version.h:#define CX18_DRIVER_VERSION_PATCHLEVEL 0
>>
> 
> I was refering to these patches (which look like they are destined for
> 2.6.40 according to the subject lines)
> 
> http://thread.gmane.org/gmane.comp.video.linuxtv.scm/9918
> http://thread.gmane.org/gmane.comp.video.linuxtv.scm/9917

Yes they are at the for v2.6.40 series of patches.

Mauro.
