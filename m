Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:42693 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040Ab2LPWEp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 17:04:45 -0500
From: Albert Wang <twang13@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Sun, 16 Dec 2012 14:04:40 -0800
Subject: RE: [PATCH V3 09/15] [media] marvell-ccic: add get_mcam function
 for marvell-ccic driver
Message-ID: <477F20668A386D41ADCC57781B1F70430D13C8CCE3@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-10-git-send-email-twang13@marvell.com>
 <20121216092440.110ecf5f@hpe.lwn.net>
In-Reply-To: <20121216092440.110ecf5f@hpe.lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Jonathan


>-----Original Message-----
>From: Jonathan Corbet [mailto:corbet@lwn.net]
>Sent: Monday, 17 December, 2012 00:25
>To: Albert Wang
>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH V3 09/15] [media] marvell-ccic: add get_mcam function for marvell-
>ccic driver
>
>On Sat, 15 Dec 2012 17:57:58 +0800
>Albert Wang <twang13@marvell.com> wrote:
>
>> This patch adds get_mcam() inline function which is prepared for
>> adding soc_camera support in marvell-ccic driver
>
>Time for a bikeshed moment: "get" generally is understood to mean
>incrementing a reference count in kernel code.  Can it have a name like
>vbq_to_mcam() instead?
>
[Albert Wang] Sure. It looks your name is more professional. :)

>Also:
>
>> @@ -1073,14 +1073,17 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
>>  static void mcam_vb_buf_queue(struct vb2_buffer *vb)
>>  {
>>  	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
>> -	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
>> +	struct mcam_camera *cam = get_mcam(vb->vb2_queue);
>>  	struct v4l2_pix_format *fmt = &cam->pix_format;
>>  	unsigned long flags;
>>  	int start;
>>  	dma_addr_t dma_handle;
>> +	unsigned long size;
>>  	u32 pixel_count = fmt->width * fmt->height;
>>
>>  	spin_lock_irqsave(&cam->dev_lock, flags);
>> +	size = vb2_plane_size(vb, 0);
>> +	vb2_set_plane_payload(vb, 0, size);
>>  	dma_handle = vb2_dma_contig_plane_dma_addr(vb, 0);
>>  	BUG_ON(!dma_handle);
>>  	start = (cam->state == S_BUFWAIT) && !list_empty(&cam->buffers);
>
>There is an unrelated change here that belongs in a separate patch.
>
[Albert Wang] OK

>> @@ -1138,9 +1141,12 @@ static void mcam_vb_wait_finish(struct vb2_queue *vq)
>>   */
>>  static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
>>  {
>> -	struct mcam_camera *cam = vb2_get_drv_priv(vq);
>> +	struct mcam_camera *cam = get_mcam(vq);
>>  	unsigned int frame;
>>
>> +	if (count < 2)
>> +		return -EINVAL;
>> +
>
>Here too - unrelated change.
>
[Albert Wang] Em, it looks we should add a new patch to contain these changes. :)

>>  	if (cam->state != S_IDLE) {
>>  		INIT_LIST_HEAD(&cam->buffers);
>>  		return -EINVAL;
>> @@ -1170,7 +1176,7 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq,
>unsigned int count)
>>
>>  static int mcam_vb_stop_streaming(struct vb2_queue *vq)
>>  {
>> -	struct mcam_camera *cam = vb2_get_drv_priv(vq);
>> +	struct mcam_camera *cam = get_mcam(vq);
>>  	unsigned long flags;
>>
>>  	if (cam->state == S_BUFWAIT) {
>> @@ -1181,6 +1187,7 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
>>  	if (cam->state != S_STREAMING)
>>  		return -EINVAL;
>>  	mcam_ctlr_stop_dma(cam);
>> +	cam->state = S_IDLE;
>
>...and also here ...
>
>jon

 

Thanks
Albert Wang
86-21-61092656
