Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:50449 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbaAHMVR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 07:21:17 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ300LVK0ZGG260@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jan 2014 07:21:16 -0500 (EST)
Date: Wed, 08 Jan 2014 10:21:10 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: kbuild test robot <fengguang.wu@intel.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>, kbuild-all@01.org,
	linux-media@vger.kernel.org
Subject: Re: [kbuild-all] [linuxtv-media:master 499/499]
 drivers/media/i2c/s5k5baf.c:362:3: warning: format '%d' expects argument of
 type 'int', but argument 3 has type 'size_t'
Message-id: <20140108102110.1a79579a@samsung.com>
In-reply-to: <20140108083736.GA27840@mwanda>
References: <52b94458.53lWHr3FG9kOLNn4%fengguang.wu@intel.com>
 <20140108083736.GA27840@mwanda>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 8 Jan 2014 11:37:37 +0300
Dan Carpenter <dan.carpenter@oracle.com> escreveu:

> The other thing that concerned me with this was the sparse warning:
> 
> drivers/media/i2c/s5k5baf.c:481:26: error: bad constant expression

Hmm...
	static void s5k5baf_write_arr_seq(struct s5k5baf *state, u16 addr,
	                                  u16 count, const u16 *seq)
	{
	        struct i2c_client *c = v4l2_get_subdevdata(&state->sd);
	        __be16 buf[count + 1];
	        int ret, n;

Yeah, allocating data like that at stack is not nice.

I would simply replace the static allocation here by a dynamic one.
 
> It was hard to verify that this couldn't go over 512.  I guess 512 is
> what we would consider an error in this context.  This seems like it
> could be determined by the firmware?
> 
> regards,
> dan carpenter
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
