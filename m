Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,URIBL_RHS_DOB autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B534EC64EB1
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 16:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C28F20700
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 16:19:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="Nvhy+Bs/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C28F20700
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amarulasolutions.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbeLFQTA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 11:19:00 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:33011 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbeLFQTA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 11:19:00 -0500
Received: by mail-it1-f195.google.com with SMTP id m8so17322196itk.0
        for <linux-media@vger.kernel.org>; Thu, 06 Dec 2018 08:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wY2nbYb1ObeOZQ1jcit/vTLPC0zN9nySBsSkzYQXin4=;
        b=Nvhy+Bs/Jx4ZShpByO8Vi6tBMbYoUUjoezJBza4yHR27gq00qvSDqvNxjLutnAXgQa
         fcAfBe6/WpAyMc8h0AgADY2iY5oqWTEBY9P9IbsqS2hO2z94vvwFv06nJZICyNPVepC8
         /nfS6OfdY6R3NUnTtHJAdpEzmRsSjyMomps5U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wY2nbYb1ObeOZQ1jcit/vTLPC0zN9nySBsSkzYQXin4=;
        b=EzPEQxdT10odTUADCDkOkNKhSyUQ3M4cdDtkSxw3VQa/G0yXch1vS5Eh+mfENtP/BQ
         HEEUzNNp2Ojd5e5ikaBmSsNnHWl8390hh8uG9Tczknau8TQ3+YBw8mWoZmrn0Z87QDLd
         YvBbqnAlrY10lSkB2XZqKX1raDn823CJLrfP0g1apxbSwDNtot1JyhlvHXnuV+aQen28
         x7GdAoAiAU0HDLw9chkT2DQYYRgOmxFSdciN/1fMkOGcYvq/szHQ+MwxKVwWVE7AMQpv
         4vWj/CYRVH/OEx438TLkDcSUQ5C+c5gVTToNFt+aEsbvDInuypPPJG77P0kckFw94oX8
         qtpA==
X-Gm-Message-State: AA+aEWbgZwdr/wfN/Hqe2RbmdkkrNH4qUq+C3D7evzO6m+GQRUDSH27W
        IB+we24/0JWOhAQVEn08gTk740Hmu1gviNLkJdAbuw==
X-Google-Smtp-Source: AFSGD/XPaJzDsf3JhuwPG6APlGl+v8JlSCn3y+HAEECMfLbxUxWEdONegxHAktmYfmJ4Nsz43G6deU57PBVArJSm+P0=
X-Received: by 2002:a24:10cb:: with SMTP id 194mr20067795ity.173.1544113139466;
 Thu, 06 Dec 2018 08:18:59 -0800 (PST)
MIME-Version: 1.0
References: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Thu, 6 Dec 2018 21:48:45 +0530
Message-ID: <CAMty3ZAK2VU7UpdYJ4_93QOa3Q=8dMZVT4mHMZGvDfUZTW=J2w@mail.gmail.com>
Subject: Re: [PATCH v6 00/12] media: ov5640: Misc cleanup and improvements
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        laurent.pinchart@ideasonboard.com,
        linux-media <linux-media@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        hugues.fruchet@st.com, loic.poulain@linaro.org,
        sam@elite-embedded.com, steve Longerbeam <slongerbeam@gmail.com>,
        daniel@zonque.org, jacopo mondi <jacopo@jmondi.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Dec 3, 2018 at 2:14 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> Hi,
>
> Here is a "small" series that mostly cleans up the ov5640 driver code,
> slowly getting rid of the big data array for more understandable code
> (hopefully).
>
> The biggest addition would be the clock rate computation at runtime,
> instead of relying on those arrays to setup the clock tree
> properly. As a side effect, it fixes the framerate that was off by
> around 10% on the smaller resolutions, and we now support 60fps.
>
> This also introduces a bunch of new features.
>
> Let me know what you think,
> Maxime
>
> Changes from v5:
>   - Squashed Jacopo patches fixing MIPI-CSI
>
> Changes from v4:
>   - Squashed Jacopo patches fixing the MIPI-CSI case
>   - Prefer clock rates superior to the ideal clock rate, even if it
>     means having a less precise one.
>   - Fix the JPEG case according to Hugues suggestions
>   - Rebased on 4.20
>
> Changes from v3:
>   - Rebased on current Sakari tree
>   - Fixed an error when changing only the framerate
>
> Changes from v2:
>   - Rebased on latest Sakari PR
>   - Fixed the issues reported by Hugues: improper FPS returned for
>     formats, improper rounding of the FPS, some with his suggestions,
>     some by simplifying the logic.
>   - Expanded the clock tree comments based on the feedback from Samuel
>     Bobrowicz and Loic Poulain
>   - Merged some of the changes made by Samuel Bobrowicz to fix the
>     MIPI rate computation, fix the call sites of the
>     ov5640_set_timings function, the auto-exposure calculation call,
>     etc.
>   - Split the patches into smaller ones in order to make it more
>     readable (hopefully)
>
> Changes from v1:
>   - Integrated Hugues' suggestions to fix v4l2-compliance
>   - Fixed the bus width with JPEG
>   - Dropped the clock rate calculation loops for something simpler as
>     suggested by Sakari
>   - Cache the exposure value instead of using the control value
>   - Rebased on top of 4.17
>
> Jacopo Mondi (1):
>   media: ov5640: Fix set format regression
>
> Maxime Ripard (11):
>   media: ov5640: Adjust the clock based on the expected rate
>   media: ov5640: Remove the clocks registers initialization
>   media: ov5640: Remove redundant defines
>   media: ov5640: Remove redundant register setup
>   media: ov5640: Compute the clock rate at runtime
>   media: ov5640: Remove pixel clock rates
>   media: ov5640: Enhance FPS handling
>   media: ov5640: Make the return rate type more explicit
>   media: ov5640: Make the FPS clamping / rounding more extendable
>   media: ov5640: Add 60 fps support
>   media: ov5640: Remove duplicate auto-exposure setup

Tested 320x240@30, 640x480@30, 640x480@60, 1280x720@30 with UYVY8_2X8
and YUYV8_2X8 formats.

Tested-by: Jagan Teki <jagan@amarulasolutions.com> # a64-amarula-relic
