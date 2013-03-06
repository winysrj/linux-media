Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:45165 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932065Ab3CFOpP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Mar 2013 09:45:15 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Wed, 6 Mar 2013 06:38:28 -0800
Subject: RE: [REVIEW PATCH V4 12/12] [media] marvell-ccic: add 3 frame
 buffers support in DMA_CONTIG mode
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D8DAA8F@SC-VEXCH1.marvell.com>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-13-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1303051515590.25837@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1303051515590.25837@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi


>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Tuesday, 05 March, 2013 22:17
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [REVIEW PATCH V4 12/12] [media] marvell-ccic: add 3 frame buffers
>support in DMA_CONTIG mode
>
>On Thu, 7 Feb 2013, Albert Wang wrote:
>
>> This patch adds support of 3 frame buffers in DMA-contiguous mode.
>>
>> In current DMA_CONTIG mode, only 2 frame buffers can be supported.
>> Actually, Marvell CCIC can support 2 or 3 frame buffers.
>>
>> Currently 3 frame buffers mode will be used by default.
>> To use 2 frame buffers mode, can do:
>>   #define MAX_FRAME_BUFS 2
>> in mcam-core.h.
>>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>> Acked-by: Jonathan Corbet <corbet@lwn.net>
>> ---
>>  drivers/media/platform/marvell-ccic/mcam-core.c |   59 +++++++++++++++++------
>>  drivers/media/platform/marvell-ccic/mcam-core.h |   13 +++++
>>  2 files changed, 57 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c
>b/drivers/media/platform/marvell-ccic/mcam-core.c
>> index f206e3c..33fce6c 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
>> @@ -494,13 +494,32 @@ static void mcam_set_contig_buffer(struct mcam_camera
>*cam, unsigned int frame)
>>  	struct mcam_vb_buffer *buf;
>>  	struct v4l2_pix_format *fmt = &cam->pix_format;
>>
>> -	/*
>> -	 * If there are no available buffers, go into single mode
>> -	 */
>>  	if (list_empty(&cam->buffers)) {
>> -		buf = cam->vb_bufs[frame ^ 0x1];
>> -		set_bit(CF_SINGLE_BUFFER, &cam->flags);
>> -		cam->frame_state.singles++;
>> +		/*
>> +		 * If there are no available buffers
>> +		 * go into single buffer mode
>> +		 *
>> +		 * If CCIC use Two Buffers mode
>> +		 * will use another remaining frame buffer
>> +		 * frame 0 -> buf 1
>> +		 * frame 1 -> buf 0
>> +		 *
>> +		 * If CCIC use Three Buffers mode
>> +		 * will use the 2rd remaining frame buffer
>> +		 * frame 0 -> buf 2
>> +		 * frame 1 -> buf 0
>> +		 * frame 2 -> buf 1
>> +		 */
>> +		buf = cam->vb_bufs[(frame + (MAX_FRAME_BUFS - 1))
>> +						% MAX_FRAME_BUFS];
>> +		if (cam->frame_state.usebufs == 0)
>> +			cam->frame_state.usebufs++;
>> +		else {
>> +			set_bit(CF_SINGLE_BUFFER, &cam->flags);
>> +			cam->frame_state.singles++;
>> +			if (cam->frame_state.usebufs < 2)
>> +				cam->frame_state.usebufs++;
>
>What is this .usebufs actually supposed to do? AFAICS, it is only used to
>decide, whether it should be changed, I don't see it having any effect on
>anything else?
>
Actually, we use .usebufs to decide if will enter single buffer mode.
Only usebufs == 2 can enter single buffer mode.
But when init it:
	If CCIC use Two Buffers mode, init usebufs == 1
	If CCIC use Three Buffers mode, init usebufs == 0
That means when CCIC use Two Buffers mode, once buffer used out, CCIC will enter single buffer mode soon
But when CCIC use Two Buffers mode, we can have 1 frame time to wait for new buffer and needn't enter single buffer mode.
If we still can't get new buffer after 1 frame, then CCIC has to enter single buffer mode.
But if we are lucky enough and get new buffer when next frame come, then we can still run in normal mode.


>> +		}
>>  	} else {
>>  		/*
>>  		 * OK, we have a buffer we can use.
>> @@ -509,15 +528,15 @@ static void mcam_set_contig_buffer(struct mcam_camera
>*cam, unsigned int frame)
>>  					queue);
>>  		list_del_init(&buf->queue);
>>  		clear_bit(CF_SINGLE_BUFFER, &cam->flags);
>> +		if (cam->frame_state.usebufs != (3 - MAX_FRAME_BUFS))
>> +			cam->frame_state.usebufs--;
>>  	}
>>
>>  	cam->vb_bufs[frame] = buf;
>> -	mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR, buf->yuv_p.y);
>> +	mcam_reg_write(cam, REG_Y0BAR + (frame << 2), buf->yuv_p.y);
>>  	if (mcam_fmt_is_planar(fmt->pixelformat)) {
>> -		mcam_reg_write(cam, frame == 0 ?
>> -					REG_U0BAR : REG_U1BAR, buf->yuv_p.u);
>> -		mcam_reg_write(cam, frame == 0 ?
>> -					REG_V0BAR : REG_V1BAR, buf->yuv_p.v);
>> +		mcam_reg_write(cam, REG_U0BAR + (frame << 2), buf->yuv_p.u);
>> +		mcam_reg_write(cam, REG_V0BAR + (frame << 2), buf->yuv_p.v);
>>  	}
>>  }
>>
>> @@ -526,10 +545,14 @@ static void mcam_set_contig_buffer(struct mcam_camera
>*cam, unsigned int frame)
>>   */
>>  static void mcam_ctlr_dma_contig(struct mcam_camera *cam)
>>  {
>> -	mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
>> -	cam->nbufs = 2;
>> -	mcam_set_contig_buffer(cam, 0);
>> -	mcam_set_contig_buffer(cam, 1);
>> +	unsigned int frame;
>> +
>> +	cam->nbufs = MAX_FRAME_BUFS;
>> +	for (frame = 0; frame < cam->nbufs; frame++)
>> +		mcam_set_contig_buffer(cam, frame);
>> +
>> +	if (cam->nbufs == 2)
>> +		mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
>>  }
>>
>>  /*
>> @@ -1068,6 +1091,12 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq,
>unsigned int count)
>>  	for (frame = 0; frame < cam->nbufs; frame++)
>>  		clear_bit(CF_FRAME_SOF0 + frame, &cam->flags);
>>
>> +	/*
>> +	 *  If CCIC use Two Buffers mode, init usebufs == 1
>> +	 *  If CCIC use Three Buffers mode, init usebufs == 0
>> +	 */
>> +	cam->frame_state.usebufs = 3 - MAX_FRAME_BUFS;
>> +
>>  	return mcam_read_setup(cam);
>>  }
>>
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h
>b/drivers/media/platform/marvell-ccic/mcam-core.h
>> index 0accdbb..6fffa14 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
>> @@ -44,6 +44,15 @@ enum mcam_state {
>>  };
>>  #define MAX_DMA_BUFS 3
>>
>> +#ifdef MCAM_MODE_DMA_CONTIG
>> +/*
>> + * CCIC can support at most 3 frame buffers in DMA_CONTIG buffer mode
>> + * 2 - Use Two Buffers mode
>> + * 3 - Use Three Buffers mode
>> + */
>> +#define MAX_FRAME_BUFS 3 /* marvell-ccic used Three Buffers mode as default */
>> +#endif
>> +
>>  /*
>>   * Different platforms work best with different buffer modes, so we
>>   * let the platform pick.
>> @@ -82,6 +91,10 @@ struct mcam_frame_state {
>>  	unsigned int frames;
>>  	unsigned int singles;
>>  	unsigned int delivered;
>> +	/*
>> +	 * Only usebufs == 2 can enter single buffer mode
>> +	 */
>> +	unsigned int usebufs;
>>  };
>>
>>  #define NR_MCAM_CLK 3
>> --
>> 1.7.9.5
>>
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
