Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31566 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab2DSLip (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 07:38:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M2Q0011Q5OQGP00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 19 Apr 2012 12:38:51 +0100 (BST)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0M2Q00M6F5OHZO@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 19 Apr 2012 12:38:42 +0100 (BST)
Date: Thu, 19 Apr 2012 13:38:37 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH v4 11/14] v4l: vb2-dma-contig: add support for dma_buf
 importing
In-reply-to: <1933889.sK9pAxfEdI@avalon>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: pawel@osciak.com, mchehab@redhat.com, daniel.vetter@ffwll.ch,
	dri-devel@lists.freedesktop.org, subashrp@gmail.com,
	linaro-mm-sig@lists.linaro.org, kyungmin.park@samsung.com,
	airlied@redhat.com, remi@remlab.net, linux-media@vger.kernel.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	m.szyprowski@samsung.com
Message-id: <4F8FF93D.2030501@samsung.com>
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com>
 <1334332076-28489-12-git-send-email-t.stanislaws@samsung.com>
 <1933889.sK9pAxfEdI@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 04/17/2012 02:57 AM, Laurent Pinchart wrote:
> Hi Tomasz,
> 
> Thanks for the patch.
> 
> On Friday 13 April 2012 17:47:53 Tomasz Stanislawski wrote:
>> From: Sumit Semwal <sumit.semwal@ti.com>
>>
>> This patch makes changes for adding dma-contig as a dma_buf user. It
>> provides function implementations for the {attach, detach, map,
>> unmap}_dmabuf() mem_ops of DMABUF memory type.
>>
>> Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
>> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
>> 	[author of the original patch]
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> 	[integration with refactored dma-contig allocator]
> 
> Pending the comment below,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
>> +static void vb2_dc_detach_dmabuf(void *mem_priv)
>> +{
>> +	struct vb2_dc_buf *buf = mem_priv;
>> +
>> +	if (WARN_ON(buf->dma_addr))
>> +		vb2_dc_unmap_dmabuf(buf);
> 
> This should never happen, and would be a videobuf2 bug otherwise, right ?
> 

Theoretically it should not happen with latest vb2-core patches.
However there is little sense to crash the kernel if it is possible
to handle this bug. Maybe I should add some comments before the check.

>> +
>> +	/* detach this attachment */
>> +	dma_buf_detach(buf->db_attach->dmabuf, buf->db_attach);
>> +	kfree(buf);
>> +}
> 

Regards,
Tomasz Stanislawski
