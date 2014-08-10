Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0087.hostedemail.com ([216.40.44.87]:45246 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751215AbaHJVAx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 17:00:53 -0400
Message-ID: <1407704449.4082.11.camel@joe-AO725>
Subject: Re: [PATCH] staging: soc_camera.c: fixed coding style: lines over
 80 char
From: Joe Perches <joe@perches.com>
To: Suman Kumar <suman@inforcecomputing.com>
Cc: hverkuil@xs4all.nl, g.liakhovetski@gmx.de, m.chehab@samsung.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Date: Sun, 10 Aug 2014 14:00:49 -0700
In-Reply-To: <1407703301-2037-1-git-send-email-suman@inforcecomputing.com>
References: <1407703301-2037-1-git-send-email-suman@inforcecomputing.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2014-08-11 at 02:11 +0530, Suman Kumar wrote:
>     Fixes a coding style issue of 'lines over 80 char' reported by
>     checkpatch.pl
[]
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
[]
> @@ -1430,7 +1434,7 @@ static int soc_camera_async_bound(struct v4l2_async_notifier *notifier,
>  				  struct v4l2_async_subdev *asd)
>  {
>  	struct soc_camera_async_client *sasc = container_of(notifier,
> -					struct soc_camera_async_client, notifier);
> +				    struct soc_camera_async_client, notifier);
>  	struct soc_camera_device *icd = platform_get_drvdata(sasc->pdev);

I don't easily parse the original or modified lines.

If you are really concerned abut 80 columns and readability
instead of merely quieting checkpatch, these might be better
on multiple lines like

	struct soc_camera_async_client *sasc;
	struct soc_camera_device *icd;

	sasc = container_of(notifier, struct soc_camera_async_client, notifier);
	icd = platform_get_drvdata(sasc->pdev);


