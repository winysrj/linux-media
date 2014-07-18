Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2179 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713AbaGRFK7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 01:10:59 -0400
Message-ID: <53C8AC58.7070101@xs4all.nl>
Date: Fri, 18 Jul 2014 07:10:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 03/23] v4l: Support extending the v4l2_pix_format structure
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1403567669-18539-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <53C83EA0.2010706@xs4all.nl>
In-Reply-To: <53C83EA0.2010706@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/17/2014 11:22 PM, Hans Verkuil wrote:
> And another thing that I found while implementing this in v4l2-ctl:
> 
> On 06/24/2014 01:54 AM, Laurent Pinchart wrote:
>> The v4l2_pix_format structure has no reserved field. It is embedded in
>> the v4l2_framebuffer structure which has no reserved fields either, and
>> in the v4l2_format structure which has reserved fields that were not
>> previously required to be zeroed out by applications.
>>
>> To allow extending v4l2_pix_format, inline it in the v4l2_framebuffer
>> structure, and use the priv field as a magic value to indicate that the
>> application has set all v4l2_pix_format extended fields and zeroed all
>> reserved fields following the v4l2_pix_format field in the v4l2_format
>> structure.
>>
>> The availability of this API extension is reported to userspace through
>> the new V4L2_CAP_EXT_PIX_FORMAT capability flag. Just checking that the
>> priv field is still set to the magic value at [GS]_FMT return wouldn't
>> be enough, as older kernels don't zero the priv field on return.
>>
>> To simplify the internal API towards drivers zero the extended fields
>> and set the priv field to the magic value for applications not aware of
>> the extensions.
>>
>> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
>> index 16bffd8..01b4588 100644
>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>> @@ -959,13 +959,48 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
>>  	return -EINVAL;
>>  }
>>  
>> +static void v4l_sanitize_format(struct v4l2_format *fmt)
>> +{
>> +	unsigned int offset;
>> +
>> +	/*
>> +	 * The v4l2_pix_format structure has been extended with fields that were
>> +	 * not previously required to be set to zero by applications. The priv
>> +	 * field, when set to a magic value, indicates the the extended fields
>> +	 * are valid. Otherwise they will contain undefined values. To simplify
>> +	 * the API towards drivers zero the extended fields and set the priv
>> +	 * field to the magic value when the extended pixel format structure
>> +	 * isn't used by applications.
>> +	 */
>> +
>> +	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
>> +	    fmt->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
>> +		return;
>> +
>> +	if (fmt->fmt.pix.priv == V4L2_PIX_FMT_PRIV_MAGIC)
>> +		return;
>> +
>> +	fmt->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
>> +
>> +	offset = offsetof(struct v4l2_pix_format, priv)
>> +	       + sizeof(fmt->fmt.pix.priv);
>> +	memset(((void *)&fmt->fmt.pix) + offset, 0,
>> +	       sizeof(fmt->fmt.pix) - offset);
>> +}
>> +
>>  static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
>>  				struct file *file, void *fh, void *arg)
>>  {
>>  	struct v4l2_capability *cap = (struct v4l2_capability *)arg;
>> +	int ret;
>>  
>>  	cap->version = LINUX_VERSION_CODE;
>> -	return ops->vidioc_querycap(file, fh, cap);
>> +
>> +	ret = ops->vidioc_querycap(file, fh, cap);
>> +
>> +	cap->capabilities |= V4L2_CAP_EXT_PIX_FORMAT;
> 
> It should be ORed to cap->device_caps as well.

But only if cap->capabilities sets V4L2_CAP_DEVICE_CAPS.

Should we unconditionally add this flag or only if CAP_VIDEO_CAPTURE or
CAP_VIDEO_OUTPUT is set?

So we could do this:

	if (cap->capabilities & (V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT))
		cap->capabilities |= V4L2_CAP_EXT_PIX_FORMAT;
	if ((cap->capabilities & V4L2_CAP_DEVICE_CAPS) &&
	    (cap->device_caps & (V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT))
		cap->device_caps |= V4L2_CAP_EXT_PIX_FORMAT;


I can argue either direction: on the one hand ext_pix_format handling is part
of the v4l2 core, so it is valid for all that use it, on the other hand it
makes no sense for a non-video device.

My preference would be to set it only in combination with video capture/output
since it just looks peculiar otherwise.

Regards,

	Hans
