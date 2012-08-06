Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:59735 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953Ab2HFGiM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 02:38:12 -0400
Received: by yhpp34 with SMTP id p34so2666592yhp.18
        for <linux-media@vger.kernel.org>; Sun, 05 Aug 2012 23:38:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF6AEGs2evpga=h1+0L0sz+vG1czHff83z13WxdBv+xvcxQKxw@mail.gmail.com>
References: <1342715014-5316-1-git-send-email-rob.clark@linaro.org>
 <1342715014-5316-3-git-send-email-rob.clark@linaro.org> <CAF6AEGs2evpga=h1+0L0sz+vG1czHff83z13WxdBv+xvcxQKxw@mail.gmail.com>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Mon, 6 Aug 2012 12:07:50 +0530
Message-ID: <CAB2ybb-jWWgxNMwRBCOA5W4=y4Q9U-xQHeu+CtNp-eRteA4jxQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] dma-buf: add helpers for attacher dma-parms
To: Rob Clark <rob.clark@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	patches@linaro.org, linux@arm.linux.org.uk, arnd@arndb.de,
	jesse.barker@linaro.org, m.szyprowski@samsung.com, daniel@ffwll.ch,
	t.stanislaws@samsung.com, maarten.lankhorst@canonical.com,
	Rob Clark <rob@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 20, 2012 at 10:09 PM, Rob Clark <rob.clark@linaro.org> wrote:
> Fyi, Daniel Vetter had suggested on IRC that it would be cleaner to
> have a single helper fxn that most-restrictive union of all attached
> device's dma_parms.  Really this should include dma_mask and
> coherent_dma_mask, I think.  But that touches a lot of other places in
> the code.  If no one objects to the cleanup of moving
> dma_mask/coherent_dma_mask into dma_parms, I'll do this first.
>
> So anyways, don't consider this patch yet for inclusion, I'll make an
> updated one based on dma_parms..
Hi Rob,
Any news on this patch-set?
>
> BR,
> -R
BR,
~Sumit.
>
> On Thu, Jul 19, 2012 at 11:23 AM, Rob Clark <rob.clark@linaro.org> wrote:
>> From: Rob Clark <rob@ti.com>
>>
>> Add some helpers to iterate through all attachers and get the most
>> restrictive segment size/count/boundary.
>>
>> Signed-off-by: Rob Clark <rob@ti.com>
>> ---
>>  drivers/base/dma-buf.c  |   63 +++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/dma-buf.h |   19 ++++++++++++++
>>  2 files changed, 82 insertions(+)
>>
>> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
>> index 24e88fe..757ee20 100644
>> --- a/drivers/base/dma-buf.c
>> +++ b/drivers/base/dma-buf.c
>> @@ -192,6 +192,69 @@ void dma_buf_put(struct dma_buf *dmabuf)
>>  EXPORT_SYMBOL_GPL(dma_buf_put);
>>
>>  /**
>> + * dma_buf_max_seg_size - helper for exporters to get the minimum of
>> + * all attached device's max segment size
>> + */
>> +unsigned int dma_buf_max_seg_size(struct dma_buf *dmabuf)
>> +{
>> +       struct dma_buf_attachment *attach;
>> +       unsigned int max = (unsigned int)-1;
>> +
>> +       if (WARN_ON(!dmabuf))
>> +               return 0;
>> +
>> +       mutex_lock(&dmabuf->lock);
>> +       list_for_each_entry(attach, &dmabuf->attachments, node)
>> +               max = min(max, dma_get_max_seg_size(attach->dev));
>> +       mutex_unlock(&dmabuf->lock);
>> +
>> +       return max;
>> +}
>> +EXPORT_SYMBOL_GPL(dma_buf_max_seg_size);
>> +
>> +/**
>> + * dma_buf_max_seg_count - helper for exporters to get the minimum of
>> + * all attached device's max segment count
>> + */
>> +unsigned int dma_buf_max_seg_count(struct dma_buf *dmabuf)
>> +{
>> +       struct dma_buf_attachment *attach;
>> +       unsigned int max = (unsigned int)-1;
>> +
>> +       if (WARN_ON(!dmabuf))
>> +               return 0;
>> +
>> +       mutex_lock(&dmabuf->lock);
>> +       list_for_each_entry(attach, &dmabuf->attachments, node)
>> +               max = min(max, dma_get_max_seg_count(attach->dev));
>> +       mutex_unlock(&dmabuf->lock);
>> +
>> +       return max;
>> +}
>> +EXPORT_SYMBOL_GPL(dma_buf_max_seg_count);
>> +
>> +/**
>> + * dma_buf_get_seg_boundary - helper for exporters to get the most
>> + * restrictive segment alignment of all the attached devices
>> + */
>> +unsigned int dma_buf_get_seg_boundary(struct dma_buf *dmabuf)
>> +{
>> +       struct dma_buf_attachment *attach;
>> +       unsigned int mask = (unsigned int)-1;
>> +
>> +       if (WARN_ON(!dmabuf))
>> +               return 0;
>> +
>> +       mutex_lock(&dmabuf->lock);
>> +       list_for_each_entry(attach, &dmabuf->attachments, node)
>> +               mask &= dma_get_seg_boundary(attach->dev);
>> +       mutex_unlock(&dmabuf->lock);
>> +
>> +       return mask;
>> +}
>> +EXPORT_SYMBOL_GPL(dma_buf_get_seg_boundary);
>> +
>> +/**
>>   * dma_buf_attach - Add the device to dma_buf's attachments list; optionally,
>>   * calls attach() of dma_buf_ops to allow device-specific attach functionality
>>   * @dmabuf:    [in]    buffer to attach device to.
>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>> index eb48f38..9533b9b 100644
>> --- a/include/linux/dma-buf.h
>> +++ b/include/linux/dma-buf.h
>> @@ -167,6 +167,10 @@ int dma_buf_fd(struct dma_buf *dmabuf, int flags);
>>  struct dma_buf *dma_buf_get(int fd);
>>  void dma_buf_put(struct dma_buf *dmabuf);
>>
>> +unsigned int dma_buf_max_seg_size(struct dma_buf *dmabuf);
>> +unsigned int dma_buf_max_seg_count(struct dma_buf *dmabuf);
>> +unsigned int dma_buf_get_seg_boundary(struct dma_buf *dmabuf);
>> +
>>  struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
>>                                         enum dma_data_direction);
>>  void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
>> @@ -220,6 +224,21 @@ static inline void dma_buf_put(struct dma_buf *dmabuf)
>>         return;
>>  }
>>
>> +static inline unsigned int dma_buf_max_seg_size(struct dma_buf *dmabuf)
>> +{
>> +       return 0;
>> +}
>> +
>> +static inline unsigned int dma_buf_max_seg_count(struct dma_buf *dmabuf)
>> +{
>> +       return 0;
>> +}
>> +
>> +static inline unsigned int dma_buf_get_seg_boundary(struct dma_buf *dmabuf)
>> +{
>> +       return 0;
>> +}
>> +
>>  static inline struct sg_table *dma_buf_map_attachment(
>>         struct dma_buf_attachment *attach, enum dma_data_direction write)
>>  {
>> --
>> 1.7.9.5
>>
