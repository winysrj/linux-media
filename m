Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:58224 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279AbaAHO1R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 09:27:17 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ300KTU6TG7Q70@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jan 2014 09:27:16 -0500 (EST)
Date: Wed, 08 Jan 2014 12:27:09 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [kbuild-all] [linuxtv-media:master 499/499]
 drivers/media/i2c/s5k5baf.c:362:3: warning: format '%d' expects argument of
 type 'int', but argument 3 has type 'size_t'
Message-id: <20140108122709.39263bb9@samsung.com>
In-reply-to: <52CD53AA.8050804@samsung.com>
References: <52b94458.53lWHr3FG9kOLNn4%fengguang.wu@intel.com>
 <20140108083736.GA27840@mwanda> <20140108102110.1a79579a@samsung.com>
 <52CD53AA.8050804@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 08 Jan 2014 14:33:30 +0100
Andrzej Hajda <a.hajda@samsung.com> escreveu:

> On 01/08/2014 01:21 PM, Mauro Carvalho Chehab wrote:
> > Em Wed, 8 Jan 2014 11:37:37 +0300
> > Dan Carpenter <dan.carpenter@oracle.com> escreveu:
> >
> >> The other thing that concerned me with this was the sparse warning:
> >>
> >> drivers/media/i2c/s5k5baf.c:481:26: error: bad constant expression
> > Hmm...
> > 	static void s5k5baf_write_arr_seq(struct s5k5baf *state, u16 addr,
> > 	                                  u16 count, const u16 *seq)
> > 	{
> > 	        struct i2c_client *c = v4l2_get_subdevdata(&state->sd);
> > 	        __be16 buf[count + 1];
> > 	        int ret, n;
> >
> > Yeah, allocating data like that at stack is not nice.
> >
> > I would simply replace the static allocation here by a dynamic one.
> Sequences are very short (usually few words) and their length is known
> in compile time.
> The only exception are sequences provided by firmware file and for them
> I can add check in s5k5baf_write_nseq to make it safe.
> 
> Replacing it with dynamic allocation seems to me unnecessary in this
> particular case, it would result in memory allocation/free for every
> single access to
> the device. What do you think?

Well, if you know in advance what's the maximum size, just replace it by
something like:

	__be16 buf[64];

and check if count + 1 is less or equal to sizeof(buf).

As the kernel stack is really small, we should avoid allocating large
data there (1KB is large, on that sense).

Also, it would be possible o use i2cdev to inject very large payloads
to be sent to a random I2C device. That could cause a machine OOPS
or to use it to inject a security breach code.

So, we should really avoid using dynamic static allocation, specially
on I2C handlers.

Regards,
Mauro
