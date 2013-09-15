Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:49504 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3IOVLP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Sep 2013 17:11:15 -0400
Message-ID: <5236226F.40901@gmail.com>
Date: Sun, 15 Sep 2013 23:11:11 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH RFC 1/7] V4L: Add mem2mem ioctl and file operation helpers
References: <1379076986-10446-1-git-send-email-s.nawrocki@samsung.com>  <1379076986-10446-2-git-send-email-s.nawrocki@samsung.com> <1379078027.4396.20.camel@pizza.hi.pengutronix.de>
In-Reply-To: <1379078027.4396.20.camel@pizza.hi.pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On 09/13/2013 03:13 PM, Philipp Zabel wrote:
> Am Freitag, den 13.09.2013, 14:56 +0200 schrieb Sylwester Nawrocki:
>> This patch adds ioctl helpers to the V4L2 mem-to-mem API, so we
>> can avoid several ioctl handlers in the mem-to-mem video node
>> drivers that are simply a pass-through to the v4l2_m2m_* calls.
>> These helpers will only be useful for drivers that use same mutex
>> for both OUTPUT and CAPTURE queue, which is the case for all
>> currently in tree v4l2 m2m drivers.
>> In order to use the helpers the driver are required to use
>> struct v4l2_fh.
>
> this looks good to me.

Thank you for the review.

>> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
>> index 7c43712..dddad5b 100644
>> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
>> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
[...]
>> +/* Videobuf2 ioctl helpers */
>> +
>> +int v4l2_m2m_ioctl_reqbufs(struct file *file, void *priv,
>> +				struct v4l2_requestbuffers *rb)
>> +{
>> +	struct v4l2_fh *fh = file->private_data;
>> +	return v4l2_m2m_reqbufs(file, fh->m2m_ctx, rb);
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_reqbufs);
>> +
>> +int v4l2_m2m_ioctl_querybuf(struct file *file, void *priv,
>> +				struct v4l2_buffer *buf)
>> +{
>> +	struct v4l2_fh *fh = file->private_data;
>> +	return v4l2_m2m_querybuf(file, fh->m2m_ctx, buf);
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_querybuf);
>> +
>> +int v4l2_m2m_ioctl_qbuf(struct file *file, void *priv,
>> +				struct v4l2_buffer *buf)
>> +{
>> +	struct v4l2_fh *fh = file->private_data;
>> +	return v4l2_m2m_qbuf(file, fh->m2m_ctx, buf);
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_qbuf);
>> +
>> +int v4l2_m2m_ioctl_dqbuf(struct file *file, void *priv,
>> +				struct v4l2_buffer *buf)
>> +{
>> +	struct v4l2_fh *fh = file->private_data;
>> +	return v4l2_m2m_dqbuf(file, fh->m2m_ctx, buf);
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_dqbuf);
>> +
>
> Here I'm missing one
>
> +int v4l2_m2m_ioctl_create_bufs(struct file *file, void *priv,
> +			       struct v4l2_create_buffers *create)
> +{
> +	struct v4l2_fh *fh = file->private_data;
> +	return v4l2_m2m_create_bufs(file, fh->m2m_ctx, create);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_create_bufs);

OK, I'll add that in the next iteration. I thought I would need to
add v4l2_m2m_ioctl_prepare_buf() similarly, but it's not necessary,
since vidioc_create_buf() calls directly to videobuf2, so that's
even simpler.

--
Regards,
Sylwester
