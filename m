Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:26725
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512Ab2JHFNQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Oct 2012 01:13:16 -0400
Date: Mon, 8 Oct 2012 07:13:13 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Ryan Mallon <rmallon@gmail.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	kernel-janitors@vger.kernel.org, shubhrajyoti@ti.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/13] drivers/media/tuners/max2165.c: use macros for
 i2c_msg initialization
In-Reply-To: <5071FEC1.10507@gmail.com>
Message-ID: <alpine.DEB.2.02.1210080712561.1972@localhost6.localdomain6>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr> <1349624323-15584-14-git-send-email-Julia.Lawall@lip6.fr> <5071FEC1.10507@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Oct 2012, Ryan Mallon wrote:

> On 08/10/12 02:38, Julia Lawall wrote:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Introduce use of I2c_MSG_READ/WRITE/OP, for readability.
>>
>> A length expressed as an explicit constant is also re-expressed as the size
>> of the buffer, when this is possible.
>>
>> The second case is simplified to use simple variables rather than arrays.
>> The variable b0 is dropped completely, and the variable reg that it
>> contains is used instead.  The variable b1 is replaced by a u8-typed
>> variable named buf (the name used earlier in the file).  The uses of b1 are
>> then adjusted accordingly.
>>
>> A simplified version of the semantic patch that makes this change is as
>> follows: (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> expression a,b,c;
>> identifier x;
>> @@
>>
>> struct i2c_msg x =
>> - {.addr = a, .buf = b, .len = c, .flags = I2C_M_RD}
>> + I2C_MSG_READ(a,b,c)
>>  ;
>>
>> @@
>> expression a,b,c;
>> identifier x;
>> @@
>>
>> struct i2c_msg x =
>> - {.addr = a, .buf = b, .len = c, .flags = 0}
>> + I2C_MSG_WRITE(a,b,c)
>>  ;
>>
>> @@
>> expression a,b,c,d;
>> identifier x;
>> @@
>>
>> struct i2c_msg x =
>> - {.addr = a, .buf = b, .len = c, .flags = d}
>> + I2C_MSG_OP(a,b,c,d)
>>  ;
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> ---
>>
>>  drivers/media/tuners/max2165.c |   13 ++++++-------
>>  1 file changed, 6 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/media/tuners/max2165.c b/drivers/media/tuners/max2165.c
>> index ba84936..6638617 100644
>> --- a/drivers/media/tuners/max2165.c
>> +++ b/drivers/media/tuners/max2165.c
>> @@ -47,7 +47,7 @@ static int max2165_write_reg(struct max2165_priv *priv, u8 reg, u8 data)
>>  {
>>  	int ret;
>>  	u8 buf[] = { reg, data };
>> -	struct i2c_msg msg = { .flags = 0, .buf = buf, .len = 2 };
>> +	struct i2c_msg msg = I2C_MSG_WRITE(0, buf, sizeof(buf));
>>
>>  	msg.addr = priv->config->i2c_address;
>>
>> @@ -68,11 +68,10 @@ static int max2165_read_reg(struct max2165_priv *priv, u8 reg, u8 *p_data)
>>  	int ret;
>>  	u8 dev_addr = priv->config->i2c_address;
>>
>> -	u8 b0[] = { reg };
>> -	u8 b1[] = { 0 };
>> +	u8 buf;
>>  	struct i2c_msg msg[] = {
>> -		{ .addr = dev_addr, .flags = 0, .buf = b0, .len = 1 },
>> -		{ .addr = dev_addr, .flags = I2C_M_RD, .buf = b1, .len = 1 },
>> +		I2C_MSG_WRITE(dev_addr, &reg, sizeof(reg)),
>> +		I2C_MSG_READ(dev_addr, &buf, sizeof(buf)),
>>  	};
>
> Not sure if the array changes should be done here or as a separate
> patch. Some of the other patches also have cases where single index
> arrays (both buffers and messages) could be converted. Should either
> convert all or none of them. I think its probably best to do as a
> separate series on top of this though.

OK, I will do it that way.

thanks,
julia
