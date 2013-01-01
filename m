Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:47578 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751862Ab3AATo4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 14:44:56 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Tue, 1 Jan 2013 11:42:29 -0800
Subject: RE: [PATCH V3 06/15] [media] marvell-ccic: add new formats support
 for marvell-ccic driver
Message-ID: <477F20668A386D41ADCC57781B1F70430D13EA8816@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
 <1355565484-15791-7-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1301011734070.31619@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1301011734070.31619@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi


>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Wednesday, 02 January, 2013 00:56
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH V3 06/15] [media] marvell-ccic: add new formats support for
>marvell-ccic driver
>
>On Sat, 15 Dec 2012, Albert Wang wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch adds the new formats support for marvell-ccic.
>>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>> ---
>>  drivers/media/platform/marvell-ccic/mcam-core.c |  175 ++++++++++++++++++-----
>>  drivers/media/platform/marvell-ccic/mcam-core.h |    6 +
>>  2 files changed, 149 insertions(+), 32 deletions(-)
>>
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c
>b/drivers/media/platform/marvell-ccic/mcam-core.c
>> index 3cc1d0c..a679917 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
>
>[snip]
>
>> @@ -658,49 +708,85 @@ static inline void mcam_sg_restart(struct mcam_camera
>*cam)
>>   */
>>  static void mcam_ctlr_image(struct mcam_camera *cam)
>>  {
>> -	int imgsz;
>>  	struct v4l2_pix_format *fmt = &cam->pix_format;
>> +	u32 widthy = 0, widthuv = 0, imgsz_h, imgsz_w;
>> +
>> +	cam_dbg(cam, "camera: bytesperline = %d; height = %d\n",
>> +		fmt->bytesperline, fmt->sizeimage / fmt->bytesperline);
>> +	imgsz_h = (fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK;
>> +	imgsz_w = fmt->bytesperline & IMGSZ_H_MASK;
>> +
>> +	switch (fmt->pixelformat) {
>> +	case V4L2_PIX_FMT_YUYV:
>> +	case V4L2_PIX_FMT_UYVY:
>> +		widthy = fmt->width * 2;
>> +		widthuv = 0;
>> +		break;
>> +	case V4L2_PIX_FMT_JPEG:
>> +		imgsz_h = (fmt->sizeimage / fmt->bytesperline) << IMGSZ_V_SHIFT;
>> +		widthy = fmt->bytesperline;
>> +		widthuv = 0;
>> +		break;
>> +	case V4L2_PIX_FMT_YUV422P:
>> +	case V4L2_PIX_FMT_YUV420:
>> +	case V4L2_PIX_FMT_YVU420:
>> +		imgsz_w = (fmt->bytesperline * 4 / 3) & IMGSZ_H_MASK;
>> +		widthy = fmt->width;
>> +		widthuv = fmt->width / 2;
>
>I might be wrong, but the above doesn't look right to me. Firstly, YUV422P
>is a 4:2:2 format, whereas YUV420 and YVU420 are 4:2:0 formats, so, I
>would expect calculations for them to differ. Besides, bytesperline * 4 /
>3 doesn't look right for any of them. If this is what I think - total
>number of bytes per line, i.e., sizeimage / height, than shouldn't YAU422P
>have
>+		imgsz_w = fmt->bytesperline & IMGSZ_H_MASK;
>and the other two
>+		imgsz_w = (fmt->bytesperline * 3 / 2) & IMGSZ_H_MASK;
>? But maybe I'm wrong, please, double-check and confirm.
>
[Albert Wang] It looks they are both 12 bit planar format, they have same imgsz_w.
Anyway, we will double check it after back to office.

>> +		break;
>> +	default:
>> +		widthy = fmt->bytesperline;
>> +		widthuv = 0;
>> +	}
>> +
>> +	mcam_reg_write_mask(cam, REG_IMGPITCH, widthuv << 16 | widthy,
>> +			IMGP_YP_MASK | IMGP_UVP_MASK);
>> +	mcam_reg_write(cam, REG_IMGSIZE, imgsz_h | imgsz_w);
>> +	mcam_reg_write(cam, REG_IMGOFFSET, 0x0);
>>
>> -	imgsz = ((fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK) |
>> -		(fmt->bytesperline & IMGSZ_H_MASK);
>> -	mcam_reg_write(cam, REG_IMGSIZE, imgsz);
>> -	mcam_reg_write(cam, REG_IMGOFFSET, 0);
>> -	/* YPITCH just drops the last two bits */
>> -	mcam_reg_write_mask(cam, REG_IMGPITCH, fmt->bytesperline,
>> -			IMGP_YP_MASK);
>>  	/*
>>  	 * Tell the controller about the image format we are using.
>>  	 */
>> -	switch (cam->pix_format.pixelformat) {
>> +	switch (fmt->pixelformat) {
>> +	case V4L2_PIX_FMT_YUV422P:
>> +		mcam_reg_write_mask(cam, REG_CTRL0,
>> +			C0_DF_YUV | C0_YUV_PLANAR | C0_YUVE_YVYU,
>C0_DF_MASK);
>> +		break;
>> +	case V4L2_PIX_FMT_YUV420:
>> +	case V4L2_PIX_FMT_YVU420:
>> +		mcam_reg_write_mask(cam, REG_CTRL0,
>> +			C0_DF_YUV | C0_YUV_420PL | C0_YUVE_YVYU,
>C0_DF_MASK);
>> +		break;
>>  	case V4L2_PIX_FMT_YUYV:
>> -	    mcam_reg_write_mask(cam, REG_CTRL0,
>> -			    C0_DF_YUV|C0_YUV_PACKED|C0_YUVE_YUYV,
>> -			    C0_DF_MASK);
>> -	    break;
>> -
>> +		mcam_reg_write_mask(cam, REG_CTRL0,
>> +			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_UYVY,
>C0_DF_MASK);
>> +		break;
>> +	case V4L2_PIX_FMT_UYVY:
>> +		mcam_reg_write_mask(cam, REG_CTRL0,
>> +			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_YUYV,
>C0_DF_MASK);
>> +		break;
>> +	case V4L2_PIX_FMT_JPEG:
>> +		mcam_reg_write_mask(cam, REG_CTRL0,
>> +			C0_DF_YUV | C0_YUV_PACKED | C0_YUVE_YUYV,
>C0_DF_MASK);
>> +		break;
>>  	case V4L2_PIX_FMT_RGB444:
>> -	    mcam_reg_write_mask(cam, REG_CTRL0,
>> -			    C0_DF_RGB|C0_RGBF_444|C0_RGB4_XRGB,
>> -			    C0_DF_MASK);
>> +		mcam_reg_write_mask(cam, REG_CTRL0,
>> +			C0_DF_RGB | C0_RGBF_444 | C0_RGB4_XRGB,
>C0_DF_MASK);
>>  		/* Alpha value? */
>> -	    break;
>> -
>> +		break;
>>  	case V4L2_PIX_FMT_RGB565:
>> -	    mcam_reg_write_mask(cam, REG_CTRL0,
>> -			    C0_DF_RGB|C0_RGBF_565|C0_RGB5_BGGR,
>> -			    C0_DF_MASK);
>> -	    break;
>> -
>> +		mcam_reg_write_mask(cam, REG_CTRL0,
>> +			C0_DF_RGB | C0_RGBF_565 | C0_RGB5_BGGR,
>C0_DF_MASK);
>> +		break;
>>  	default:
>> -	    cam_err(cam, "Unknown format %x\n", cam->pix_format.pixelformat);
>> -	    break;
>> +		cam_err(cam, "camera: unknown format: %#x\n", fmt->pixelformat);
>> +		break;
>>  	}
>> +
>>  	/*
>>  	 * Make sure it knows we want to use hsync/vsync.
>>  	 */
>> -	mcam_reg_write_mask(cam, REG_CTRL0, C0_SIF_HVSYNC,
>> -			C0_SIFM_MASK);
>> -
>> +	mcam_reg_write_mask(cam, REG_CTRL0, C0_SIF_HVSYNC, C0_SIFM_MASK);
>>  	/*
>>  	 * This field controls the generation of EOF(DVP only)
>>  	 */
>> @@ -711,7 +797,6 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
>>  	}
>>  }
>>
>> -
>>  /*
>>   * Configure the controller for operation; caller holds the
>>   * device mutex.
>> @@ -984,11 +1069,37 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
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
>>  	start = (cam->state == S_BUFWAIT) && !list_empty(&cam->buffers);
>> +
>> +	switch (cam->pix_format.pixelformat) {
>> +	case V4L2_PIX_FMT_YUV422P:
>> +		mvb->yuv_p.y = dma_handle;
>
>The above line is common for all cases, perhaps just put it above switch?
>
[Albert Wang] OK, we can do that in next version.

>> +		mvb->yuv_p.u = mvb->yuv_p.y + pixel_count;
>> +		mvb->yuv_p.v = mvb->yuv_p.u + pixel_count / 2;
>> +		break;
>> +	case V4L2_PIX_FMT_YUV420:
>> +		mvb->yuv_p.y = dma_handle;
>> +		mvb->yuv_p.u = mvb->yuv_p.y + pixel_count;
>> +		mvb->yuv_p.v = mvb->yuv_p.u + pixel_count / 4;
>> +		break;
>> +	case V4L2_PIX_FMT_YVU420:
>> +		mvb->yuv_p.y = dma_handle;
>> +		mvb->yuv_p.v = mvb->yuv_p.y + pixel_count;
>> +		mvb->yuv_p.u = mvb->yuv_p.v + pixel_count / 4;
>> +		break;
>> +	default:
>> +		mvb->yuv_p.y = dma_handle;
>> +	}
>> +
>>  	list_add(&mvb->queue, &cam->buffers);
>>  	if (cam->state == S_STREAMING && test_bit(CF_SG_RESTART, &cam->flags))
>>  		mcam_sg_restart(cam);
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/


Thanks
Albert Wang
86-21-61092656
