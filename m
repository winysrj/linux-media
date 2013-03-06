Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:35444 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758489Ab3CFOlf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Mar 2013 09:41:35 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Wed, 6 Mar 2013 06:38:17 -0800
Subject: RE: [REVIEW PATCH V4 09/12] [media] marvell-ccic: use unsigned int
 type replace int type
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D8DAA8D@SC-VEXCH1.marvell.com>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-10-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1303051134220.25837@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1303051134220.25837@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi


>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Tuesday, 05 March, 2013 18:43
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [REVIEW PATCH V4 09/12] [media] marvell-ccic: use unsigned int type
>replace int type
>
>I'm not against this patch, but I don't see a lot of meaning in it either,
>apart from the .irq part - that makes the type match *request_*irq()
>prototypes. Apart from that... Using "int i" for a simple iterator, that
>doesn't go beyond INT_MAX is kinda traditional, I think. You change int
>frame to unsigned, but if you look at mcam_buffer_done(), as it is called
>from mcam_frame_tasklet(), the
>
>		int bufno = cam->next_buf;
>
>variable is used for its second parameter (int frame). And ->next_buf is
>declared as (signed) int, and can indeed be negative in
>mcam_reset_buffers():
>
>	cam->next_buf = -1;
>
>So... You might need to be more careful with those changes, if you
>_really_ need them. Otherwise, unless there are real reasons, like
>matching an existing API, avoiding warnings, I'd really just drop all
>this, perhaps, apart from ->irq.
>
Actually, this patch is prepared for [PATCH 12/12] [media] marvell-ccic: add 3 frame buffers support in DMA_CONTIG mode
In that patch we need do that calculate with frame:
buf = cam->vb_bufs[(frame + (MAX_FRAME_BUFS - 1)) % MAX_FRAME_BUFS];

So we think frame should be unsigned from the original meaning.

But sometimes buffer number may be negative for some special design, I leave them alone.

So how about we change to keep buffer number with original definition if you think there is no meaning to change it and just change frame number and irq?



