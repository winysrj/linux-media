Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53287 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab2FRJsh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 05:48:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 19/32] v4l2-dev.c: add debug sysfs entry.
Date: Mon, 18 Jun 2012 11:48:45 +0200
Message-ID: <2726131.qTANhh3UOc@avalon>
In-Reply-To: <233efccc7faab9711b8d146fa0f607324add3e22.1339321562.git.hans.verkuil@cisco.com>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <233efccc7faab9711b8d146fa0f607324add3e22.1339321562.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Sunday 10 June 2012 12:25:41 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/v4l2-dev.c |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 1500208..5c0bb18 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -46,6 +46,29 @@ static ssize_t show_index(struct device *cd,
>  	return sprintf(buf, "%i\n", vdev->index);
>  }
> 
> +static ssize_t show_debug(struct device *cd,
> +			 struct device_attribute *attr, char *buf)
> +{
> +	struct video_device *vdev = to_video_device(cd);
> +
> +	return sprintf(buf, "%i\n", vdev->debug);
> +}
> +
> +static ssize_t set_debug(struct device *cd, struct device_attribute *attr,
> +		   const char *buf, size_t len)
> +{
> +	struct video_device *vdev = to_video_device(cd);
> +	int res = 0;
> +	u16 value;
> +
> +	res = kstrtou16(buf, 0, &value);
> +	if (res)
> +		return res;
> +
> +	vdev->debug = value;

Can't this race with the various vdev->debug tests we have in the V4L core ?

> +	return len;
> +}
> +
>  static ssize_t show_name(struct device *cd,
>  			 struct device_attribute *attr, char *buf)
>  {
> @@ -56,6 +79,7 @@ static ssize_t show_name(struct device *cd,
> 
>  static struct device_attribute video_device_attrs[] = {
>  	__ATTR(name, S_IRUGO, show_name, NULL),
> +	__ATTR(debug, 0644, show_debug, set_debug),
>  	__ATTR(index, S_IRUGO, show_index, NULL),
>  	__ATTR_NULL
>  };
-- 
Regards,

Laurent Pinchart

