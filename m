Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20221 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbaAHNdz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 08:33:55 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ300B4I4CIXD20@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jan 2014 13:33:54 +0000 (GMT)
Message-id: <52CD53AA.8050804@samsung.com>
Date: Wed, 08 Jan 2014 14:33:30 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [kbuild-all] [linuxtv-media:master 499/499]
 drivers/media/i2c/s5k5baf.c:362:3: warning: format '%d' expects argument of
 type 'int', but argument 3 has type 'size_t'
References: <52b94458.53lWHr3FG9kOLNn4%fengguang.wu@intel.com>
 <20140108083736.GA27840@mwanda> <20140108102110.1a79579a@samsung.com>
In-reply-to: <20140108102110.1a79579a@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/08/2014 01:21 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 8 Jan 2014 11:37:37 +0300
> Dan Carpenter <dan.carpenter@oracle.com> escreveu:
>
>> The other thing that concerned me with this was the sparse warning:
>>
>> drivers/media/i2c/s5k5baf.c:481:26: error: bad constant expression
> Hmm...
> 	static void s5k5baf_write_arr_seq(struct s5k5baf *state, u16 addr,
> 	                                  u16 count, const u16 *seq)
> 	{
> 	        struct i2c_client *c = v4l2_get_subdevdata(&state->sd);
> 	        __be16 buf[count + 1];
> 	        int ret, n;
>
> Yeah, allocating data like that at stack is not nice.
>
> I would simply replace the static allocation here by a dynamic one.
Sequences are very short (usually few words) and their length is known
in compile time.
The only exception are sequences provided by firmware file and for them
I can add check in s5k5baf_write_nseq to make it safe.

Replacing it with dynamic allocation seems to me unnecessary in this
particular case, it would result in memory allocation/free for every
single access to
the device. What do you think?

Regards
Andrzej

>  
>> It was hard to verify that this couldn't go over 512.  I guess 512 is
>> what we would consider an error in this context.  This seems like it
>> could be determined by the firmware?
>>
>> regards,
>> dan carpenter
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

