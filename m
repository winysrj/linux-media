Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A861AC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 05:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6994F20651
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 05:34:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SWEV51yR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbfAOFeK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 00:34:10 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45084 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfAOFeK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 00:34:10 -0500
Received: by mail-oi1-f193.google.com with SMTP id y1so1183279oie.12
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 21:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c3uk7JKIkM/xxVfoOp30bQcsnhQq1UF3hhVO6cI0KT4=;
        b=SWEV51yRmBRa6dEcpQWQLwDTJ5jRdL416eUl0K1BGRa9Lcs6vbo2IcoDZztYGLmeVK
         lPfR6O/tlsnVO1suIdZKL325uNkkrpyOUV0U8H+AxeZXzOADumQDugFchL/gJACuoik4
         BBp2dTQySWfPQ2wIFL4Obu9h8XfmIhal3x+4s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c3uk7JKIkM/xxVfoOp30bQcsnhQq1UF3hhVO6cI0KT4=;
        b=e5LKyLyLXHfsoUWumws561rnMMI/CD7oj/7VbUB89qhIe+D0846Vq0aDzxG8H/JCEN
         s3nEhIoLxKfqoD/Q7GuUOrowYL7bX0rCt8YHbygVy+qiDVc0+thrZD8dgErZAogg1dbp
         X2s32NuYlJDVDLkbcCHjUKBwhV2uEtictdAcE4CKkkEo7Apkt6HOYbvIBm/AjZU51NwF
         PNOFTCbMHfgH7uK+nP1fTH+dBZ+0KQjobrCxsc/06BaqbDjRsReGr2Q8OzT62pnh3iBy
         6HakyqsQIQk1ErIjftq1ba93ca9msviYwUc5gceraxKjtcT2BsIzAWeFYG0iN9FYo/+I
         a2cw==
X-Gm-Message-State: AJcUukcL62TwgCHXg+A+JYyHLVCgCGacc1TsG0ejbx9aHrhb3yW/bs42
        vrmsdaT88V9w0Alo8lOjlQZ/nhT+8QI=
X-Google-Smtp-Source: ALg8bN6x1B9t2FOhLsriw2B45uFFb52QDMJuNwxozLTDPxj1q2xSW8RyQ56zMvrasGS2tR2Uxtes1g==
X-Received: by 2002:aca:ea57:: with SMTP id i84mr1105917oih.346.1547530449164;
        Mon, 14 Jan 2019 21:34:09 -0800 (PST)
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com. [209.85.167.179])
        by smtp.gmail.com with ESMTPSA id q10sm1103205otl.15.2019.01.14.21.34.08
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 21:34:08 -0800 (PST)
Received: by mail-oi1-f179.google.com with SMTP id a77so1217840oii.5
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 21:34:08 -0800 (PST)
X-Received: by 2002:aca:c312:: with SMTP id t18mr1158321oif.92.1547530447792;
 Mon, 14 Jan 2019 21:34:07 -0800 (PST)
MIME-Version: 1.0
References: <1547523465-27807-1-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1547523465-27807-1-git-send-email-yong.zhi@intel.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 15 Jan 2019 14:33:56 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BwDixHRwr5LxFX4PLyaaU8R1u1mzds=tdtffjF9pS6_A@mail.gmail.com>
Message-ID: <CAAFQd5BwDixHRwr5LxFX4PLyaaU8R1u1mzds=tdtffjF9pS6_A@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: ipu3-imgu: Use MENU type for mode control
To:     Yong Zhi <yong.zhi@intel.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Cao Bing Bu <bingbu.cao@intel.com>, dan.carpenter@oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Yong,

On Tue, Jan 15, 2019 at 12:38 PM Yong Zhi <yong.zhi@intel.com> wrote:
>
> This addresses the below TODO item.
> - Use V4L2_CTRL_TYPE_MENU for dual-pipe mode control. (Sakari)
>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/staging/media/ipu3/TODO                 |  2 --
>  drivers/staging/media/ipu3/include/intel-ipu3.h |  6 ------
>  drivers/staging/media/ipu3/ipu3-v4l2.c          | 18 +++++++++++++-----
>  3 files changed, 13 insertions(+), 13 deletions(-)
>

