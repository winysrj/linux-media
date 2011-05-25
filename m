Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:34158 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932678Ab1EYOsJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 10:48:09 -0400
Message-ID: <4DDD16A4.8000300@iki.fi>
Date: Wed, 25 May 2011 17:48:04 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: Steve Kerrison <steve@stevekerrison.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [bug report] cxd2820r: dynamically allocated arrays
References: <20110525144246.GD1358@shale.localdomain>
In-Reply-To: <20110525144246.GD1358@shale.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Dan,

I am just fixing those and also some other fixes.

regards,
Antti

On 05/25/2011 05:42 PM, Dan Carpenter wrote:
> This driver has several places that use dynamically sized arrays.
> It's dangerous to do that in the kernel because the kernel has a
> very small stack.  A bug could cause the stack to overflow and
> corrupt memory.  I seem to recall i2c transfers can be triggered by
> the users but I don't know the details (ie security implications).
>
> Here is an example of what I mean:
>
> static int cxd2820r_tuner_i2c_xfer(struct i2c_adapter *i2c_adap,
>          struct i2c_msg msg[], int num)
> {
>          struct cxd2820r_priv *priv = i2c_get_adapdata(i2c_adap);
>          u8 obuf[msg[0].len + 2];
>                  ^^^^^^^^^^
>          struct i2c_msg msg2[2] = {
>
> If msg[0].len is too long it will overflow.
>
> Here is the sparse output for the file:
>
>    CHECK   drivers/media/dvb/frontends/cxd2820r_core.c
> drivers/media/dvb/frontends/cxd2820r.h:58:30: error: dubious one-bit signed bitfield
> drivers/media/dvb/frontends/cxd2820r.h:64:23: error: dubious one-bit signed bitfield
> drivers/media/dvb/frontends/cxd2820r_priv.h:58:26: error: dubious one-bit signed bitfield
> drivers/media/dvb/frontends/cxd2820r_priv.h:64:31: error: dubious one-bit signed bitfield
> drivers/media/dvb/frontends/cxd2820r_core.c:33:19: error: bad constant expression
> drivers/media/dvb/frontends/cxd2820r_core.c:38:32: error: cannot size expression
> drivers/media/dvb/frontends/cxd2820r_core.c:61:16: error: bad constant expression
> drivers/media/dvb/frontends/cxd2820r_core.c:71:32: error: cannot size expression
> drivers/media/dvb/frontends/cxd2820r_core.c:743:28: error: bad constant expression
> drivers/media/dvb/frontends/cxd2820r_core.c:748:32: error: cannot size expression
> drivers/media/dvb/frontends/cxd2820r_core.c:762:31: error: cannot size expression
>    CC [M]  drivers/media/dvb/frontends/cxd2820r_core.o
>
> regards,
> dan carpenter


-- 
http://palosaari.fi/
