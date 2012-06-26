Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab2FZVeV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 17:34:21 -0400
Message-ID: <4FEA2ACF.8070400@redhat.com>
Date: Tue, 26 Jun 2012 18:34:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 4/4] tuner-xc2028: tag the usual firmwares to help
 dracut
References: <4FE9169D.5020300@redhat.com> <1340739262-13747-1-git-send-email-mchehab@redhat.com> <1340739262-13747-5-git-send-email-mchehab@redhat.com> <20120626204410.GE3885@kroah.com>
In-Reply-To: <20120626204410.GE3885@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-06-2012 17:44, Greg KH escreveu:
> On Tue, Jun 26, 2012 at 04:34:22PM -0300, Mauro Carvalho Chehab wrote:
>> When tuner-xc2028 is not compiled as a module, dracut will
>> need to copy the firmware inside the initfs image.
>>
>> So, use MODULE_FIRMWARE() to indicate such need.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>   drivers/media/common/tuners/tuner-xc2028.c |    2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
>> index b5ee3eb..2e6c966 100644
>> --- a/drivers/media/common/tuners/tuner-xc2028.c
>> +++ b/drivers/media/common/tuners/tuner-xc2028.c
>> @@ -1375,3 +1375,5 @@ MODULE_DESCRIPTION("Xceive xc2028/xc3028 tuner driver");
>>   MODULE_AUTHOR("Michel Ludwig <michel.ludwig@gmail.com>");
>>   MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
>>   MODULE_LICENSE("GPL");
>> +MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
>> +MODULE_FIRMWARE(XC3028L_DEFAULT_FIRMWARE);
> 
> This is proabably something that needs to get in now, independant of the
> other 3 patches, right?

Yes, this one is independent. 

This were not added before as the firmware names are/used to be device-specific,
and there's a modprobe parameter that allows overriding it.

Currently, all xc3028 devices since a long time uses version 2.7, and all
XC3028L uses version 3.2. (I still have here a device that only works with
a custom v 1.f firmware).

Anyway, it makes sense to at least use the two most common possible firmwares
there.

Regards,
Mauro
