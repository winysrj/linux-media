Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab2FYTt4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 15:49:56 -0400
Message-ID: <4FE8C0E0.3080104@redhat.com>
Date: Mon, 25 Jun 2012 16:49:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 01/12] saa7164: Use i2c_rc properly to store i2c register
 status
References: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com> <4FE8BC2D.9030902@redhat.com> <CALF0-+UyWjbbPYCKV-AgS=6FZ349D27GrijrYa_RWPUqcfo8rw@mail.gmail.com>
In-Reply-To: <CALF0-+UyWjbbPYCKV-AgS=6FZ349D27GrijrYa_RWPUqcfo8rw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-06-2012 16:42, Ezequiel Garcia escreveu:
> Hi Mauro,
> 
> On Mon, Jun 25, 2012 at 4:29 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>>> diff --git a/drivers/media/video/saa7164/saa7164-i2c.c b/drivers/media/video/saa7164/saa7164-i2c.c
>>> index 26148f7..536f7dc 100644
>>> --- a/drivers/media/video/saa7164/saa7164-i2c.c
>>> +++ b/drivers/media/video/saa7164/saa7164-i2c.c
>>> @@ -123,7 +123,7 @@ int saa7164_i2c_register(struct saa7164_i2c *bus)
>>>        bus->i2c_algo.data = bus;
>>>        bus->i2c_adap.algo_data = bus;
>>>        i2c_set_adapdata(&bus->i2c_adap, bus);
>>> -     i2c_add_adapter(&bus->i2c_adap);
>>> +     bus->i2c_rc = i2c_add_adapter(&bus->i2c_adap);
>>>
>>>        bus->i2c_client.adapter = &bus->i2c_adap;
>>>
>>>
>>
>> -ENODESCRIPTION.
> 
> Okey. Sorry for that.
> 
>>
>> What are you intending with this change? AFAICT, i2c_add_bus_adapter()
>> returns 0 on success and a negative value otherwise. Why should it be
>> stored at bus->i2c_rc?
> 
> My intention was to give i2c_rc its proper use.
> I looked at bttv-i2c.c and cx88-i2c.c and (perhaps wrongly) guessed
> the intended use to i2c_rc was to save i2c registration result.
> 
> Without this patch, where is this bus->i2c_rc variable used?
> Unless I've missed something, to me there are two options:
> - use i2c_rc
> - remove it

If i2c_rc was never initialized, then just remove it. If it is required,
then there's a bug somewhere out there on those drivers.

IMHO, if the I2C bus doesn't register, any driver that requires I2C bus
should return -ENODEV.

It should be noticed that there are a few devices that don't need I2C bus
to work: simple video grabber cards that don't have anything on their I2C.
There are several of them at bttv, and a few at cx88 and saa7134. Maybe that's
the reason why those drivers have a var to indicate if i2c got registered.

> 
> Again sorry for lack of description, I thought it was self-explaining patch.
> 
> If you provide some feedback about proper solution, I can resend the
> patch series.

Thanks!

Mauro
> 
> Thanks,
> Ezequiel.
> 


