Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:59385 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758922AbZAORwc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 12:52:32 -0500
Message-ID: <496F77F2.70906@scram.de>
Date: Thu, 15 Jan 2009 18:52:50 +0100
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Alexey Klimov <klimov.linux@gmail.com>
CC: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCHv2] Add Freescale MC44S803 tuner driver
References: <496E2912.8030604@scram.de> <208cbae30901141714h749086b3vc5e5ae243d81f88a@mail.gmail.com>
In-Reply-To: <208cbae30901141714h749086b3vc5e5ae243d81f88a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexey,

>> +/* This functions tries to identify a MC44S803 tuner by reading the ID
>> +   register. This is hasty. */
>> +struct dvb_frontend *mc44s803_attach(struct dvb_frontend *fe,
>> +        struct i2c_adapter *i2c, struct mc44s803_config *cfg)
>> +{
>> +       struct mc44s803_priv *priv = NULL;
> 
> Do you really need *priv set to NULL here ?

No, it's not needed. Will remove.

>> +       priv = kzalloc(sizeof(struct mc44s803_priv), GFP_KERNEL);
>> +       if (priv == NULL)
>> +               return NULL;
> 
> Maybe return -ENOMEM; ? I don't sure about return NULL, may be your
> variant is right.

NULL is correct here. All tuners are supposed to return NULL on an error during attach().

>> +       if (id != 0x14) {
>> +               printk(KERN_ERROR "MC44S803: unsupported ID "
> 
> You pass the name of driver directly to printk messages in few places.
> Is it better to use such approach:
> #define MC44S803_DRIVER_NAME "mc44s803"
> 
> printk (KERN_ERR MC44S803_DRIVER_NAME ": something\n");
> 
> ?
> What do you think?

You're right. 

Thanks for your comments.
Jochen
