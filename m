Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:47157 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549Ab1DXM4E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2011 08:56:04 -0400
Message-ID: <4DB41DDF.2@infradead.org>
Date: Sun, 24 Apr 2011 09:55:59 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>
Subject: Re: [PATCH] ngene: Fix CI data transfer regression
References: <201103292235.25151@orion.escape-edv.de> <201104231831.06846@orion.escape-edv.de>
In-Reply-To: <201104231831.06846@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-04-2011 13:31, Oliver Endriss escreveu:
> On Tuesday 29 March 2011 22:35:24 Oliver Endriss wrote:
>> Fix CI data transfer regression introduced by previous cleanup.
>>
>> Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
>> ---
>>  drivers/media/dvb/ngene/ngene-core.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
>> index 175a0f6..9630705 100644
>> --- a/drivers/media/dvb/ngene/ngene-core.c
>> +++ b/drivers/media/dvb/ngene/ngene-core.c
>> @@ -1520,6 +1520,7 @@ static int init_channel(struct ngene_channel *chan)
>>  	if (dev->ci.en && (io & NGENE_IO_TSOUT)) {
>>  		dvb_ca_en50221_init(adapter, dev->ci.en, 0, 1);
>>  		set_transfer(chan, 1);
>> +		chan->dev->channel[2].DataFormatFlags = DF_SWAP32;
>>  		set_transfer(&chan->dev->channel[2], 1);
>>  		dvb_register_device(adapter, &chan->ci_dev,
>>  				    &ngene_dvbdev_ci, (void *) chan,
>> -- 
>> 1.6.5.3
>>
> 
> What happened to this patch? I am sure that it was in patchwork, but
> patchwork apparently lost all patches between February 26th and
> April 16th.

Yes, patchwork seemed to have a problem. They have 2 patchwork instances there,
on a cluster environment. In the past, we have the same problem when the backup
instance started with some patches out of sync on their mySQL datababse. After
I pointed the issue, they fixed it on the next day.

I sent one email last week about it to the kernel.org maintainer asking for his help, 
but didn't get an answer yet. Maybe he got some PTO days due to Easter. I'm hoping
that we'll be able to get it recovered next week.
> 
> Please note that this patch must go to 2.6.39!
> 
> CU
> Oliver
> 

