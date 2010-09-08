Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab0IHXQD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 19:16:03 -0400
Message-ID: <4C881939.7030908@redhat.com>
Date: Wed, 08 Sep 2010 20:16:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] V4L/DVB: dib7770: enable the current mirror
References: <1283874646-20770-1-git-send-email-Patrick.Boettcher@dibcom.fr> <201009071758.24178.pboettcher@kernellabs.com>
In-Reply-To: <201009071758.24178.pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 07-09-2010 12:58, Patrick Boettcher escreveu:
> Hi Mauro,
> 
> On Tuesday 07 September 2010 17:50:45 pboettcher@kernellabs.com wrote:
>> From: Olivier Grenie <olivier.grenie@dibcom.fr>
>>
>> To improve performance on DiB7770-devices enabling the current mirror
>> is needed.
>>
>> This patch adds an option to the dib7000p-driver to do that and it
>> creates a separate device-entry in dib0700-device to use those changes
>> on hardware which is using the DiB7770.
>>
>> Cc: stable@kernel.org
>>
>> Signed-off-by: Olivier Grenie <olivier.grenie@dibcom.fr>
>> Signed-off-by: Patrick Boettcher <patrick.boettcher@dibcom.fr>
>> ---
>>  drivers/media/dvb/dvb-usb/dib0700_devices.c |   53
>> ++++++++++++++++++++++++++- drivers/media/dvb/frontends/dib7000p.c      | 
>>   2 +
>>  drivers/media/dvb/frontends/dib7000p.h      |    3 ++
>>  3 files changed, 57 insertions(+), 1 deletions(-)
> 
> This is the patch I was talking to you about in my last Email. This one needs 
> to be quickly applied to 2.6.35. Well ... quickly ... as soon as possible in  
> sense of when you have a free time slot.
> 
> This patch help to optimize the performance of the DiB7770-chip which can be 
> found in several devices out there right now.
> 
> It was tested and applied on 2.6.36-rc3, It should apply cleanly on 2.6.35.

Ok. Patch 2/2 is also important for -stable?

> 
> Thanks in advance for your help,
> 
> Patrick.

Cheers,
Mauro
