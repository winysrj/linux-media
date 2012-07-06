Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab2GFABc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 20:01:32 -0400
Message-ID: <4FF62AD8.2080907@redhat.com>
Date: Thu, 05 Jul 2012 21:01:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4] media: Add stk1160 new driver
References: <1340991243-2951-1-git-send-email-elezegarcia@gmail.com> <4FF61111.7050900@redhat.com> <4FF616E5.6040206@gmail.com>
In-Reply-To: <4FF616E5.6040206@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-07-2012 19:36, Sylwester Nawrocki escreveu:
> On 07/06/2012 12:11 AM, Mauro Carvalho Chehab wrote:
>>> +static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
>>> +{
>>> +	struct stk1160 *dev = video_drvdata(file);
>>> +
>>> +	if (!stk1160_is_owner(dev, file))
>>> +		return -EBUSY;
>>> +
>>> +	return vb2_dqbuf(&dev->vb_vidq, p, file->f_flags&  O_NONBLOCK);
>>
>> Why to use O_NONBLOCK here? it should be doing whatever userspace wants.
> 
> This is OK, since the third argument to vb2_dqbuf() is a boolean indicating
> whether this call should be blocking or not. And a "& O_NONBLOCK" masks this
> information out from file->f_flags.

Ah! OK then.

It might be better to initialize it during vb2 initialization, at open,
instead of requiring this argument every time vb_dqbuf() is called.

Btw, just noticed a minor issue: an space is required before the "&" operator.

Regards,
Mauro
