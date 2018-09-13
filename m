Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727847AbeINALq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 20:11:46 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8DIrd27139653
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2018 15:00:59 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mftnf7hug-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2018 15:00:58 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Thu, 13 Sep 2018 15:00:54 -0400
Subject: Re: [PATCH 4/4] media: platform: Add Aspeed Video Engine driver
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, andrew@aj.id.au,
        openbmc@lists.ozlabs.org, sboyd@kernel.org,
        mturquette@baylibre.com, robh+dt@kernel.org, mchehab@kernel.org,
        linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
References: <1535576973-8067-1-git-send-email-eajames@linux.vnet.ibm.com>
 <1535576973-8067-5-git-send-email-eajames@linux.vnet.ibm.com>
 <77243417-e832-dcfa-0eeb-d45f356dd9e8@xs4all.nl>
From: Eddie James <eajames@linux.vnet.ibm.com>
Date: Thu, 13 Sep 2018 14:00:39 -0500
MIME-Version: 1.0
In-Reply-To: <77243417-e832-dcfa-0eeb-d45f356dd9e8@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Message-Id: <5cd805fa-31e9-a011-f8cd-32590125f136@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/03/2018 06:40 AM, Hans Verkuil wrote:
> On 08/29/2018 11:09 PM, Eddie James wrote:
>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>> can capture and compress video data from digital or analog sources. With
>> the Aspeed chip acting a service processor, the Video Engine can capture
>> the host processor graphics output.
>>
>> Add a V4L2 driver to capture video data and compress it to JPEG images,
>> making the data available through a standard read interface.
>>
>> Signed-off-by: Eddie James <eajames@linux.vnet.ibm.com>
>> ---
>>   drivers/media/platform/Kconfig        |    8 +
>>   drivers/media/platform/Makefile       |    1 +
>>   drivers/media/platform/aspeed-video.c | 1307 +++++++++++++++++++++++++++++++++
> Missing MAINTAINERS file update.
>
>>   3 files changed, 1316 insertions(+)
>>   create mode 100644 drivers/media/platform/aspeed-video.c
>> +
>> +static void aspeed_video_init_jpeg_table(u32 *table, bool yuv420)
>> +{
>> +	int i;
>> +	unsigned int base;
>> +
>> +	for (i = 0; i < ASPEED_VIDEO_JPEG_NUM_QUALITIES; i++) {
>> +		int j;
>> +
>> +		base = 256 * i;	/* AST HW requires this header spacing */
>> +
>> +		for (j = 0; j < ASPEED_VIDEO_JPEG_HEADER_SIZE; j++)
>> +			table[base + j] =
>> +				le32_to_cpu(aspeed_video_jpeg_header[j]);
> This doesn't look right. These tables are in cpu format to begin with,
> so le32_to_cpu doesn't make sense.
>
> BTW, what is the endianness of an aspeed SoC?

Hi,

Yes, Aspeed SoCs are LE, it's a standard ARM core. I'll do a simple copy 
instead of converting endianness, since this code can really only run on 
an Aspeed chip anyway.

>
>> +
>> +		base += ASPEED_VIDEO_JPEG_HEADER_SIZE;
>> +		for (j = 0; j < ASPEED_VIDEO_JPEG_DCT_SIZE; j++)
>> +			table[base + j] =
>> +				le32_to_cpu(aspeed_video_jpeg_dct[i][j]);
>> +
>> +		base += ASPEED_VIDEO_JPEG_DCT_SIZE;
>> +		for (j = 0; j < ASPEED_VIDEO_JPEG_QUANT_SIZE; j++)
>> +			table[base + j] =
>> +				le32_to_cpu(aspeed_video_jpeg_quant[j]);
>> +
>> +		if (yuv420)
>> +			table[base + 2] = le32_to_cpu(0x00220103);
>> +	}
>> +}
>> +
>> +
>> +static int aspeed_video_querycap(struct file *file, void *fh,
>> +				 struct v4l2_capability *cap)
>> +{
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	strncpy(cap->driver, DEVICE_NAME, sizeof(cap->driver));
> Use strlcpy.
>
> Also fill in bus_info ("platform:<foo>").
>
>> +	cap->capabilities = video->vdev.device_caps | V4L2_CAP_DEVICE_CAPS;
> You can drop this, it's filled in for you.
>
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_get_format(struct file *file, void *fh,
>> +				   struct v4l2_format *f)
>> +{
>> +	int rc;
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	if (test_bit(VIDEO_RES_CHANGE, &video->flags)) {
>> +		if (file->f_flags & O_NONBLOCK)
>> +			return -EAGAIN;
>> +
>> +		rc = wait_event_interruptible(video->wait,
>> +					      !test_bit(VIDEO_RES_CHANGE,
>> +							&video->flags));
>> +		if (rc)
>> +			return -EINTR;
> No, get_format should always just return the currently set format,
> not the format that is detected.
>
> Use VIDIOC_QUERY_DV_TIMINGS for that.
>
>> +	}
>> +
>> +	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> Drop this, not needed.
>
>> +	f->fmt.pix = video->fmt;
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_set_format(struct file *file, void *fh,
>> +				   struct v4l2_format *f)
>> +{
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	if (f->fmt.pix.pixelformat == video->fmt.pixelformat)
>> +		return 0;
>> +
>> +	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV444) {
>> +		video->fmt.pixelformat = V4L2_PIX_FMT_YUV444;
>> +		aspeed_video_init_jpeg_table(video->jpeg.virt, false);
>> +		aspeed_video_update(video, VE_SEQ_CTRL, ~VE_SEQ_CTRL_YUV420,
>> +				    0);
>> +	} else if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420) {
>> +		video->fmt.pixelformat = V4L2_PIX_FMT_YUV420;
>> +		aspeed_video_init_jpeg_table(video->jpeg.virt, true);
>> +		aspeed_video_update(video, VE_SEQ_CTRL, 0xFFFFFFFF,
>> +				    VE_SEQ_CTRL_YUV420);
> This isn't filling in any of the other fields.
>
>> +	} else {
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_get_jpegcomp(struct file *file, void *fh,
>> +				     struct v4l2_jpegcompression *a)
>> +{
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	a->quality = video->jpeg_quality;
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_set_jpegcomp(struct file *file, void *fh,
>> +				     const struct v4l2_jpegcompression *a)
>> +{
>> +	u32 comp_ctrl;
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	if (a->quality < 0 || a->quality > 11)
>> +		return -EINVAL;
>> +
>> +	video->jpeg_quality = a->quality;
>> +	comp_ctrl = FIELD_PREP(VE_COMP_CTRL_DCT_LUM, video->jpeg_quality) |
>> +		FIELD_PREP(VE_COMP_CTRL_DCT_CHR, video->jpeg_quality | 0x10);
>> +
>> +	aspeed_video_update(video, VE_COMP_CTRL,
>> +			    ~(VE_COMP_CTRL_DCT_LUM | VE_COMP_CTRL_DCT_CHR),
>> +			    comp_ctrl);
>> +
>> +	return 0;
>> +}
> As the spec says, the jpegcomp ioctls are deprecated and you should use
> JPEG controls instead.
>
> See: https://hverkuil.home.xs4all.nl/spec/uapi/v4l/vidioc-g-jpegcomp.html
>
> I stop reviewing here, since the first thing you need to do is to run
> v4l2-compliance for your device driver.
>
> See my reply to patch 0/4.
>
> Regards,
>
> 	Hans

Thanks for all the comments! I have addressed these items and will push 
up another patch set.

Thanks,
Eddie

>
>> +
>> +static int aspeed_video_get_parm(struct file *file, void *fh,
>> +				 struct v4l2_streamparm *a)
>> +{
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>>
