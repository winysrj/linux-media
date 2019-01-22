Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946A6C282C4
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 10:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6930320823
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 10:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbfAVKDQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 05:03:16 -0500
Received: from mga04.intel.com ([192.55.52.120]:41860 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727844AbfAVKDQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 05:03:16 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 02:03:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,505,1539673200"; 
   d="scan'208";a="313752991"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga005.fm.intel.com with ESMTP; 22 Jan 2019 02:03:13 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 84067205C8; Tue, 22 Jan 2019 12:03:12 +0200 (EET)
Date:   Tue, 22 Jan 2019 12:03:12 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     "Liu, Xinwu" <xinwu.liu@intel.com>
Cc:     mchehab@kernel.org, hans.verkuil@cisco.com,
        niklas.soderlund+renesas@ragnatech.se, ezequiel@collabora.com,
        sque@chromium.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: v4l2-core: expose the device after it was
 registered.
Message-ID: <20190122100311.isx57iktfpxawxjv@paasikivi.fi.intel.com>
References: <1548146084-20445-1-git-send-email-xinwu.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548146084-20445-1-git-send-email-xinwu.liu@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Xinwu,

On Tue, Jan 22, 2019 at 04:34:44PM +0800, Liu, Xinwu wrote:
> device_register exposes the device to userspace.
> 
> Therefore, while the register process is ongoing, the userspace program
> will fail to open the device (ENODEV will be set to errno currently).
> The program in userspace must re-open the device to cover this case.
> 
> It is more reasonable to expose the device after everythings ready.
> 
> Signed-off-by: Liu, Xinwu <xinwu.liu@intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-dev.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index d7528f8..01e5cc9 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -993,16 +993,11 @@ int __video_register_device(struct video_device *vdev,
>  		goto cleanup;
>  	}
>  
> -	/* Part 4: register the device with sysfs */
> +	/* Part 4: Prepare to register the device */
>  	vdev->dev.class = &video_class;
>  	vdev->dev.devt = MKDEV(VIDEO_MAJOR, vdev->minor);
>  	vdev->dev.parent = vdev->dev_parent;
>  	dev_set_name(&vdev->dev, "%s%d", name_base, vdev->num);
> -	ret = device_register(&vdev->dev);
> -	if (ret < 0) {
> -		pr_err("%s: device_register failed\n", __func__);
> -		goto cleanup;
> -	}
>  	/* Register the release callback that will be called when the last
>  	   reference to the device goes away. */
>  	vdev->dev.release = v4l2_device_release;
> @@ -1020,6 +1015,13 @@ int __video_register_device(struct video_device *vdev,
>  	/* Part 6: Activate this minor. The char device can now be used. */
>  	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
>  
> +	/* Part 7: Register the device with sysfs */
> +	ret = device_register(&vdev->dev);
> +	if (ret < 0) {
> +		pr_err("%s: device_register failed\n", __func__);
> +		goto cleanup;

The error handling needs to reflect the change as well.

Speaking of which, the error handling appears to be somewhat broken here.
It should be fixed first before making changes to the registration order.

The problem the patch addresses is related to another problem: how to tell
the user space all devices in the media hardware complex have been
registered successfully. Order generally has been the node first, and only
then the entity. That suggests the order should probably be:

1. video_register_media_controller
2. set_bit(V4L2_FL_REGISTERED)
3. device_register

I wonder what Hans thinks.

> +	}
> +
>  	return 0;
>  
>  cleanup:

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
