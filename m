Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64779 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759068Ab2INRea (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 13:34:30 -0400
Received: by bkwj10 with SMTP id j10so1362498bkw.19
        for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:34:29 -0700 (PDT)
Message-ID: <50536AA2.5090507@gmail.com>
Date: Fri, 14 Sep 2012 19:34:26 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hans.verkuil@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFCv3 API PATCH 06/31] vivi/mem2mem_testdev: update to latest
 bus_info specification.
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com> <0d254e4e0e8976370c6741818a1b7bfae68b8bce.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <0d254e4e0e8976370c6741818a1b7bfae68b8bce.1347619766.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2012 12:57 PM, Hans Verkuil wrote:
> Prefix bus_info with "platform:".
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>

Looks good to me,

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>   drivers/media/platform/mem2mem_testdev.c |    3 ++-
>   drivers/media/platform/vivi.c            |    3 ++-
>   2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
> index 0b496f3..74de642 100644
> --- a/drivers/media/platform/mem2mem_testdev.c
> +++ b/drivers/media/platform/mem2mem_testdev.c
> @@ -430,7 +430,8 @@ static int vidioc_querycap(struct file *file, void *priv,
>   {
>   	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
>   	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
> -	strlcpy(cap->bus_info, MEM2MEM_NAME, sizeof(cap->bus_info));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info),
> +			"platform:%s", MEM2MEM_NAME);
>   	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
>   	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>   	return 0;
> diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> index a6351c4..7f3e6329 100644
> --- a/drivers/media/platform/vivi.c
> +++ b/drivers/media/platform/vivi.c
> @@ -898,7 +898,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
>
>   	strcpy(cap->driver, "vivi");
>   	strcpy(cap->card, "vivi");
> -	strlcpy(cap->bus_info, dev->v4l2_dev.name, sizeof(cap->bus_info));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info),
> +			"platform:%s", dev->v4l2_dev.name);
>   	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
>   			    V4L2_CAP_READWRITE;
>   	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

--

Regards,
Sylwester
