Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:39516 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756967Ab3CFONg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Mar 2013 09:13:36 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Wed, 6 Mar 2013 06:10:39 -0800
Subject: RE: [REVIEW PATCH V4 05/12] [media] marvell-ccic: add new formats
 support for marvell-ccic driver
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D8DAA89@SC-VEXCH1.marvell.com>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-6-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1303051058000.25837@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1303051058000.25837@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi


>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Tuesday, 05 March, 2013 18:08
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [REVIEW PATCH V4 05/12] [media] marvell-ccic: add new formats support
>for marvell-ccic driver
>
>Looks pretty good to me now, just one nitpick:
>
>On Thu, 7 Feb 2013, Albert Wang wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch adds the new formats support for marvell-ccic.
>>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>> ---
>>  drivers/media/platform/marvell-ccic/mcam-core.c |  189 +++++++++++++++++++----
>>  drivers/media/platform/marvell-ccic/mcam-core.h |    6 +
>>  2 files changed, 162 insertions(+), 33 deletions(-)
>>
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c
>b/drivers/media/platform/marvell-ccic/mcam-core.c
>> index f89fce7..0f9604e 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
>
>[snip]
>
>> @@ -971,11 +1062,35 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
>>  {
>>  	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
>>  	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
>> +	struct v4l2_pix_format *fmt = &cam->pix_format;
>>  	unsigned long flags;
>>  	int start;
>> +	dma_addr_t dma_handle;
>> +	u32 pixel_count = fmt->width * fmt->height;
>>
>>  	spin_lock_irqsave(&cam->dev_lock, flags);
>> +	dma_handle = vb2_dma_contig_plane_dma_addr(vb, 0);
>> +	BUG_ON(!dma_handle);
>
>Again - a bit too strong. But the truth is - .buf_queue() cannot fail...
>Would it be possible to move this pointer calculation to .buf_prepare(),
>which does return an error code?
>
Yes, we will remove all BUG_ON macros, replace them with error or warning msg.

 
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

Thanks
Albert Wang
86-21-61092656
