Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21275 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbaAaRxA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 12:53:00 -0500
Message-ID: <52EBE2F9.5@linux.intel.com>
Date: Fri, 31 Jan 2014 19:52:57 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/1] v4l: subdev: Allow 32-bit compat IOCTLs
References: <52EBCA3D.2040106@xs4all.nl> <1391184952-22223-1-git-send-email-sakari.ailus@linux.intel.com> <52EBDED0.7020007@xs4all.nl>
In-Reply-To: <52EBDED0.7020007@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
> On 01/31/2014 05:15 PM, Sakari Ailus wrote:
>> I thought this was already working but apparently not. Allow 32-bit compat
>> IOCTLs on 64-bit systems.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>> index 8f7a6a4..1fce944 100644
>> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>> @@ -1087,6 +1087,18 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>>   	case VIDIOC_QUERY_DV_TIMINGS:
>>   	case VIDIOC_DV_TIMINGS_CAP:
>>   	case VIDIOC_ENUM_FREQ_BANDS:
>> +		/* Sub-device IOCTLs */
>> +	case VIDIOC_SUBDEV_G_FMT:
>> +	case VIDIOC_SUBDEV_S_FMT:
>> +	case VIDIOC_SUBDEV_G_FRAME_INTERVAL:
>> +	case VIDIOC_SUBDEV_S_FRAME_INTERVAL:
>> +	case VIDIOC_SUBDEV_ENUM_MBUS_CODE:
>> +	case VIDIOC_SUBDEV_ENUM_FRAME_SIZE:
>> +	case VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL:
>> +	case VIDIOC_SUBDEV_G_CROP:
>> +	case VIDIOC_SUBDEV_S_CROP:
>> +	case VIDIOC_SUBDEV_G_SELECTION:
>> +	case VIDIOC_SUBDEV_S_SELECTION:
>>   	case VIDIOC_SUBDEV_G_EDID32:
>>   	case VIDIOC_SUBDEV_S_EDID32:
>>   		ret = do_video_ioctl(file, cmd, arg);
>>
>
> Can you test with contrib/test/ioctl-test? Compile with:
>
> gcc -o ioctl-test -m32 -I ../../include/ ioctl-test.c
>
> Make sure you use the latest v4l-utils version and run autoreconf -vfi
> and configure first.
>
> BTW, I noticed that VIDIOC_DBG_G_CHIP_INFO is missing as well.
>
> Hmm, this is just asking for problems.
>
> How about this patch:
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 8f7a6a4..cd9da4ce 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -1001,108 +1001,19 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>   long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>   {
>   	struct video_device *vdev = video_devdata(file);
> -	long ret = -ENOIOCTLCMD;
> +	long ret = -ENOTTY;

I don't think we should return -ENOTTY here. The conversion is performed 
in compat_sys_ioctl() (in fs/compat_ioctl.c) which, if I understand 
correctly, expressly expects -ENOIOCTLCMD instead.

Otherwise this looks good to me.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
