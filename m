Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4345 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942AbaAaRfa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 12:35:30 -0500
Message-ID: <52EBDED0.7020007@xs4all.nl>
Date: Fri, 31 Jan 2014 18:35:12 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/1] v4l: subdev: Allow 32-bit compat IOCTLs
References: <52EBCA3D.2040106@xs4all.nl> <1391184952-22223-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1391184952-22223-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 01/31/2014 05:15 PM, Sakari Ailus wrote:
> I thought this was already working but apparently not. Allow 32-bit compat
> IOCTLs on 64-bit systems.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 8f7a6a4..1fce944 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -1087,6 +1087,18 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>  	case VIDIOC_QUERY_DV_TIMINGS:
>  	case VIDIOC_DV_TIMINGS_CAP:
>  	case VIDIOC_ENUM_FREQ_BANDS:
> +		/* Sub-device IOCTLs */
> +	case VIDIOC_SUBDEV_G_FMT:
> +	case VIDIOC_SUBDEV_S_FMT:
> +	case VIDIOC_SUBDEV_G_FRAME_INTERVAL:
> +	case VIDIOC_SUBDEV_S_FRAME_INTERVAL:
> +	case VIDIOC_SUBDEV_ENUM_MBUS_CODE:
> +	case VIDIOC_SUBDEV_ENUM_FRAME_SIZE:
> +	case VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL:
> +	case VIDIOC_SUBDEV_G_CROP:
> +	case VIDIOC_SUBDEV_S_CROP:
> +	case VIDIOC_SUBDEV_G_SELECTION:
> +	case VIDIOC_SUBDEV_S_SELECTION:
>  	case VIDIOC_SUBDEV_G_EDID32:
>  	case VIDIOC_SUBDEV_S_EDID32:
>  		ret = do_video_ioctl(file, cmd, arg);
> 

Can you test with contrib/test/ioctl-test? Compile with:

gcc -o ioctl-test -m32 -I ../../include/ ioctl-test.c

Make sure you use the latest v4l-utils version and run autoreconf -vfi
and configure first.

BTW, I noticed that VIDIOC_DBG_G_CHIP_INFO is missing as well.

Hmm, this is just asking for problems. 

How about this patch:

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 8f7a6a4..cd9da4ce 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -1001,108 +1001,19 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct video_device *vdev = video_devdata(file);
-	long ret = -ENOIOCTLCMD;
+	long ret = -ENOTTY;
 
 	if (!file->f_op->unlocked_ioctl)
 		return ret;
 
