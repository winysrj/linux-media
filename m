Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:30790 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbcBPNsg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 08:48:36 -0500
Subject: Re: [PATCH v4 5/8] [Media] vcodec: mediatek: Add Mediatek V4L2 Video
 Encoder Driver
To: tiffany lin <tiffany.lin@mediatek.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1454585703-42428-1-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-2-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-3-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-4-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-5-git-send-email-tiffany.lin@mediatek.com>
 <1454585703-42428-6-git-send-email-tiffany.lin@mediatek.com>
 <56C1B4AF.1030207@xs4all.nl> <1455604653.19396.68.camel@mtksdaap41>
 <56C2D371.9090805@xs4all.nl> <1455628805.19396.82.camel@mtksdaap41>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, daniel.thompson@linaro.org,
	Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <56C328AF.5030604@cisco.com>
Date: Tue, 16 Feb 2016 14:48:31 +0100
MIME-Version: 1.0
In-Reply-To: <1455628805.19396.82.camel@mtksdaap41>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany,

>>>>> +int mtk_vcodec_enc_queue_init(void *priv, struct vb2_queue *src_vq,
>>>>> +			   struct vb2_queue *dst_vq)
>>>>> +{
>>>>> +	struct mtk_vcodec_ctx *ctx = priv;
>>>>> +	int ret;
>>>>> +
>>>>> +	src_vq->type		= V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
>>>>> +	src_vq->io_modes	= VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
>>>>
>>>> I recomment dropping VB2_USERPTR. That only makes sense for scatter-gather dma,
>>>> and you use physically contiguous DMA.
>>>>
>>> Now our userspace app use VB2_USERPTR. I need to check if we could drop
>>> VB2_USERPTR.
>>> We use src_vq->mem_ops = &vb2_dma_contig_memops;
>>> And there are
>>> 	.get_userptr	= vb2_dc_get_userptr,
>>> 	.put_userptr	= vb2_dc_put_userptr,
>>> I was confused why it only make sense for scatter-gather.
>>> Could you kindly explain more?
>>
>> VB2_USERPTR indicates that the application can use malloc to allocate buffers
>> and pass those to the driver. Since malloc uses virtual memory the physical
>> memory is scattered all over. And the first page typically does not start at
>> the beginning of the page but at a random offset.
>>
>> To support that the DMA generally has to be able to do scatter-gather.
>>
>> Now, where things get ugly is that a hack was added to the USERPTR support where
>> apps could pass a pointer to physically contiguous memory as a user pointer. This
>> was a hack for embedded systems that preallocated a pool of buffers and needed to
>> pass those pointers around somehow. So the dma-contig USERPTR support is for that
>> 'feature'. If you try to pass a malloc()ed buffer to a dma-contig driver it will
>> reject it. One big problem is that this specific hack isn't signaled anywhere, so
>> applications have no way of knowing if the USERPTR support is the proper version
>> or the hack where physically contiguous memory is expected.
>>
>> This hack has been replaced with DMABUF which is the proper way of passing buffers
>> around.
>>
>> New dma-contig drivers should not use that old hack anymore. Use dmabuf to pass
>> external buffers around.
>>
>> How do you use it in your app? With malloc()ed buffers? Or with 'special' pointers
>> to physically contiguous buffers?
>>
> Understood now. Thanks for your explanation.
> Now our app use malloc()ed buffers and we hook vb2_dma_contig_memops. 
> I don't know why that dma-contig driver do not reject it.
> I will try to figure it out.

Is there an iommu involved that turns the scatter-gather list into what looks like
contiguous memory for the DMA?

At the end of vb2_dc_get_userptr() in videobuf2-dma-contig.c there is a check
'if (contig_size < size)' that verifies that the sg DMA is contiguous. This would
work if there is an iommu involved (if I understand it correctly).

If that's the case, then it's OK to keep VB2_USERPTR because you have real sg
support (although not via the DMA engine, but via iommu mappings).

Regards,

	Hans
