Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:54364 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaABV6v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jan 2014 16:58:51 -0500
Received: by mail-ee0-f53.google.com with SMTP id b57so6475139eek.40
        for <linux-media@vger.kernel.org>; Thu, 02 Jan 2014 13:58:50 -0800 (PST)
Message-ID: <52C5E15C.8060000@googlemail.com>
Date: Thu, 02 Jan 2014 22:59:56 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3 11/24] tvp5150: make read operations atomic
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com> <1388232976-20061-12-git-send-email-mchehab@redhat.com> <52C463D8.7020406@googlemail.com> <20140102172031.325d89fb@samsung.com>
In-Reply-To: <20140102172031.325d89fb@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02.01.2014 20:20, Mauro Carvalho Chehab wrote:
> Em Wed, 01 Jan 2014 19:52:08 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 28.12.2013 13:16, schrieb Mauro Carvalho Chehab:
>>> From: Mauro Carvalho Chehab <m.chehab@samsung.com>
>>>
>>> Instead of using two I2C operations between write and read,
>>> use just one i2c_transfer. That allows I2C mutexes to not
>>> let any other I2C transfer between the two.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
>>> ---
>>>   drivers/media/i2c/tvp5150.c | 22 ++++++++++------------
>>>   1 file changed, 10 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
>>> index 89c0b13463b7..d6ba457fcf67 100644
>>> --- a/drivers/media/i2c/tvp5150.c
>>> +++ b/drivers/media/i2c/tvp5150.c
>>> @@ -58,21 +58,19 @@ static int tvp5150_read(struct v4l2_subdev *sd, unsigned char addr)
>>>   	struct i2c_client *c = v4l2_get_subdevdata(sd);
>>>   	unsigned char buffer[1];
>>>   	int rc;
>>> +	struct i2c_msg msg[] = {
>>> +		{ .addr = c->addr, .flags = 0,
>>> +		  .buf = &addr, .len = 1 },
>> I would use        .buf = buffer        here, too.
> Why? The address needed is already at addr, and it is also an unsigned char.
>
> Using buffer would require an extra data copy.
You are still doing this...

>
>>
>>> +		{ .addr = c->addr, .flags = I2C_M_RD,
>>> +		  .buf = buffer, .len = 1 }
>>> +	};
>>>   
>>>   	buffer[0] = addr;
... here. ;)

>>>   
>>> -	rc = i2c_master_send(c, buffer, 1);
>>> -	if (rc < 0) {
>>> -		v4l2_err(sd, "i2c i/o error: rc == %d (should be 1)\n", rc);
>>> -		return rc;
>>> -	}
>>> -
>>> -	msleep(10);
>> That's the critical change.
> I don't think so. I'm not sure why I added this at the first place on the
> original patch with where I added this driver, but it is very doubtful
> that a msleep() is needed here.
>
> This code is really old (from the time I added support for WinTV USB 2).
>
> I suspect I added the sleep there just because the I2C logs, during the
> driver development phase, to be an exact mimic on what it was got via
> USB dumps.
>
>>> -
>>> -	rc = i2c_master_recv(c, buffer, 1);
>>> -	if (rc < 0) {
>>> -		v4l2_err(sd, "i2c i/o error: rc == %d (should be 1)\n", rc);
>>> -		return rc;
>>> +	rc = i2c_transfer(c->adapter, msg, 2);
>>> +	if (rc < 0 || rc != 2) {
>>> +		v4l2_err(sd, "i2c i/o error: rc == %d (should be 2)\n", rc);
>>> +		return rc < 0 ? rc : -EIO;
>>>   	}
>>>   
>>>   	v4l2_dbg(2, debug, sd, "tvp5150: read 0x%02x = 0x%02x\n", addr, buffer[0]);
>> Looks good and works without problems with my HVR-900 and WinTV 2
>> devices (both em28xx).
>>
>

