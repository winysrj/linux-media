Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35214 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab0HBIlk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 04:41:40 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L6I00DOOO5EX0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Aug 2010 09:41:38 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L6I00K83O5EO6@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Aug 2010 09:41:38 +0100 (BST)
Date: Mon, 02 Aug 2010 10:40:02 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH v5 2/3] v4l: Add multi-planar ioctl handling code
In-reply-to: <201008011430.30145.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>
Message-id: <002901cb321e$4c96f3c0$e5c4db40$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1280479783-23945-1-git-send-email-p.osciak@samsung.com>
 <1280479783-23945-3-git-send-email-p.osciak@samsung.com>
 <201008011430.30145.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>Hans Verkuil <hverkuil@xs4all.nl> wrote:
>On Friday 30 July 2010 10:49:42 Pawel Osciak wrote:

<snip>

>>  static long __video_do_ioctl(struct file *file,
>>  		unsigned int cmd, void *arg)
>>  {
>>  	struct video_device *vfd = video_devdata(file);
>>  	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
>>  	void *fh = file->private_data;
>> +	struct v4l2_format f_copy;
>>  	long ret = -EINVAL;
>>
>>  	if (ops == NULL) {
>> @@ -720,6 +822,11 @@ static long __video_do_ioctl(struct file *file,
>>  			if (ops->vidioc_enum_fmt_vid_cap)
>>  				ret = ops->vidioc_enum_fmt_vid_cap(file, fh, f);
>>  			break;
>> +		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>> +			if (ops->vidioc_enum_fmt_vid_cap_mplane)
>> +				ret = ops->vidioc_enum_fmt_vid_cap_mplane(file,
>> +									fh, f);
>> +			break;
>>  		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>>  			if (ops->vidioc_enum_fmt_vid_overlay)
>>  				ret = ops->vidioc_enum_fmt_vid_overlay(file,
>> @@ -729,6 +836,11 @@ static long __video_do_ioctl(struct file *file,
>>  			if (ops->vidioc_enum_fmt_vid_out)
>>  				ret = ops->vidioc_enum_fmt_vid_out(file, fh, f);
>>  			break;
>> +		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>> +			if (ops->vidioc_enum_fmt_vid_out_mplane)
>> +				ret = ops->vidioc_enum_fmt_vid_out_mplane(file,
>> +									fh, f);
>> +			break;
>>  		case V4L2_BUF_TYPE_PRIVATE:
>>  			if (ops->vidioc_enum_fmt_type_private)
>>  				ret = ops->vidioc_enum_fmt_type_private(file,
>> @@ -757,22 +869,79 @@ static long __video_do_ioctl(struct file *file,
>>
>>  		switch (f->type) {
>>  		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>> -			if (ops->vidioc_g_fmt_vid_cap)
>> +			if (ops->vidioc_g_fmt_vid_cap) {
>>  				ret = ops->vidioc_g_fmt_vid_cap(file, fh, f);
>> +			} else if (ops->vidioc_g_fmt_vid_cap_mplane) {
>> +				if (fmt_sp_to_mp(f, &f_copy))
>> +					break;
>> +				ret = ops->vidioc_g_fmt_vid_cap_mplane(file, fh,
>> +									&f_copy);
>> +				/* Driver is currently in multi-planar format,
>> +				 * we can't return it in single-planar API*/
>> +				if (f_copy.fmt.pix_mp.num_planes > 1) {
>
>Only do this if ret == 0.
>

Good point, thanks. Driver-produced errors should take precedence over EBUSY.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





