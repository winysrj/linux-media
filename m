Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3IJQBPF014377
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 15:26:11 -0400
Received: from smtp1.infomaniak.ch (smtp1.infomaniak.ch [84.16.68.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3IJPxCP032606
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 15:25:59 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Fri, 18 Apr 2008 21:33:21 +0200
References: <20080417012354.GH18929@outflux.net>
In-Reply-To: <20080417012354.GH18929@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804182133.21863.laurent.pinchart@skynet.be>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/2] V4L: add "function" sysfs attribute to v4l devices
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Kees,

On Thursday 17 April 2008, Kees Cook wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
>
> This adds a "function" string to help userspace to identify the type of
> device if multiple streams are available for a single v4l device.
>
> This is meant to be used with udev, to create persistent device links
> for v4l devices, which will not depend on module-loading/device-enumeration
> order.
>
> Cc: Kees Cook <kees@outflux.net>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> ---
>  drivers/media/video/v4l2-common.c |   39
> ++++++++++++++++++++++++++++++++++++++ drivers/media/video/videodev.c    | 
>  13 ++++++++++++
>  include/linux/videodev2.h         |   16 +++++++++++++++
>  include/media/v4l2-common.h       |    3 ++
>  include/media/v4l2-dev.h          |    1
>  5 files changed, 72 insertions(+)
> ---
> diff -r 6aa6656852cb linux/drivers/media/video/v4l2-common.c
> --- a/linux/drivers/media/video/v4l2-common.c	Wed Apr 16 13:13:15 2008
> -0300 +++ b/linux/drivers/media/video/v4l2-common.c	Wed Apr 16 17:52:29
> 2008 -0700 @@ -81,6 +81,45 @@ MODULE_LICENSE("GPL");
>   *  Video Standard Operations (contributed by Michael Schimek)
>   */
>
> +/*
> + * Exports "function" string to userspace to identify the type of device
> + * if multiple streams are available for a single device.
> + *
> + * Types/string names should be reused if possible, instead of adding
> + * new very device specific types, they must _uniquely_ identify all
> + * streams belonging to the _same_ device though.
> + *
> + * No single device must export multiple streams with the same function
> + * string, because userspace uses this to find the correct device node.
> + *
> + * Unlike the free-text "name", it must be an easily machine useable
> + * string containing only [a-z0-9._-] characters.
> + *
> + * Strings must not change without a valid reason, they are part of the
> + * sysfs ABI.
> + *
> + */
> +static const char *v4l2_function_type_names[] = {
> +	[V4L2_FN_VIDEO_CAP]		= "vid-cap",
> +	[V4L2_FN_VIDEO_OUT]		= "vid-out",
> +	[V4L2_FN_MPEG_CAP]		= "mpeg-cap",
> +	[V4L2_FN_MPEG_OUT]		= "mpeg-out",
> +	[V4L2_FN_YUV_CAP]		= "yuv-cap",
> +	[V4L2_FN_YUV_OUT]		= "yuv-out",

I don't like those. Video capture devices can encode pixels in a variety of 
formats. MPEG and YUV are only two special cases. You will find devices 
encoding in RGB, Bayer, MJPEG, ... as well as some proprietary formats.

If I understand your problem correctly, you want to differentiate between 
multiple v4l devices created by a single driver for a single hardware device. 
Using the above functions might work for ivtv but rules out devices that 
output multiple streams in the same format.

Wouldn't it be better to fix the ivtv driver to use a single device node for 
both compressed and uncompressed streams ?

> +	[V4L2_FN_VBI_CAP]		= "vbi-cap",
> +	[V4L2_FN_VBI_OUT]		= "vbi-out",
> +	[V4L2_FN_PCM_CAP]		= "pcm-cap",
> +	[V4L2_FN_PCM_OUT]		= "pcm-out",
> +	[V4L2_FN_RADIO_CAP]		= "radio-cap",
> +};
> +
> +const char *v4l2_function_name(enum v4l2_function_type function)
> +{
> +	if (function > 0 && function < ARRAY_SIZE(v4l2_function_type_names))
> +		return v4l2_function_type_names[function];
> +	return NULL;
> +}
> +EXPORT_SYMBOL(v4l2_function_name);
>
>  /* ----------------------------------------------------------------- */
>  /* priority handling                                                 */
> diff -r 6aa6656852cb linux/drivers/media/video/videodev.c
> --- a/linux/drivers/media/video/videodev.c	Wed Apr 16 13:13:15 2008 -0300
> +++ b/linux/drivers/media/video/videodev.c	Wed Apr 16 17:52:29 2008 -0700
> @@ -451,6 +451,18 @@ static DEVICE_ATTR(dev, S_IRUGO, show_de
>  static DEVICE_ATTR(dev, S_IRUGO, show_dev, NULL);
>  #endif
>
> +static ssize_t show_function(struct device *cd,
> +			     struct device_attribute *attr, char *buf)
> +{
> +	struct video_device *vfd = container_of(cd, struct video_device,
> +						class_dev);
> +	const char *function_name = v4l2_function_name(vfd->function);
> +
> +	if (!function_name)
> +		return -ENOSYS;
> +	return sprintf(buf, "%s\n", v4l2_function_name(vfd->function));
> +}
> +
>  struct video_device *video_device_alloc(void)
>  {
>  	struct video_device *vfd;
> @@ -486,6 +498,7 @@ static void video_release(struct device
>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,13)
>  static struct device_attribute video_device_attrs[] = {
>  	__ATTR(name, S_IRUGO, show_name, NULL),
> +	__ATTR(function, S_IRUGO, show_function, NULL),
>  	__ATTR_NULL
>  };
>  #endif
> diff -r 6aa6656852cb linux/include/linux/videodev2.h
> --- a/linux/include/linux/videodev2.h	Wed Apr 16 13:13:15 2008 -0300
> +++ b/linux/include/linux/videodev2.h	Wed Apr 16 17:52:29 2008 -0700
> @@ -138,6 +138,22 @@ enum v4l2_field {
>  	 (field) == V4L2_FIELD_INTERLACED_BT ||\
>  	 (field) == V4L2_FIELD_SEQ_TB ||\
>  	 (field) == V4L2_FIELD_SEQ_BT)
> +
> +/* Exports "function" string to userspace to identify type of device */
> +enum v4l2_function_type {
> +	V4L2_FN_UNDEFINED,
> +	V4L2_FN_VIDEO_CAP,
> +	V4L2_FN_VIDEO_OUT,
> +	V4L2_FN_MPEG_CAP,
> +	V4L2_FN_MPEG_OUT,
> +	V4L2_FN_YUV_CAP,
> +	V4L2_FN_YUV_OUT,
> +	V4L2_FN_VBI_CAP,
> +	V4L2_FN_VBI_OUT,
> +	V4L2_FN_PCM_CAP,
> +	V4L2_FN_PCM_OUT,
> +	V4L2_FN_RADIO_CAP,
> +};
>
>  enum v4l2_buf_type {
>  	V4L2_BUF_TYPE_VIDEO_CAPTURE        = 1,
> diff -r 6aa6656852cb linux/include/media/v4l2-common.h
> --- a/linux/include/media/v4l2-common.h	Wed Apr 16 13:13:15 2008 -0300
> +++ b/linux/include/media/v4l2-common.h	Wed Apr 16 17:52:29 2008 -0700
> @@ -67,6 +67,9 @@
>  			v4l_client_printk(KERN_DEBUG, client, fmt , ## arg); \
>  	} while (0)
>
> +
> +/* map function enum to string */
> +extern const char *v4l2_function_name(enum v4l2_function_type function);
>
>  /* Use this macro for non-I2C drivers. Pass the driver name as the first
> arg. */ #define v4l_print_ioctl(name, cmd)  		 \
> diff -r 6aa6656852cb linux/include/media/v4l2-dev.h
> --- a/linux/include/media/v4l2-dev.h	Wed Apr 16 13:13:15 2008 -0300
> +++ b/linux/include/media/v4l2-dev.h	Wed Apr 16 17:52:29 2008 -0700
> @@ -112,6 +112,7 @@ struct video_device
>  	char name[32];
>  	int type;       /* v4l1 */
>  	int type2;      /* v4l2 */
> +	enum v4l2_function_type function; /* sysfs string */
>  	int minor;
>
>  	int debug;	/* Activates debug level*/

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