-	switch (cmd) {
-	case VIDIOC_QUERYCAP:
-	case VIDIOC_RESERVED:
-	case VIDIOC_ENUM_FMT:
-	case VIDIOC_G_FMT32:
-	case VIDIOC_S_FMT32:
-	case VIDIOC_REQBUFS:
-	case VIDIOC_QUERYBUF32:
-	case VIDIOC_G_FBUF32:
-	case VIDIOC_S_FBUF32:
-	case VIDIOC_OVERLAY32:
-	case VIDIOC_QBUF32:
-	case VIDIOC_EXPBUF:
-	case VIDIOC_DQBUF32:
-	case VIDIOC_STREAMON32:
-	case VIDIOC_STREAMOFF32:
-	case VIDIOC_G_PARM:
-	case VIDIOC_S_PARM:
-	case VIDIOC_G_STD:
-	case VIDIOC_S_STD:
-	case VIDIOC_ENUMSTD32:
-	case VIDIOC_ENUMINPUT32:
-	case VIDIOC_G_CTRL:
-	case VIDIOC_S_CTRL:
-	case VIDIOC_G_TUNER:
-	case VIDIOC_S_TUNER:
-	case VIDIOC_G_AUDIO:
-	case VIDIOC_S_AUDIO:
-	case VIDIOC_QUERYCTRL:
-	case VIDIOC_QUERYMENU:
-	case VIDIOC_G_INPUT32:
-	case VIDIOC_S_INPUT32:
-	case VIDIOC_G_OUTPUT32:
-	case VIDIOC_S_OUTPUT32:
-	case VIDIOC_ENUMOUTPUT:
-	case VIDIOC_G_AUDOUT:
-	case VIDIOC_S_AUDOUT:
-	case VIDIOC_G_MODULATOR:
-	case VIDIOC_S_MODULATOR:
-	case VIDIOC_S_FREQUENCY:
-	case VIDIOC_G_FREQUENCY:
-	case VIDIOC_CROPCAP:
-	case VIDIOC_G_CROP:
-	case VIDIOC_S_CROP:
-	case VIDIOC_G_SELECTION:
-	case VIDIOC_S_SELECTION:
-	case VIDIOC_G_JPEGCOMP:
-	case VIDIOC_S_JPEGCOMP:
-	case VIDIOC_QUERYSTD:
-	case VIDIOC_TRY_FMT32:
-	case VIDIOC_ENUMAUDIO:
-	case VIDIOC_ENUMAUDOUT:
-	case VIDIOC_G_PRIORITY:
-	case VIDIOC_S_PRIORITY:
-	case VIDIOC_G_SLICED_VBI_CAP:
-	case VIDIOC_LOG_STATUS:
-	case VIDIOC_G_EXT_CTRLS32:
-	case VIDIOC_S_EXT_CTRLS32:
-	case VIDIOC_TRY_EXT_CTRLS32:
-	case VIDIOC_ENUM_FRAMESIZES:
-	case VIDIOC_ENUM_FRAMEINTERVALS:
-	case VIDIOC_G_ENC_INDEX:
-	case VIDIOC_ENCODER_CMD:
-	case VIDIOC_TRY_ENCODER_CMD:
-	case VIDIOC_DECODER_CMD:
-	case VIDIOC_TRY_DECODER_CMD:
-	case VIDIOC_DBG_S_REGISTER:
-	case VIDIOC_DBG_G_REGISTER:
-	case VIDIOC_S_HW_FREQ_SEEK:
-	case VIDIOC_S_DV_TIMINGS:
-	case VIDIOC_G_DV_TIMINGS:
-	case VIDIOC_DQEVENT:
-	case VIDIOC_DQEVENT32:
-	case VIDIOC_SUBSCRIBE_EVENT:
-	case VIDIOC_UNSUBSCRIBE_EVENT:
-	case VIDIOC_CREATE_BUFS32:
-	case VIDIOC_PREPARE_BUF32:
-	case VIDIOC_ENUM_DV_TIMINGS:
-	case VIDIOC_QUERY_DV_TIMINGS:
-	case VIDIOC_DV_TIMINGS_CAP:
-	case VIDIOC_ENUM_FREQ_BANDS:
-	case VIDIOC_SUBDEV_G_EDID32:
-	case VIDIOC_SUBDEV_S_EDID32:
+	if (_IOC_NR(cmd) < BASE_VIDIOC_PRIVATE)
 		ret = do_video_ioctl(file, cmd, arg);
-		break;
+	else if (vdev->fops->compat_ioctl32)
+		ret = vdev->fops->compat_ioctl32(file, cmd, arg);
 
-	default:
-		if (vdev->fops->compat_ioctl32)
-			ret = vdev->fops->compat_ioctl32(file, cmd, arg);
-
-		if (ret == -ENOIOCTLCMD)
-			printk(KERN_WARNING "compat_ioctl32: "
-				"unknown ioctl '%c', dir=%d, #%d (0x%08x)\n",
-				_IOC_TYPE(cmd), _IOC_DIR(cmd), _IOC_NR(cmd),
-				cmd);
-		break;
-	}
+	if (ret == -ENOTTY)
+		pr_warn("compat_ioctl32: unknown ioctl '%c', dir=%d, #%d (0x%08x)\n",
+			_IOC_TYPE(cmd), _IOC_DIR(cmd), _IOC_NR(cmd), cmd);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(v4l2_compat_ioctl32);

Note the ENOIOCTLCMD to ENOTTY changes: ENOTTY should be returned if the ioctl is
not supported. Although v4l2-subdev seems to return ENOIOCTLCMD as well :-(

Regards,

	Hans
