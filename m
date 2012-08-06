Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101Ab2HFMcl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 08:32:41 -0400
Message-ID: <501FB95E.3010602@redhat.com>
Date: Mon, 06 Aug 2012 09:32:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] Convert az6007 to dvb-usb-v2
References: <1344137411-27948-1-git-send-email-mchehab@redhat.com> <501F985D.4040308@iki.fi>
In-Reply-To: <501F985D.4040308@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-08-2012 07:11, Antti Palosaari escreveu:
> On 08/05/2012 06:30 AM, Mauro Carvalho Chehab wrote:
>> Now that dvb-usb-v2 patches got merged, convert az6007 to use it, as,
>> in thesis, several core bugs at dvb-usb were fixed.
>>
>> Also, driver became a little more simple than before, as the number of
>> lines reduced a little bit.
>>
>> No noticeable changes should be noticed... I hope ;)
>>
>> Mauro Carvalho Chehab (5):
>>    [media] dvb-usb-v2: Fix cypress firmware compilation
>>    [media] dvb-usb-v2: Don't ask user to select Cypress firmware module
>>    [media] az6007: convert it to use dvb-usb-v2
>>    [media] az6007: fix the I2C W+R logic
>>    [media] az6007: Fix the number of parameters for QAM setup
>>
>>   drivers/media/dvb/dvb-usb-v2/Kconfig               |  17 +-
>>   drivers/media/dvb/dvb-usb-v2/Makefile              |   6 +-
>>   drivers/media/dvb/{dvb-usb => dvb-usb-v2}/az6007.c | 385 +++++++++------------
>>   drivers/media/dvb/dvb-usb/Kconfig                  |   8 -
>>   drivers/media/dvb/dvb-usb/Makefile                 |   3 -
>>   5 files changed, 178 insertions(+), 241 deletions(-)
>>   rename drivers/media/dvb/{dvb-usb => dvb-usb-v2}/az6007.c (64%)
>>
> 
> Whole patch set looks correct for my eyes.
> Feel free to add tag(s) if you wish to those you want.
> Acked-by: Antti Palosaari <crope@iki.fi>
> Reviewed-by: Antti Palosaari <crope@iki.fi>

Thanks for reviewing it! Patches applied.

> One comment still about those log writings. Documentation says it should be used dev_* logging instead
> of pr_* in case of device driver. But I don't see that error should be fixed when that kind of 
> conversion is done.

We'll likely need to do some janitor's task with printk's inside the entire
subsystem: there are a mix of solutions used there; each driver does its
own way for it.

Regards,
Mauro
