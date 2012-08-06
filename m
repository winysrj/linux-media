Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242Ab2HFQRg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 12:17:36 -0400
Message-ID: <501FEE1D.9080909@redhat.com>
Date: Mon, 06 Aug 2012 13:17:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] Some additional az6007 cleanup patches
References: <1344188679-8247-1-git-send-email-mchehab@redhat.com> <501FE29D.7040303@gmail.com>
In-Reply-To: <501FE29D.7040303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-08-2012 12:28, Roger Mårtensson escreveu:
> Mauro Carvalho Chehab skrev 2012-08-05 19:44:
>> Those are mostly cleanup patches. With regards to suspend/resume,
>> this is not working properly yet. I suspect that it is due to the lack
>> of dvb-usb-v2 support for reset_resume. So, document it.
>>
>> Mauro Carvalho Chehab (3):
>>    [media] az6007: rename "st" to "state" at az6007_power_ctrl()
>>    [media] az6007: make all functions static
>>    [media] az6007: handle CI during suspend/resume
>>
>>   drivers/media/dvb/dvb-usb-v2/az6007.c | 37 +++++++++++++++++++++++++++--------
>>   1 file changed, 29 insertions(+), 8 deletions(-)
>>
> 
> Will all the latest patches also fix the problem with not being able to tune to a new encrypted channel?
> (Terratec H7, DVB-C. Can watch an encrypted channel i Kaffeine but not tune to another. Have to restart Kaffeine. Can tune to an unencrypted channel.)

I doubt, except if there are some bugs at dvb-usb related to CI.

They shouldn't be touching at the CI part of the driver, except for trivial
changes.

I don't have any CI card here, so I'm not able to test or work with
the CI functionality.

Regards,
Mauro
