Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51329 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbbB0Jco (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2015 04:32:44 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKF00DDMC1BFS90@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Feb 2015 09:36:47 +0000 (GMT)
Message-id: <54F039B7.5020800@samsung.com>
Date: Fri, 27 Feb 2015 10:32:39 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hans.verkuil@cisco.com,
	b.zolnierkie@samsung.com, kyungmin.park@samsung.com,
	sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH/RFC v4 11/11] Add a libv4l plugin for Exynos4 camera
References: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
 <1416586480-19982-12-git-send-email-j.anaszewski@samsung.com>
 <20141127084129.GM8907@valkosipuli.retiisi.org.uk>
In-reply-to: <20141127084129.GM8907@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 11/27/2014 09:41 AM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Fri, Nov 21, 2014 at 05:14:40PM +0100, Jacek Anaszewski wrote:
>> The plugin provides support for the media device on Exynos4 SoC.
>> It performs single plane <-> multi plane API conversion,
>> video pipeline linking and takes care of automatic data format
>> negotiation for the whole pipeline, after intercepting
>> VIDIOC_S_FMT or VIDIOC_TRY_FMT ioctls.
>>
[...]
>> +
>> +static void *plugin_init(int fd)
>> +{
>> +	struct v4l2_capability cap;
>> +	struct exynos4_camera_plugin *plugin = NULL;
>> +	const char *sink_entity_name;
>> +	struct media_device *media;
>> +	struct media_entity *sink_entity;
>> +	char video_devname[32];
>> +	int ret;
[...]
>> +	ret = SYS_IOCTL(fd, VIDIOC_QUERYCAP, &cap);
>> +	if (ret < 0) {
>> +		V4L2_EXYNOS4_ERR("Failed to query video capabilities.");
>> +		return NULL;
>> +	}
>> +
>> +	/* Check if this is Exynos4 media device */
>> +	if (strcmp((char *) cap.driver, EXYNOS4_FIMC_DRV) &&
>> +	    strcmp((char *) cap.driver, EXYNOS4_FIMC_LITE_DRV) &&
>> +	    strcmp((char *) cap.driver, EXYNOS4_FIMC_IS_ISP_DRV)) {
>> +		V4L2_EXYNOS4_ERR("Not an Exynos4 media device.");
>> +		return NULL;
>> +	}
>> +
>> +	/* Obtain the node name of the opened device */
>> +	ret = media_get_devname_by_fd(fd, video_devname);
>> +	if (ret < 0) {
>> +		V4L2_EXYNOS4_ERR("Failed to get video device node name.");
>> +		return NULL;
>> +	}
>> +
>> +	/*
>> +	 * Create the representation of a media device
>> +	 * containing the opened video device.
>> +	 */
>> +	media = media_device_new_by_entity_devname(video_devname);
>> +	if (media == NULL) {
>> +		V4L2_EXYNOS4_ERR("Failed to create media device.");
>> +		return NULL;
>> +	}
>> +
>> +#ifdef DEBUG
>> +	media_debug_set_handler(media, (void (*)(void *, ...))fprintf, stdout);
>> +#endif
>> +
>> +	/* Get the entity representing the opened video device node */
>> +	sink_entity = media_get_entity_by_devname(media, video_devname, strlen(video_devname));
>
> Could you use the fd directly instead of translating that to the device
> node? fstat(2) gives you directly inode / device major + minor which you can
> then use to find the MC device.

After trying to switch it as you requested I decided to stay by current
implementation to avoid the need for translating fd to device node
twice.

If we changed:

media_device_new_by_entity_devname -> media_device_new_by_entity_fd

then media_device_new_by_entity_fd would have to call fstat to find
out the entity node name. Nonetheless we would have to call fstat
one more time to obtain sink_entity to be passed below to
media_entity_get_name.

Therefore, it is better to obtain devname once and use it for
both creating media_device and obtaining sink_entity node name.


>> +	if (sink_entity == NULL) {
>> +		V4L2_EXYNOS4_ERR("Failed to get sinkd entity name.");
>> +		goto err_get_sink_entity;
>> +	}
>> +
>> +	/* The last entity in the pipeline represents video device node */
>> +	media_entity_set_fd(sink_entity, fd);
>> +
>> +	sink_entity_name = media_entity_get_name(sink_entity);
>> +
>> +	/* Check if video entity is of capture type, not m2m */
>> +	if (!__capture_entity(sink_entity_name)) {
>> +		V4L2_EXYNOS4_ERR("Device not of capture type.");
>> +		goto err_get_sink_entity;
>> +	}

-- 
Best Regards,
Jacek Anaszewski
