Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:51268 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752527AbbIWIlF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2015 04:41:05 -0400
In-Reply-To: <20150922211015.GT3175@valkosipuli.retiisi.org.uk>
References: <1442838371-21484-1-git-send-email-tiffany.lin@mediatek.com> <20150922211015.GT3175@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [RESEND PATCH] media: vb2: Fix vb2_dc_prepare do not correct sync data to device
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 23 Sep 2015 10:40:56 +0200
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Tiffany Lin <tiffany.lin@mediatek.com>
CC: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, robin.murphy@arm.com
Message-ID: <6A2D1ECE-40A4-441C-910B-6EEB3D99D8FA@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Resent, hopefully without html this time.

On September 22, 2015 11:10:15 PM GMT+02:00, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>Hi Tiffany,
>
>(Robin and Hans cc'd.)
>
>On Mon, Sep 21, 2015 at 08:26:11PM +0800, Tiffany Lin wrote:
>> vb2_dc_prepare use the number of SG entries dma_map_sg_attrs return.
>> But in dma_sync_sg_for_device, it use lengths of each SG entries
>> before dma_map_sg_attrs. dma_map_sg_attrs will concatenate
>> SGs until dma length > dma seg bundary. sgt->nents will less than
>> sgt->orig_nents. Using SG entries after dma_map_sg_attrs
>> in vb2_dc_prepare will make some SGs are not sync to device.
>> After add DMA_ATTR_SKIP_CPU_SYNC in vb2_dc_get_userptr to remove
>> sync data to device twice. Device randomly get incorrect data because
>> some SGs are not sync to device. Change to use number of SG entries
>> before dma_map_sg_attrs in vb2_dc_prepare to prevent this issue.
>> 
>> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
>> ---
>>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> index 2397ceb..c5d00bd 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> @@ -100,7 +100,7 @@ static void vb2_dc_prepare(void *buf_priv)
>>  	if (!sgt || buf->db_attach)
>>  		return;
>>  
>> -	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents,
>buf->dma_dir);
>> +	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
>buf->dma_dir);
>>  }
>>  
>>  static void vb2_dc_finish(void *buf_priv)
>> @@ -112,7 +112,7 @@ static void vb2_dc_finish(void *buf_priv)
>>  	if (!sgt || buf->db_attach)
>>  		return;
>>  
>> -	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
>> +	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents,
>buf->dma_dir);
>>  }
>>  
>>  /*********************************************/
>
>Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>
>Could you post a similar patch for videobuf2-dma-sg as well, please?
>This
>should probably go to stable (since when?).
>
>videobuf-dma-sg appears to be broken, too, but the fix is more changes
>than one or two lines.
>
>-- 
>Kind regards,
>
>Sakari Ailus
>e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

Sakari, can you take a careful look at the vb2 code? If I remember correctly, the nents field receives the result of the map_sg function. I have no idea if that's correct.

BTW, don't spend too much time on vb1, nobody cares about that old framework, and vb1 drivers are rarely used on arm platforms. 

Regards,

Hans 

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
