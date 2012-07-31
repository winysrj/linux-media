Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:35681 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119Ab2GaMSH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 08:18:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: Re: [PATCH v4 4/5] media: gscaler: Add m2m functionality for the G-Scaler driver
Date: Tue, 31 Jul 2012 14:18:04 +0200
Cc: linux-media@vger.kernel.org, sungchun.kang@samsung.com,
	khw0178.kim@samsung.com, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, sy0816.kang@samsung.com,
	s.nawrocki@samsung.com, posciak@google.com, alim.akhtar@gmail.com,
	prashanth.g@samsung.com, joshi@samsung.com, shaik.samsung@gmail.com
References: <1343736753-18454-1-git-send-email-shaik.ameer@samsung.com> <1343736753-18454-5-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1343736753-18454-5-git-send-email-shaik.ameer@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207311418.05012.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 31 July 2012 14:12:32 Shaik Ameer Basha wrote:
> From: Sungchun Kang <sungchun.kang@samsung.com>
> 
> This patch adds the memory to memory (m2m) interface functionality
> for the G-Scaler driver.
> 
> Signed-off-by: Hynwoong Kim <khw0178.kim@samsung.com>
> Signed-off-by: Sungchun Kang <sungchun.kang@samsung.com>
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  drivers/media/video/exynos-gsc/gsc-m2m.c |  772 ++++++++++++++++++++++++++++++
>  1 files changed, 772 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/exynos-gsc/gsc-m2m.c
> 
> diff --git a/drivers/media/video/exynos-gsc/gsc-m2m.c b/drivers/media/video/exynos-gsc/gsc-m2m.c
> new file mode 100644
> index 0000000..d7ecdb8
> --- /dev/null
> +++ b/drivers/media/video/exynos-gsc/gsc-m2m.c


> +static int gsc_m2m_querycap(struct file *file, void *fh,
> +			   struct v4l2_capability *cap)
> +{
> +	struct gsc_ctx *ctx = fh_to_ctx(fh);
> +	struct gsc_dev *gsc = ctx->gsc_dev;
> +
> +	strlcpy(cap->driver, gsc->pdev->name, sizeof(cap->driver));
> +	strlcpy(cap->card, gsc->pdev->name, sizeof(cap->card));
> +	strlcpy(cap->bus_info, "platform", sizeof(cap->bus_info));
> +	cap->device_caps = V4L2_CAP_STREAMING |
> +				V4L2_CAP_VIDEO_CAPTURE_MPLANE |
> +				V4L2_CAP_VIDEO_OUTPUT_MPLANE;

Yesterday the new V4L2_CAP_M2M_PLANE was added. You should add this
capability here. It is up to you to decide whether to remove the
CAPTURE_MPLANE and OUTPUT_MPLANE caps at the same time, or leave them for
a bit until any applications have had the chance to use the new M2M capability.

Combining the capture and output caps caused problems since apps would misdetect
this as a normal capture device instead of an M2M device. It's only for a
transition time that all three caps are allowed.

Regards,

	Hans
