Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:48591 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755065Ab2AYN5R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 08:57:17 -0500
MIME-Version: 1.0
In-Reply-To: <201201201423.46858.laurent.pinchart@ideasonboard.com>
References: <1324891397-10877-1-git-send-email-sumit.semwal@ti.com>
 <1324891397-10877-2-git-send-email-sumit.semwal@ti.com> <201201201423.46858.laurent.pinchart@ideasonboard.com>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Wed, 25 Jan 2012 19:26:52 +0530
Message-ID: <CAB2ybb98BT8L569G_728x1ZXdFNaQCDZzW2+kB0ZNeFak5_g+Q@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 1/3] dma-buf: Introduce dma buffer sharing mechanism
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	arnd@arndb.de, airlied@redhat.com, linux@arm.linux.org.uk,
	patches@linaro.org, jesse.barker@linaro.org, daniel@ffwll.ch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 20, 2012 at 6:53 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Summit,
>
> Sorry for the late review. I know that this code is now in mainline, but I
> still have a couple of comments. I'll send patches if you agree with them.
Hi Laurent,

Thanks for your review; apologies for being late in replying - I was
OoO for last couple of days.
>
> On Monday 26 December 2011 10:23:15 Sumit Semwal wrote:
<snip>
>>
>
> [snip]
>
>> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
>> new file mode 100644
>> index 0000000..e38ad24
>> --- /dev/null
>> +++ b/drivers/base/dma-buf.c
>> @@ -0,0 +1,291 @@
>
> [snip]
>
>> +/**
>> + * dma_buf_export - Creates a new dma_buf, and associates an anon file
>> + * with this buffer, so it can be exported.
>> + * Also connect the allocator specific data and ops to the buffer.
>> + *
>> + * @priv: � �[in] � �Attach private data of allocator to this buffer
>> + * @ops: � � [in] � �Attach allocator-defined dma buf ops to the new buffer.
>> + * @size: � �[in] � �Size of the buffer
>> + * @flags: � [in] � �mode flags for the file.
>> + *
>> + * Returns, on success, a newly created dma_buf object, which wraps the
>> + * supplied private data and operations for dma_buf_ops. On either missing
>> + * ops, or error in allocating struct dma_buf, will return negative error.
>> + *
>> + */
>> +struct dma_buf *dma_buf_export(void *priv, struct dma_buf_ops *ops,
>> + � � � � � � � � � � � � � � size_t size, int flags)
>> +{
>> + � � struct dma_buf *dmabuf;
>> + � � struct file *file;
>> +
>> + � � if (WARN_ON(!priv || !ops
>> + � � � � � � � � � � � || !ops->map_dma_buf
>> + � � � � � � � � � � � || !ops->unmap_dma_buf
>> + � � � � � � � � � � � || !ops->release)) {
>> + � � � � � � return ERR_PTR(-EINVAL);
>> + � � }
>> +
>> + � � dmabuf = kzalloc(sizeof(struct dma_buf), GFP_KERNEL);
>> + � � if (dmabuf == NULL)
>> + � � � � � � return ERR_PTR(-ENOMEM);
>> +
>> + � � dmabuf->priv = priv;
>> + � � dmabuf->ops = ops;
>
> dmabuf->ops will never but NULL, but (see below)
>
<snip>
>> +struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
>> + � � � � � � � � � � � � � � � � � � � struct device *dev)
>> +{
>> + � � struct dma_buf_attachment *attach;
>> + � � int ret;
>> +
>> + � � if (WARN_ON(!dmabuf || !dev || !dmabuf->ops))
>
> you still check dmabuf->ops here, as well as in several places below.
> Shouldn't these checks be removed ?
You're right - these can be removed.
>
>> + � � � � � � return ERR_PTR(-EINVAL);
>> +
>> + � � attach = kzalloc(sizeof(struct dma_buf_attachment), GFP_KERNEL);
>> + � � if (attach == NULL)
>> + � � � � � � goto err_alloc;
>
> What about returning ERR_PTR(-ENOMEM) directly here ?
>
Right; we can do that.
>> +
>> + � � mutex_lock(&dmabuf->lock);
>> +
>> + � � attach->dev = dev;
>> + � � attach->dmabuf = dmabuf;
>
> These two lines can be moved before mutex_lock().
>
:) Yes - thanks for catching this.
<snip>
> --
> Regards,
>
> Laurent Pinchart

Let me know if you'd send patches for these, or should I just go ahead
and correct.

Best regards,
~Sumit.
