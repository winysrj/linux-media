Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:60942 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3IOU6Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Sep 2013 16:58:16 -0400
Message-ID: <52361F61.8050207@gmail.com>
Date: Sun, 15 Sep 2013 22:58:09 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH RFC 2/7] mem2mem_testdev: Use mem-to-mem ioctl and vb2
 helpers
References: <1379076986-10446-1-git-send-email-s.nawrocki@samsung.com>  <1379076986-10446-3-git-send-email-s.nawrocki@samsung.com> <1379077699.4396.16.camel@pizza.hi.pengutronix.de>
In-Reply-To: <1379077699.4396.16.camel@pizza.hi.pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On 09/13/2013 03:08 PM, Philipp Zabel wrote:
> Am Freitag, den 13.09.2013, 14:56 +0200 schrieb Sylwester Nawrocki:
[...]
>> @@ -865,6 +793,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
>>   	dst_vq->ops =&m2mtest_qops;
>>   	dst_vq->mem_ops =&vb2_vmalloc_memops;
>>   	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>> +	dst_vq->lock =&ctx->dev->dev_mutex;
>>
>>   	return vb2_queue_init(dst_vq);
>>   }
>> @@ -945,6 +874,7 @@ static int m2mtest_open(struct file *file)
>>   		kfree(ctx);
>>   		goto open_unlock;
>>   	}
>> +	ctx->fh.m2m_ctx = ctx->m2m_ctx;
>
> Since you added m2m_ctx to v4l2_fh, why not drop ctx->m2m_ctx altogether
> and always use ctx->fh.m2m_ctx instead?

Yes, that might make it a bit cleaner. I guess I wanted to minimize
the necessary changes. I'll amend that in all drivers in this series
for the next iteration, as they all look very similar. Thanks for the
suggestion.

--
Regards,
Sylwester
