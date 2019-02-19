Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20C5C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 10:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E8E52177E
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 10:17:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LykQ8S2r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbfBSKRc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 05:17:32 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55613 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbfBSKRc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 05:17:32 -0500
Received: by mail-wm1-f66.google.com with SMTP id q187so1918295wme.5
        for <linux-media@vger.kernel.org>; Tue, 19 Feb 2019 02:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=bZGm/o79nVBi1tR+G10qstDd0wWYCFOluVrsIO+/zeQ=;
        b=LykQ8S2rYToYJ5Ux6TazAzW1gRwOrF5L1x1fC3ykQTQ/EHPg+ZZHbRrh2I5Qg33c5b
         Vyyv8yrlqWjjEJ2hPUJItNuKPVT4X8ZjAJ8t4jz20bOhQreLrrXkD4F6tHUnLSufx0CT
         CX7+u97HNjx19NxItmpbklYF52r4dlBTtD1oeYuZKHBO/o0O7CgZhi/m39+gQqAQ7G8g
         1ibisVCE+Rd8uYDJI8Y8aSvdtrWaCkIUhLj1of5QxYFS2ScqCY68jvAfVKX0OBvwS0u+
         9Z941+jJgT8U4Jb4otb8L8WRuAyRScwQx6sTwewtB6Lgws0iGHd+RlRSobCt0A+fN5pu
         nvAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=bZGm/o79nVBi1tR+G10qstDd0wWYCFOluVrsIO+/zeQ=;
        b=pK1aNmkITgwVsor+7uOF2Bco9Jb3KLDJPnuQfW94EWoSfqs62w/B76k+D5iiRoxU4M
         5ichDmZYvRGYov8dZ7AnwgC6pTvi7BKw+jbpl8K+D2fV9dfEvEL1Qebvqq45zcbDFRpD
         QK7Aj6Oawqlc51//BEt9NZ0WZTvzNYzGmR5o/Nhly53n14wO6vYdy/XGRolZ0PKWzI1t
         Mu/d0d1aUMEAYRm7ExVKpJgo50jRDoIfPO8MYuL12kgbRTIUH0OCogczuQVfVXfcjQbN
         Mr+ncKz5GGk/ep2Y6ILQhK/w9S2lL7U71VotK07W8YTslsuT8DAkbpWFEPL1Lbizn1PV
         uV4w==
X-Gm-Message-State: AHQUAuZcnV0yN1Q/HwiiIOVsjxbnfs5OIEEj3H8FH5DK9KabFTUvzz/N
        mVymRTgonZJDTAR3E9Hd8ISkLg==
X-Google-Smtp-Source: AHgI3IbKxUF/kOTVLRPAe9b2znjXUS4NrRd0ibx2WTpQH6fC990JnIsGpk7xnF+hZq6UHWgnYgweeA==
X-Received: by 2002:a1c:7611:: with SMTP id r17mr2136607wmc.58.1550571449996;
        Tue, 19 Feb 2019 02:17:29 -0800 (PST)
Received: from arch-late ([87.196.73.44])
        by smtp.gmail.com with ESMTPSA id f134sm2916649wme.31.2019.02.19.02.17.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Feb 2019 02:17:29 -0800 (PST)
References: <bd961821-0cab-7bb5-372e-4e79f85988f1@xs4all.nl>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH] imx7-media-csi.c: fix merge breakage
In-reply-to: <bd961821-0cab-7bb5-372e-4e79f85988f1@xs4all.nl>
Date:   Tue, 19 Feb 2019 10:17:25 +0000
Message-ID: <m3lg2culoq.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,
On Tue 19 Feb 2019 at 07:38, Hans Verkuil wrote:
> Commit 5964cbd86922 ("imx: Set capture compose rectangle in
> capture_device_set_format") broke the compilation of commit
> 05f634040c0d ("staging/imx7: add imx7 CSI subdev driver").
>
> These patches came in through different pull requests and
> nobody noticed that the first changed functions that the
> second relied upon.
>
> Update imx7-media-csi.c accordingly.
>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

I am travelling, with no possibility to test this, but LGTM.
Thanks for this.

Acked-by: Rui Miguel Silva <rui.silva@linaro.org>

---
Cheers,
	Rui


> ---
> diff --git a/drivers/staging/media/imx/imx7-media-csi.c 
> b/drivers/staging/media/imx/imx7-media-csi.c
> index c1cf80bcad64..d775e259fece 100644
> --- a/drivers/staging/media/imx/imx7-media-csi.c
> +++ b/drivers/staging/media/imx/imx7-media-csi.c
> @@ -1036,6 +1036,7 @@ static int imx7_csi_set_fmt(struct 
> v4l2_subdev *sd,
>  	const struct imx_media_pixfmt *outcc;
>  	struct v4l2_mbus_framefmt *outfmt;
>  	struct v4l2_pix_format vdev_fmt;
> +	struct v4l2_rect vdev_compose;
>  	const struct imx_media_pixfmt *cc;
>  	struct v4l2_mbus_framefmt *fmt;
>  	struct v4l2_subdev_format format;
> @@ -1082,11 +1083,11 @@ static int imx7_csi_set_fmt(struct 
> v4l2_subdev *sd,
>  	csi->cc[sdformat->pad] = cc;
>
>  	/* propagate output pad format to capture device */
> -	imx_media_mbus_fmt_to_pix_fmt(&vdev_fmt,
> +	imx_media_mbus_fmt_to_pix_fmt(&vdev_fmt, &vdev_compose,
>  				      &csi->format_mbus[IMX7_CSI_PAD_SRC],
>  				      csi->cc[IMX7_CSI_PAD_SRC]);
>  	mutex_unlock(&csi->lock);
> -	imx_media_capture_device_set_format(vdev, &vdev_fmt);
> +	imx_media_capture_device_set_format(vdev, &vdev_fmt, 
> &vdev_compose);
>
>  	return 0;

