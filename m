Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:10398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757591Ab1FINTe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2011 09:19:34 -0400
Message-ID: <4DF0C860.1020908@redhat.com>
Date: Thu, 09 Jun 2011 10:19:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH 00/13] Reduce the gap between DVBv5 API and the specs
References: <20110608172311.0d350ab7@pedra> <BANLkTinhCz0cuu5c52DvFV+Gi0uJc3corg@mail.gmail.com>
In-Reply-To: <BANLkTinhCz0cuu5c52DvFV+Gi0uJc3corg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 09-06-2011 10:06, Manu Abraham escreveu:
> On 6/9/11, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>> There's a huge gap between the DVB specs and the current implementation.
>> This were caused by years of changes that happened at the code but
>> no updates to the specs were done.
>>
>> This patch series tries to reduce this gap.
>>
>> Basically, the headers at include/linux/dvb were included at the API.
>> The Makefile scripting auto-generate references for structs, typedefs
>> and ioctls. With this, it is now easy to identify when something is
>> missing.
>>
>> After adding such logic, I've manually synchronized the specs with the
>> header file and updated the data structures.
>>
>> The work is not complete yet: there are still several ioctl's not
>> documented at the specs:
> 
>> While here, I noticed that one audio ioctl is not used anyware
>> (AUDIO_GET_PTS). There is just the ioctl definition and that's it.
>> I just removed this definition, as removing it won't cause any
>> regression, as no in-kernel driver or dvb-core uses it.
> 
> 
> Please do not apply this patch; the SAA716x FF DVB driver uses the same ioctl.

I'll revert this patch for now, in order to wait for driver submissions
that use this ioctl (and the other ioctl's that are not used anywhere
inside the Kernel).

Thanks,
Mauro
