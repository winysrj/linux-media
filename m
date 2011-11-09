Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48797 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab1KIKlj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Nov 2011 05:41:39 -0500
Message-ID: <4EBA58E0.8080704@iki.fi>
Date: Wed, 09 Nov 2011 12:41:36 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: [RFC 1/2] dvb-core: add generic helper function for I2C register
References: <4EB9C13A.2060707@iki.fi> <4EBA4E3D.80105@redhat.com>
In-Reply-To: <4EBA4E3D.80105@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/09/2011 11:56 AM, Mauro Carvalho Chehab wrote:
> Due to the way I2C locks are bound, doing something like the above and something like:
>
>      struct i2c_msg msg[2] = {
>          {
>              .addr = i2c_cfg->addr,
>              .flags = 0,
>              .buf = buf,
>          },
>          {
>              .addr = i2c_cfg->addr,
>              .flags = 0,
>              .buf = buf2,
>          }
>
>      };
>
>      ret = i2c_transfer(i2c_cfg->adapter, msg, 2);
>
> Produces a different result. In the latter case, I2C core avoids having any other
> transaction in the middle of the 2 messages.

In my understanding adding more messages than one means those should be 
handled as one I2C transaction using REPEATED START.
I see one big problem here, it is our adapters. I think again, for the 
experience I have, most of our I2C-adapters can do only 3 different 
types of I2C xfers;
* I2C write
* I2C write + I2C read (combined with REPEATED START)
* I2C read (I suspect many adapters does not support that)
That means, I2C REPEATED writes  are not possible.

> I like the idea of having some functions to help handling those cases where a single
> transaction needs to be split into several messages.
>
> Yet, I agree with Michael: I would add such logic inside the I2C subsystem, and
> being sure that the lock is kept during the entire I2C operation.
>
> Jean,
> 	Thoughts?

regards
Antti

-- 
http://palosaari.fi/
