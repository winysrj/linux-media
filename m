Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51243 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2JTKK1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 06:10:27 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so451775eek.19
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2012 03:10:26 -0700 (PDT)
Message-ID: <50827890.9090201@gmail.com>
Date: Sat, 20 Oct 2012 12:10:24 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org
Subject: Re: [PATCH 1/1] [media] s5p-fimc: Fix potential NULL pointer dereference
References: <1350128479-9619-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1350128479-9619-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 10/13/2012 01:41 PM, Sachin Kamat wrote:
> 'fimc' was being dereferenced before the NULL check.
> Moved it to after the check.
>
> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
> ---
>   drivers/media/platform/s5p-fimc/fimc-mdevice.c |    6 ++++--
>   1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
> index 80ada58..61fab00 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
> @@ -343,7 +343,7 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
>   static int fimc_register_callback(struct device *dev, void *p)
>   {
>   	struct fimc_dev *fimc = dev_get_drvdata(dev);
> -	struct v4l2_subdev *sd =&fimc->vid_cap.subdev;
> +	struct v4l2_subdev *sd;
>   	struct fimc_md *fmd = p;
>   	int ret = 0;
>
> @@ -353,6 +353,7 @@ static int fimc_register_callback(struct device *dev, void *p)
>   	if (fimc->pdev->id<  0 || fimc->pdev->id>= FIMC_MAX_DEVS)
>   		return 0;
>
> +	sd =&fimc->vid_cap.subdev;
>   	fimc->pipeline_ops =&fimc_pipeline_ops;
>   	fmd->fimc[fimc->pdev->id] = fimc;
>   	sd->grp_id = FIMC_GROUP_ID;
> @@ -369,7 +370,7 @@ static int fimc_register_callback(struct device *dev, void *p)
>   static int fimc_lite_register_callback(struct device *dev, void *p)
>   {
>   	struct fimc_lite *fimc = dev_get_drvdata(dev);
> -	struct v4l2_subdev *sd =&fimc->subdev;
> +	struct v4l2_subdev *sd;

Thank you for the patch. May I ask you to remove sd instead and to
replace sd with fimc->subdev ? There are just two references of
sd below.

>   	struct fimc_md *fmd = p;
>   	int ret;
>
> @@ -379,6 +380,7 @@ static int fimc_lite_register_callback(struct device *dev, void *p)
>   	if (fimc->index>= FIMC_LITE_MAX_DEVS)
>   		return 0;
>
> +	sd =&fimc->subdev;
>   	fimc->pipeline_ops =&fimc_pipeline_ops;
>   	fmd->fimc_lite[fimc->index] = fimc;
>   	sd->grp_id = FLITE_GROUP_ID;

Thanks,
Sylwester
