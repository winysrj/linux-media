Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:47360 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932216AbbBCIbt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 03:31:49 -0500
Message-ID: <54D08766.3090808@xs4all.nl>
Date: Tue, 03 Feb 2015 09:31:34 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	adi-buildroot-devel@lists.sourceforge.net,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v2 08/15] media: blackfin: bfin_capture: use vb2_ioctl_*
 helpers
References: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>	<1421965128-10470-9-git-send-email-prabhakar.csengg@gmail.com> <CAHG8p1CrBaD_Rk8tkzXg6HucQQQQNmJ-_rvEa8nUOX3QhKKGxQ@mail.gmail.com>
In-Reply-To: <CAHG8p1CrBaD_Rk8tkzXg6HucQQQQNmJ-_rvEa8nUOX3QhKKGxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/03/15 09:27, Scott Jiang wrote:
> Hi Lad,
> 
> 2015-01-23 6:18 GMT+08:00 Lad, Prabhakar <prabhakar.csengg@gmail.com>:
>> this patch adds support to vb2_ioctl_* helpers.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  drivers/media/platform/blackfin/bfin_capture.c | 108 ++++++-------------------
>>  1 file changed, 23 insertions(+), 85 deletions(-)
>>
>> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
>> index b2eeace..04b85e3 100644
>> --- a/drivers/media/platform/blackfin/bfin_capture.c
>> +++ b/drivers/media/platform/blackfin/bfin_capture.c
>> @@ -272,15 +272,26 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
>>         struct ppi_if *ppi = bcap_dev->ppi;
>>         struct bcap_buffer *buf, *tmp;
>>         struct ppi_params params;
>> +       dma_addr_t addr;
>>         int ret;
>>
>>         /* enable streamon on the sub device */
>>         ret = v4l2_subdev_call(bcap_dev->sd, video, s_stream, 1);
>>         if (ret && (ret != -ENOIOCTLCMD)) {
>>                 v4l2_err(&bcap_dev->v4l2_dev, "stream on failed in subdev\n");
>> +               bcap_dev->cur_frm = NULL;
>>                 goto err;
>>         }
>>
>> +       /* get the next frame from the dma queue */
>> +       bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
>> +                                       struct bcap_buffer, list);
>> +       /* remove buffer from the dma queue */
>> +       list_del_init(&bcap_dev->cur_frm->list);
>> +       addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->cur_frm->vb, 0);
>> +       /* update DMA address */
>> +       ppi->ops->update_addr(ppi, (unsigned long)addr);
>> +
>>         /* set ppi params */
>>         params.width = bcap_dev->fmt.width;
>>         params.height = bcap_dev->fmt.height;
>> @@ -320,6 +331,9 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
>>                 goto err;
>>         }
>>
>> +       /* enable ppi */
>> +       ppi->ops->start(ppi);
>> +
> Still wrong here. You can't start ppi before request dma and irq. Also
> it's not good to update dma address before request dma. Please
> strictly follow the initial sequence in bcap_streamon() because the
> order is important. That means you should put all functions in
> bcap_start_streaming() before those in bcap_streamon().
> And it seems you removed dma buffer check in bcap_streamon(). Yes, in
> vb2_internal_streamon() it will check q->queued_count >=
> q->min_buffers_needed to start streaming. But if the user doesn't
> queue enough buffer, it will return success and set q->streaming = 1.
> Is it really right here?

Yes, that's really right. The V4L2 state is set to streaming after calling
VIDIOC_STREAMON, even if the DMA engine hasn't started yet. That's set
with the start_streaming_called bitfield.

Regards,

	Hans

> 
>>         /* attach ppi DMA irq handler */
>>         ret = ppi->ops->attach_irq(ppi, bcap_isr);
>>         if (ret < 0) {
>> @@ -334,6 +348,9 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
>>         return 0;
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

