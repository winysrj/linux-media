Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab2GEQrR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 12:47:17 -0400
Message-ID: <4FF5C50E.6080109@redhat.com>
Date: Thu, 05 Jul 2012 13:47:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [GIT PULL FOR v3.5] davicni: vpfe:media controller based capture
 driver for dm365
References: <E99FAA59F8D8D34D8A118DD37F7C8F753E939B62@DBDE01.ent.ti.com>
In-Reply-To: <E99FAA59F8D8D34D8A118DD37F7C8F753E939B62@DBDE01.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-07-2012 02:01, Hadli, Manjunath escreveu:
> Mauro,
> Can you please pull the patches? Let me know if anything needs to be done
> from my side.
> 
> -Manju
> 
> 
> On Thu, May 31, 2012 at 17:42:24, Hadli, Manjunath wrote:
>> Mauro,
>>   The following patch set adds the media controller based driver TI dm365 SoC.
>> Patches have gone through RFC and reviews and are pending for some time.
>>
>> The main support added here:
>> -CCDC capture
>> -Previewer
>> -Resizer
>> -AEW/AF
>> -Some media formats supported on dm365
>> -PIX_FORMATs supported on dm365
>>
>>
>> ---
>> The following changes since commit a01ee165a132fadb57659d26246e340d6ac53265:
>>
>>    Merge branch 'for-linus' of git://git.open-osd.org/linux-open-osd (2012-05-28 13:10:41 -0700)
>>
>> are available in the git repository at:
>>
>>    git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git pull_dm365_mc_for_mauro
>>
>> Manjunath Hadli (19):
>>        media: add new mediabus format enums for dm365
>>        v4l2: add new pixel formats supported on dm365
>>        davinci: vpfe: add dm3xx IPIPEIF hardware support module
>>        davinci: vpfe: add IPIPE hardware layer support
>>        davinci: vpfe: add IPIPE support for media controller driver

$ grep copy_ `quilt next`|wc -l
53

Wow! There's a lot of undocumented userspace API stuff there! Am I missing something?

Regards,
Mauro
