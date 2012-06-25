Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51161 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab2FYTnB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 15:43:01 -0400
Received: by bkcji2 with SMTP id ji2so3558764bkc.19
        for <linux-media@vger.kernel.org>; Mon, 25 Jun 2012 12:42:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE8BC2D.9030902@redhat.com>
References: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
	<4FE8BC2D.9030902@redhat.com>
Date: Mon, 25 Jun 2012 16:42:59 -0300
Message-ID: <CALF0-+UyWjbbPYCKV-AgS=6FZ349D27GrijrYa_RWPUqcfo8rw@mail.gmail.com>
Subject: Re: [PATCH 01/12] saa7164: Use i2c_rc properly to store i2c register status
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Jun 25, 2012 at 4:29 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>> diff --git a/drivers/media/video/saa7164/saa7164-i2c.c b/drivers/media/video/saa7164/saa7164-i2c.c
>> index 26148f7..536f7dc 100644
>> --- a/drivers/media/video/saa7164/saa7164-i2c.c
>> +++ b/drivers/media/video/saa7164/saa7164-i2c.c
>> @@ -123,7 +123,7 @@ int saa7164_i2c_register(struct saa7164_i2c *bus)
>>       bus->i2c_algo.data = bus;
>>       bus->i2c_adap.algo_data = bus;
>>       i2c_set_adapdata(&bus->i2c_adap, bus);
>> -     i2c_add_adapter(&bus->i2c_adap);
>> +     bus->i2c_rc = i2c_add_adapter(&bus->i2c_adap);
>>
>>       bus->i2c_client.adapter = &bus->i2c_adap;
>>
>>
>
> -ENODESCRIPTION.

Okey. Sorry for that.

>
> What are you intending with this change? AFAICT, i2c_add_bus_adapter()
> returns 0 on success and a negative value otherwise. Why should it be
> stored at bus->i2c_rc?

My intention was to give i2c_rc its proper use.
I looked at bttv-i2c.c and cx88-i2c.c and (perhaps wrongly) guessed
the intended use to i2c_rc was to save i2c registration result.

Without this patch, where is this bus->i2c_rc variable used?
Unless I've missed something, to me there are two options:
- use i2c_rc
- remove it

Again sorry for lack of description, I thought it was self-explaining patch.

If you provide some feedback about proper solution, I can resend the
patch series.

Thanks,
Ezequiel.
