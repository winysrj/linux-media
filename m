Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:57840 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754512Ab2K0QpX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 11:45:23 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Tue, 27 Nov 2012 08:44:37 -0800
Subject: RE: [PATCH 15/15] [media] marvell-ccic: add 3 frame buffers support
 in DMA_CONTIG mode
Message-ID: <477F20668A386D41ADCC57781B1F70430D1367C918@SC-VEXCH1.marvell.com>
References: <1353677705-24479-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271713100.22273@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1211271713100.22273@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi

Thanks a lot for your review! :)

>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Wednesday, 28 November, 2012 00:30
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH 15/15] [media] marvell-ccic: add 3 frame buffers support in
>DMA_CONTIG mode
>
>On Fri, 23 Nov 2012, Albert Wang wrote:
>
>> This patch adds support of 3 frame buffers in DMA-contiguous mode.
>>
>> In current DMA_CONTIG mode, only 2 frame buffers can be supported.
>> Actually, Marvell CCIC can support at most 3 frame buffers.
>>
>> Currently 2 frame buffers mode will be used by default.
>> To use 3 frame buffers mode, can do:
>>   define MAX_FRAME_BUFS 3
>> in mcam-core.h
>>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> ---
>>  drivers/media/platform/marvell-ccic/mcam-core.c |   59 +++++++++++++++++------
>>  drivers/media/platform/marvell-ccic/mcam-core.h |   11 +++++
>>  2 files changed, 55 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c
>> b/drivers/media/platform/marvell-ccic/mcam-core.c
>> index 2d200d6..3b75594 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
>> @@ -401,13 +401,32 @@ static void mcam_set_contig_buffer(struct mcam_camera
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
>> +		if (cam->frame_state.tribufs == 0)
>> +			cam->frame_state.tribufs++;
>
>TBH, I don't understand what the "tribuf" field means and what it is doing. Could you
>explain a bit?
>
Yes, in the first version, I just use tribufs in the 3 frame buffer mode.
Then I consolidated the controls of 2 buffers mode and 3 buffers mode according to Jonathan's suggestion.
But still continue to use the "tribufs", maybe it's confused.

>> +		else {
>> +			set_bit(CF_SINGLE_BUFFER, &cam->flags);
>> +			cam->frame_state.singles++;
>> +			if (cam->frame_state.tribufs < 2)
>> +				cam->frame_state.tribufs++;
>
>This seems to be the only location, where tribuf affects the control flow.
>So, it looks like, it controls, if no more buffers are on the queue, wheather you need to
>set the CF_SINGLE_BUFFER flag and increment the singles count.
>
Yes, the tribufs indicates which conditions we need set the single buffer flag.


>Thanks
>Guennadi
>
>> +		}
>>  	} else {
>>  		/*
>>  		 * OK, we have a buffer we can use.
>> @@ -416,15 +435,15 @@ static void mcam_set_contig_buffer(struct mcam_camera
>*cam, unsigned int frame)
>>  					queue);
>>  		list_del_init(&buf->queue);
>>  		clear_bit(CF_SINGLE_BUFFER, &cam->flags);
>> +		if (cam->frame_state.tribufs != (3 - MAX_FRAME_BUFS))
>> +			cam->frame_state.tribufs--;
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
>> @@ -433,10 +452,14 @@ static void mcam_set_contig_buffer(struct mcam_camera
>*cam, unsigned int frame)
>>   */
>>  void mcam_ctlr_dma_contig(struct mcam_camera *cam)  {
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
>> @@ -1043,6 +1066,12 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq,
>unsigned int count)
>>  	for (frame = 0; frame < cam->nbufs; frame++)
>>  		clear_bit(CF_FRAME_SOF0 + frame, &cam->flags);
>>
>> +	/*
>> +	 *  If CCIC use Two Buffers mode, init tribufs == 1
>> +	 *  If CCIC use Three Buffers mode, init tribufs == 0
>> +	 */
>> +	cam->frame_state.tribufs = 3 - MAX_FRAME_BUFS;
>> +
>>  	return mcam_read_setup(cam);
>>  }
>>
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h
>> b/drivers/media/platform/marvell-ccic/mcam-core.h
>> index 5b2cf6e..6420754 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
>> @@ -68,6 +68,13 @@ enum mcam_state {
>>  #define MAX_DMA_BUFS 3
>>
>>  /*
>> + * CCIC can support at most 3 frame buffers in DMA_CONTIG buffer mode
>> + * 2 - Use Two Buffers mode
>> + * 3 - Use Three Buffers mode
>> + */
>> +#define MAX_FRAME_BUFS 2 /* Current marvell-ccic used Two Buffers
>> +mode */
>> +
>> +/*
>>   * Different platforms work best with different buffer modes, so we
>>   * let the platform pick.
>>   */
>> @@ -105,6 +112,10 @@ struct mmp_frame_state {
>>  	unsigned int frames;
>>  	unsigned int singles;
>>  	unsigned int delivered;
>> +	/*
>> +	 * Only tribufs == 2 can enter single buffer mode
>> +	 */
>> +	unsigned int tribufs;
>>  };
>>
>>  /*
>> --
>> 1.7.9.5
>>
>
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/