Thanks for the patch. Please see my comments inline.

> diff --git a/drivers/staging/media/ipu3/TODO b/drivers/staging/media/ipu3/TODO
> index 905bbb190217..0dc9a2e79978 100644
> --- a/drivers/staging/media/ipu3/TODO
> +++ b/drivers/staging/media/ipu3/TODO
> @@ -11,8 +11,6 @@ staging directory.
>  - Prefix imgu for all public APIs, i.e. change ipu3_v4l2_register() to
>    imgu_v4l2_register(). (Sakari)
>
> -- Use V4L2_CTRL_TYPE_MENU for dual-pipe mode control. (Sakari)
> -
>  - IPU3 driver documentation (Laurent)
>    Add diagram in driver rst to describe output capability.
>    Comments on configuring v4l2 subdevs for CIO2 and ImgU.
> diff --git a/drivers/staging/media/ipu3/include/intel-ipu3.h b/drivers/staging/media/ipu3/include/intel-ipu3.h
> index ec0b74829351..eb6f52aca992 100644
> --- a/drivers/staging/media/ipu3/include/intel-ipu3.h
> +++ b/drivers/staging/media/ipu3/include/intel-ipu3.h
> @@ -16,12 +16,6 @@
>  #define V4L2_CID_INTEL_IPU3_BASE       (V4L2_CID_USER_BASE + 0x10c0)
>  #define V4L2_CID_INTEL_IPU3_MODE       (V4L2_CID_INTEL_IPU3_BASE + 1)
>
> -/* custom ctrl to set pipe mode */
> -enum ipu3_running_mode {
> -       IPU3_RUNNING_MODE_VIDEO = 0,
> -       IPU3_RUNNING_MODE_STILL = 1,
> -};
> -
>  /******************* ipu3_uapi_stats_3a *******************/
>
>  #define IPU3_UAPI_MAX_STRIPES                          2
> diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
> index c7936032beb9..d2a0b62d5688 100644
> --- a/drivers/staging/media/ipu3/ipu3-v4l2.c
> +++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
> @@ -12,6 +12,9 @@
>
>  /******************** v4l2_subdev_ops ********************/
>
> +#define        IPU3_RUNNING_MODE_VIDEO         0
> +#define        IPU3_RUNNING_MODE_STILL         1

Just a single space after "#define" please.

> +
>  static int ipu3_subdev_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>  {
>         struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
> @@ -1035,15 +1038,20 @@ static const struct v4l2_ctrl_ops ipu3_subdev_ctrl_ops = {
>         .s_ctrl = ipu3_sd_s_ctrl,
>  };
>
> +static const char * const ipu3_ctrl_mode_strings[] = {
> +       "Video mode",
> +       "Still mode",
> +       NULL,

Do you need this NULL entry? I don't see it in other drivers.

> +};
> +
>  static const struct v4l2_ctrl_config ipu3_subdev_ctrl_mode = {
>         .ops = &ipu3_subdev_ctrl_ops,
>         .id = V4L2_CID_INTEL_IPU3_MODE,
>         .name = "IPU3 Pipe Mode",
> -       .type = V4L2_CTRL_TYPE_INTEGER,
> -       .min = IPU3_RUNNING_MODE_VIDEO,
> -       .max = IPU3_RUNNING_MODE_STILL,
> -       .step = 1,
> -       .def = IPU3_RUNNING_MODE_VIDEO,
> +       .type = V4L2_CTRL_TYPE_MENU,
> +       .max = ARRAY_SIZE(ipu3_ctrl_mode_strings) - 2,
> +       .def = 0,

IPU3_RUNNING_MODE_VIDEO?

> +       .qmenu = ipu3_ctrl_mode_strings,
>  };
>
>  /******************** Framework registration ********************/
> --
> 2.7.4
>

Best regards,
Tomasz
