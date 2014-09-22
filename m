Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46863 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaIVCvq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 22:51:46 -0400
Received: by mail-pa0-f47.google.com with SMTP id et14so3596130pad.6
        for <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 19:51:45 -0700 (PDT)
Message-ID: <541F8EC6.5080808@igel.co.jp>
Date: Mon, 22 Sep 2014 11:51:50 +0900
From: Kazunori Kobayashi <kkobayas@igel.co.jp>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: m.chehab@samsung.com, dhobsong@igel.co.jp,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] soc_camera: Support VIDIOC_EXPBUF ioctl
References: <1410415778-15415-1-git-send-email-kkobayas@igel.co.jp> <Pine.LNX.4.64.1409200938260.21175@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1409200938260.21175@axis700.grange>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for your review.

(2014/09/20 16:50), Guennadi Liakhovetski wrote:
> Hi Kobayashi-san,
> 
> Thanks for the patch. In principle it looks good, just one question below:
> 
> On Thu, 11 Sep 2014, Kazunori Kobayashi wrote:
> 
>> This patch allows for exporting a dmabuf descriptor from soc_camera drivers.
>>
>> Signed-off-by: Kazunori Kobayashi <kkobayas@igel.co.jp>
>> ---
>>  drivers/media/platform/soc_camera/soc_camera.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
>> index f4308fe..9d7b8ea 100644
>> --- a/drivers/media/platform/soc_camera/soc_camera.c
>> +++ b/drivers/media/platform/soc_camera/soc_camera.c
>> @@ -437,6 +437,19 @@ static int soc_camera_prepare_buf(struct file *file, void *priv,
>>  		return vb2_prepare_buf(&icd->vb2_vidq, b);
>>  }
>>  
>> +static int soc_camera_expbuf(struct file *file, void *priv,
>> +			     struct v4l2_exportbuffer *p)
>> +{
>> +	struct soc_camera_device *icd = file->private_data;
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +
>> +	/* videobuf2 only */
>> +	if (ici->ops->init_videobuf)
>> +		return -EINVAL;
>> +	else
>> +		return vb2_expbuf(&icd->vb2_vidq, p);
> 
> Many soc-camera queue management functions, like queuing, dequeuing a 
> buffer check, that the caller is indeed the process, that is controlling 
> the device. This is done for the case, when two (or more) processes open a 
> video device node, some of them only want to monitor it, or control 
> parameters like exposure etc. Whereas only one process is allowed to 
> perform critical operations, like setting a video format, starting and 
> stopping streaming, queuing and dequeuing buffers. Should this function 
> too use such a check
> 
> 	if (icd->streamer != file)
> 		return -EBUSY;
> 
> If you agree, I can just add it myself, no need to resubmit.
I think that's appropriate suggestion.
The dmabuf exporting should be restricted to the process that
operates the video streaming.
Please add the check.

> 
> Thanks
> Guennadi
> 
>> +}
>> +
>>  /* Always entered with .host_lock held */
>>  static int soc_camera_init_user_formats(struct soc_camera_device *icd)
>>  {
>> @@ -2085,6 +2098,7 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
>>  	.vidioc_dqbuf		 = soc_camera_dqbuf,
>>  	.vidioc_create_bufs	 = soc_camera_create_bufs,
>>  	.vidioc_prepare_buf	 = soc_camera_prepare_buf,
>> +	.vidioc_expbuf		 = soc_camera_expbuf,
>>  	.vidioc_streamon	 = soc_camera_streamon,
>>  	.vidioc_streamoff	 = soc_camera_streamoff,
>>  	.vidioc_cropcap		 = soc_camera_cropcap,
>> -- 
>> 1.8.1.2
>>


-- 
---------------------------------
IGEL Co.,Ltd. Kazunori Kobayashi
kkobayas@igel.co.jp
http://www.igel.co.jp/
