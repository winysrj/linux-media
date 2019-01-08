Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8780C43612
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 10:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79CE12087F
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 10:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbfAHKE0 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 05:04:26 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:41349 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727367AbfAHKEZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 05:04:25 -0500
Received: by mail-vs1-f68.google.com with SMTP id t17so2095026vsc.8;
        Tue, 08 Jan 2019 02:04:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sNqiYlChw24KsWcz/kYr7xgCv0KKzbtApcgrPB8ujhw=;
        b=W0B4Z4Hy652fpRINO45lrRb1U+BnIcDx5I3klUubqI2v8wZeU7VwbvSmcPTDJC9cHR
         fbjmhhsVcT/xPyJu9kHQOQzcelTfKMUYQ71LFOjcg3E5Y696LBL5wU3fCns4N9kjnO9h
         l13M853A5mHT08BrcUBqSioNqUaanU7FHs1qUwTrTkApc2ehpeMOuLUJ4vrQWLZH9Lc8
         o20ONsK6MAVmgqIeOM+QSV+PRMDp9vlkBUod5YwmiZ6MG/W4gVTwqH5G3g9Y9bPIohv6
         fBHx8fQP9SsMrX09wfW90b1a6b8cIVb+xI400bDMhclqFLpiR4CAM7Nj/U+CAoMUwHGk
         fTNQ==
X-Gm-Message-State: AJcUukdkqnMrauQCmy2zh2MBt6wXRxEmrGA433AjI3HGp45c1hjXwjcJ
        4AOK8qGPk7jboN/W+cuFo1tjh1aqT1ccTVSwois=
X-Google-Smtp-Source: ALg8bN7PdaK7rp2QKF0c6T+DesjQL4YJWSjCn4xUsqXr/VPQMMQnqACOt/MDS3vq0p9IEyQm/jQIIIT5jPR70jjAynw=
X-Received: by 2002:a67:b60d:: with SMTP id d13mr466077vsm.152.1546941864577;
 Tue, 08 Jan 2019 02:04:24 -0800 (PST)
MIME-Version: 1.0
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se> <20181101233144.31507-18-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-18-niklas.soderlund+renesas@ragnatech.se>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 8 Jan 2019 11:04:13 +0100
Message-ID: <CAMuHMdVKzdGrh2dyafQb3ny2i=z9GqeTbn+8p+NN3nofCrc7ZQ@mail.gmail.com>
Subject: Re: [PATCH v2 17/30] v4l: subdev: compat: Implement handling for VIDIOC_SUBDEV_[GS]_ROUTING
To:     =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benoit Parrot <bparrot@ti.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas, Sakari,

On Fri, Nov 2, 2018 at 12:33 AM Niklas Söderlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
>
> Implement compat IOCTL handling for VIDIOC_SUBDEV_G_ROUTING and
> VIDIOC_SUBDEV_S_ROUTING IOCTLs.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -1045,6 +1045,66 @@ static int put_v4l2_event32(struct v4l2_event __user *p64,
>         return 0;
>  }
>
> +struct v4l2_subdev_routing32 {
> +       compat_caddr_t routes;
> +       __u32 num_routes;
> +       __u32 reserved[5];
> +};
> +
> +static int get_v4l2_subdev_routing(struct v4l2_subdev_routing __user *p64,
> +                                  struct v4l2_subdev_routing32 __user *p32)
> +{
> +       struct v4l2_subdev_route __user *routes;
> +       compat_caddr_t p;
> +       u32 num_routes;
> +
> +       if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||

Please drop the first parameter of all newly-added access_ok() calls, as
it has been removed in commit 96d4f267e40f9509 ("Remove 'type' argument
from access_ok() function").

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
