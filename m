Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx01.sz.bfs.de ([194.94.69.103]:52805 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab2JGQyn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Oct 2012 12:54:43 -0400
Message-ID: <5071B3D1.6080004@bfs.de>
Date: Sun, 07 Oct 2012 18:54:41 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Michael Buesch <m@bues.ch>, kernel-janitors@vger.kernel.org,
	rmallon@gmail.com, shubhrajyoti@ti.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/13] drivers/media/tuners/fc0011.c: use macros for i2c_msg
 initialization
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr> <1349624323-15584-11-git-send-email-Julia.Lawall@lip6.fr> <5071B147.3010708@bfs.de> <alpine.DEB.2.02.1210071845030.2745@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1210071845030.2745@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 07.10.2012 18:50, schrieb Julia Lawall:
> On Sun, 7 Oct 2012, walter harms wrote:
> 
>>
>>
>> Am 07.10.2012 17:38, schrieb Julia Lawall:
>>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>>
>>> Introduce use of I2c_MSG_READ/WRITE/OP, for readability.
>>>
>>> A length expressed as an explicit constant is also re-expressed as
>>> the size
>>> of the buffer in each case.
>>>
>>> A simplified version of the semantic patch that makes this change is as
>>> follows: (http://coccinelle.lip6.fr/)
>>>
>>> // <smpl>
>>> @@
>>> expression a,b,c;
>>> identifier x;
>>> @@
>>>
>>> struct i2c_msg x =
>>> - {.addr = a, .buf = b, .len = c, .flags = I2C_M_RD}
>>> + I2C_MSG_READ(a,b,c)
>>>  ;
>>>
>>> @@
>>> expression a,b,c;
>>> identifier x;
>>> @@
>>>
>>> struct i2c_msg x =
>>> - {.addr = a, .buf = b, .len = c, .flags = 0}
>>> + I2C_MSG_WRITE(a,b,c)
>>>  ;
>>>
>>> @@
>>> expression a,b,c,d;
>>> identifier x;
>>> @@
>>>
>>> struct i2c_msg x =
>>> - {.addr = a, .buf = b, .len = c, .flags = d}
>>> + I2C_MSG_OP(a,b,c,d)
>>>  ;
>>> // </smpl>
>>>
>>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>>
>>> ---
>>>  drivers/media/tuners/fc0011.c |    9 +++------
>>>  1 file changed, 3 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/media/tuners/fc0011.c
>>> b/drivers/media/tuners/fc0011.c
>>> index e488254..5dbba98 100644
>>> --- a/drivers/media/tuners/fc0011.c
>>> +++ b/drivers/media/tuners/fc0011.c
>>> @@ -80,8 +80,7 @@ struct fc0011_priv {
>>>  static int fc0011_writereg(struct fc0011_priv *priv, u8 reg, u8 val)
>>>  {
>>>      u8 buf[2] = { reg, val };
>>> -    struct i2c_msg msg = { .addr = priv->addr,
>>> -        .flags = 0, .buf = buf, .len = 2 };
>>> +    struct i2c_msg msg = I2C_MSG_WRITE(priv->addr, buf, sizeof(buf));
>>>
>>>      if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
>>>          dev_err(&priv->i2c->dev,
>>> @@ -97,10 +96,8 @@ static int fc0011_readreg(struct fc0011_priv
>>> *priv, u8 reg, u8 *val)
>>>  {
>>>      u8 dummy;
>>>      struct i2c_msg msg[2] = {
>>> -        { .addr = priv->addr,
>>> -          .flags = 0, .buf = &reg, .len = 1 },
>>> -        { .addr = priv->addr,
>>> -          .flags = I2C_M_RD, .buf = val ? : &dummy, .len = 1 },
>>> +        I2C_MSG_WRITE(priv->addr, &reg, sizeof(reg)),
>>> +        I2C_MSG_READ(priv->addr, val ? : &dummy, sizeof(dummy)),
>>>      };
>>>
>>
>> This dummy looks strange, can it be that this is used uninitialised ?
> 
> I'm not sure to understand the question.  The read, when it happens in
> i2c_transfer will initialize dummy.  On the other hand, I don't know
> what i2c_transfer does when the buffer is NULL and the size is 1.  It
> does not look very elegant at least.
> 

mea culpa, i mixed read and write

re,
 wh

> julia
> 
> 
