Return-Path: <SRS0=NtRf=QX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E408CC43381
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 00:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEAAD2192D
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 00:16:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="dLo2C2E5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730491AbfBPAQU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 19:16:20 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:39856 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbfBPAQT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 19:16:19 -0500
Received: by mail-wm1-f49.google.com with SMTP id z84so4236292wmg.4
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2019 16:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=syWESrLVrIjncQNjDpzmQt1b/pSjvUbOFpwzA7nZRdU=;
        b=dLo2C2E5iEO9wd592K8FVgIAUern3vzak2lG4zVBpvFTJsctP0mfRrXcGDe5yxM5i+
         1pi4enN01xxRI+zqcPJzn34UJ/ImRZ8lv50BmaFZTdlx3vYgUst/9/7GH3Y0y/bUCKXe
         F55W/NQBOyMYBQqQBoRcZtGZAz3rJEdCK5pac86xYJF5u0GGnalNQibhF4FjTvBOlpGk
         Hmrr/Ld9jCbnqeTcOH1Lv28BUAnn5nW+ZhWGp+SlGvLCE0WMLwvKWlCl5uoSQwdlbZq+
         5zTTIyIhRJBGqk5hjSd4R7UZ6LXub7yYgip+g6NUY5PtJhLJ2kqEd73vGOLyYoDx0MqQ
         BO/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=syWESrLVrIjncQNjDpzmQt1b/pSjvUbOFpwzA7nZRdU=;
        b=VHlChhilQbOKClINIdp/SIzRA1z7Xkba1mDaZe8EsKBT9jfJqRkWWX4nO/ModO3dB+
         gkTkBxw3MF/bUGEJJW0Zw1CkY8/WAcUfx9f6cHxkk7z5H9iZsePJXr6mLIf9ZtmHep32
         8Z2lrvGPbLPWb7IfnAddElaxfWTSngpW4gvgL5DRriYKTg5sOkBhsE6LYqb3BWyUwh5x
         cfq6szpDw872oQaOx323v8K1xbG5kX6nMStR4dBdVAGyP5DcnQT5PeB9kHRVYYs3hWW9
         8u9AWWUCVyRkzH1J2TU2R+P6NYUPAkji9Aza6SF2TjmGVZQynUQczUrB1iA/3j3OQe38
         p9ow==
X-Gm-Message-State: AHQUAuY6UnDDBTIyPkABHPFE3UuvNHquz8E+jgy4Si7c2Z++qAcYm9s2
        0hP/K41TC4+Z6dRO7zSR3PZyqGll7RaV0XK9H5fBv27njNg=
X-Google-Smtp-Source: AHgI3IboFJRQBUIuyD1oU1nczs1gNEUq3mmK5WP0Ix00X/iBaQewL+RaV6p23Xa5iCB8yeBvSjWpZoI8JAdNxD0piEk=
X-Received: by 2002:a1c:7510:: with SMTP id o16mr8138635wmc.38.1550276177181;
 Fri, 15 Feb 2019 16:16:17 -0800 (PST)
MIME-Version: 1.0
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 15 Feb 2019 16:16:06 -0800
Message-ID: <CAJ+vNU2aA-RrQbHrVa7eV4nZjUsbA9z42Dm0iVeOuWbgO=PtfQ@mail.gmail.com>
Subject: v4l2 mem2mem compose support?
To:     linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Carlos Rafael Giani <dv@pseudoterminal.org>,
        Discussion of the development of and with GStreamer 
        <gstreamer-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Greetings,

What is needed to be able to take advantage of hardware video
composing capabilities and make them available in something like
GStreamer?

Philipp's mem2mem driver [1] exposes the IMX IC and GStreamer's
v4l2convert element uses this nicely for hardware accelerated
scaling/csc/flip/rotate but what I'm looking for is something that
extends that concept and allows for composing frames from multiple
video capture devices into a single memory buffer which could then be
encoded as a single stream.

This was made possible by Carlo's gstreamer-imx [2] GStreamer plugins
paired with the Freescale kernel that had some non-mainlined API's to
the IMX IPU and GPU. We have used this to take for example 8x analog
capture inputs, compose them into a single frame then H264 encode and
stream it. The gstreamer-imx elements used fairly compatible
properties as the GstCompositorPad element to provide a destination
rect within the compose output buffer as well as rotation/flip, alpha
blending and the ability to specify background fill.

Is it possible that some of this capability might be available today
with the opengl GStreamer elements?

Best Regards,

Tim

[1] https://patchwork.kernel.org/patch/10768463/
[2] https://github.com/Freescale/gstreamer-imx