>Thanks
>Guennadi
>
>On Thu, 7 Feb 2013, Albert Wang wrote:
>
>> This patch uses unsigned int type replace int type in marvell-ccic.
>> These variables: frame number, buf number, irq... should be unsigned.
>>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>> Acked-by: Jonathan Corbet <corbet@lwn.net>
>> ---
>>  drivers/media/platform/marvell-ccic/mcam-core.c  |   22 +++++++++++-----------
>>  drivers/media/platform/marvell-ccic/mcam-core.h  |    2 +-
>>  drivers/media/platform/marvell-ccic/mmp-driver.c |    2 +-
>>  3 files changed, 13 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c
>b/drivers/media/platform/marvell-ccic/mcam-core.c
>> index 939c430..b668f2b 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
>> @@ -233,7 +233,7 @@ static inline struct mcam_vb_buffer *vb_to_mvb(struct
>vb2_buffer *vb)
>>  /*
>>   * Hand a completed buffer back to user space.
>>   */
>> -static void mcam_buffer_done(struct mcam_camera *cam, int frame,
>> +static void mcam_buffer_done(struct mcam_camera *cam, unsigned int frame,
>>  		struct vb2_buffer *vbuf)
>>  {
>>  	vbuf->v4l2_buf.bytesused = cam->pix_format.sizeimage;
>> @@ -260,7 +260,7 @@ static void mcam_buffer_done(struct mcam_camera *cam, int
>frame,
>>   */
>>  static void mcam_reset_buffers(struct mcam_camera *cam)
>>  {
>> -	int i;
>> +	unsigned int i;
>>
>>  	cam->next_buf = -1;
>>  	for (i = 0; i < cam->nbufs; i++) {
>> @@ -344,7 +344,7 @@ static int mcam_config_mipi(struct mcam_camera *mcam, int
>enable)
>>   */
>>  static int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
>>  {
>> -	int i;
>> +	unsigned int i;
>>
>>  	mcam_set_config_needed(cam, 1);
>>  	if (loadtime)
>> @@ -385,7 +385,7 @@ static int mcam_alloc_dma_bufs(struct mcam_camera *cam,
>int loadtime)
>>
>>  static void mcam_free_dma_bufs(struct mcam_camera *cam)
>>  {
>> -	int i;
>> +	unsigned int i;
>>
>>  	for (i = 0; i < cam->nbufs; i++) {
>>  		dma_free_coherent(cam->dev, cam->dma_buf_size,
>> @@ -424,7 +424,7 @@ static void mcam_ctlr_dma_vmalloc(struct mcam_camera
>*cam)
>>  static void mcam_frame_tasklet(unsigned long data)
>>  {
>>  	struct mcam_camera *cam = (struct mcam_camera *) data;
>> -	int i;
>> +	unsigned int i;
>>  	unsigned long flags;
>>  	struct mcam_vb_buffer *buf;
>>
>> @@ -472,7 +472,7 @@ static int mcam_check_dma_buffers(struct mcam_camera
>*cam)
>>  	return 0;
>>  }
>>
>> -static void mcam_vmalloc_done(struct mcam_camera *cam, int frame)
>> +static void mcam_vmalloc_done(struct mcam_camera *cam, unsigned int frame)
>>  {
>>  	tasklet_schedule(&cam->s_tasklet);
>>  }
>> @@ -521,7 +521,7 @@ static bool mcam_fmt_is_planar(__u32 pfmt)
>>   * space.  In this way, we always have a buffer to DMA to and don't
>>   * have to try to play games stopping and restarting the controller.
>>   */
>> -static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
>> +static void mcam_set_contig_buffer(struct mcam_camera *cam, unsigned int frame)
>>  {
>>  	struct mcam_vb_buffer *buf;
>>  	struct v4l2_pix_format *fmt = &cam->pix_format;
>> @@ -567,7 +567,7 @@ static void mcam_ctlr_dma_contig(struct mcam_camera *cam)
>>  /*
>>   * Frame completion handling.
>>   */
>> -static void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
>> +static void mcam_dma_contig_done(struct mcam_camera *cam, unsigned int frame)
>>  {
>>  	struct mcam_vb_buffer *buf = cam->vb_bufs[frame];
>>
>> @@ -643,7 +643,7 @@ static void mcam_ctlr_dma_sg(struct mcam_camera *cam)
>>   * safely change the DMA descriptor array here and restart things
>>   * (assuming there's another buffer waiting to go).
>>   */
>> -static void mcam_dma_sg_done(struct mcam_camera *cam, int frame)
>> +static void mcam_dma_sg_done(struct mcam_camera *cam, unsigned int frame)
>>  {
>>  	struct mcam_vb_buffer *buf = cam->vb_bufs[0];
>>
>> @@ -1051,7 +1051,7 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
>>  		void *alloc_ctxs[])
>>  {
>>  	struct mcam_camera *cam = vb2_get_drv_priv(vq);
>> -	int minbufs = (cam->buffer_mode == B_DMA_CONTIG) ? 3 : 2;
>> +	unsigned int minbufs = (cam->buffer_mode == B_DMA_CONTIG) ? 3 : 2;
>>
>>  	sizes[0] = cam->pix_format.sizeimage;
>>  	*num_planes = 1; /* Someday we have to support planar formats... */
>> @@ -1855,7 +1855,7 @@ static struct video_device mcam_v4l_template = {
>>  /*
>>   * Interrupt handler stuff
>>   */
>> -static void mcam_frame_complete(struct mcam_camera *cam, int frame)
>> +static void mcam_frame_complete(struct mcam_camera *cam, unsigned int frame)
>>  {
>>  	/*
>>  	 * Basic frame housekeeping.
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h
>b/drivers/media/platform/marvell-ccic/mcam-core.h
>> index 263767e..4cb68e0 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
>> @@ -163,7 +163,7 @@ struct mcam_camera {
>>
>>  	/* Mode-specific ops, set at open time */
>>  	void (*dma_setup)(struct mcam_camera *cam);
>> -	void (*frame_complete)(struct mcam_camera *cam, int frame);
>> +	void (*frame_complete)(struct mcam_camera *cam, unsigned int frame);
>>
>>  	/* Current operating parameters */
>>  	u32 sensor_type;		/* Currently ov7670 only */
>> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c
>b/drivers/media/platform/marvell-ccic/mmp-driver.c
>> index 89dd078..732af16 100755
>> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
>> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
>> @@ -42,7 +42,7 @@ struct mmp_camera {
>>  	struct platform_device *pdev;
>>  	struct mcam_camera mcam;
>>  	struct list_head devlist;
>> -	int irq;
>> +	unsigned int irq;
>>  };
>>
>>  static inline struct mmp_camera *mcam_to_cam(struct mcam_camera *mcam)
>> --
>> 1.7.9.5
>>
>
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

Thanks
Albert Wang
86-21-61092656
