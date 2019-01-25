Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E931EC282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 04:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B351A218A6
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 04:25:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JkCjmZbK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfAYEZk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 23:25:40 -0500
Received: from mail-ot1-f44.google.com ([209.85.210.44]:41376 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfAYEZk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 23:25:40 -0500
Received: by mail-ot1-f44.google.com with SMTP id u16so7389969otk.8
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 20:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fsCTTiXzyQ6xv2gh2J5X8YzU5/zodoooceinHbXB2Ys=;
        b=JkCjmZbKm5lGFyNIb5P7vKztBv9Ldj7AVbQuN/OhBML7gp6XOYvJGgp49i78kNzJtL
         ws31CNk4kSGmZToAeb/RC+UCFYH/jjVARj0ZVt/ELuNqHB/AT6HG3cSJCQ3BpS2xOg3m
         LQ70rNjSUR8bZKRg53GWPtqk+YXVB18WED40o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fsCTTiXzyQ6xv2gh2J5X8YzU5/zodoooceinHbXB2Ys=;
        b=Kcf8kNPPuHKbqvjHgCT2RuCY/mi0ARljkjr46UWyT55s8G0pmTGsg0fcGPjEkY6fE6
         W52lb+RJWr8fS2zh7fxkjWqQUSW6bQVm00lIvRw65uxhey9nw+wOMbY73jFqG/Yb8DYA
         xLwW+z+FnfkCpuzELS4I/1xzvki1ZsnxZlV4OS5bq+HIg7f5HX9NAHkTRRccz8Pzj5qV
         w1r0Qrx27o7J4OrP6qkw4dXLd04eDxH0GOdtkST2pBG/na7pFpyGA12BosbtCIqPNDjH
         SgFOmu+/cO7CM0xRD2sxs/4DyzThLbsauo8F4vlmF6YqiF2HST19Rue6nZFzX2WBUavI
         jwrw==
X-Gm-Message-State: AJcUukeb785P3QbkR1Y7VBUKHMNsX5a85IFyQAW2rMZ3wPQxnq+K0Wot
        SjbfeSKRiiSK12hwr+wpOXxRgs/xQUfmaw==
X-Google-Smtp-Source: ALg8bN4EYG2lTUC75Khl8WNlEgM5Q3My865IuEHRSMgFI3Z5hM2q5rtX534qsa8BPGDP9h9i+z4aJA==
X-Received: by 2002:a05:6830:134d:: with SMTP id r13mr6659794otq.337.1548390338654;
        Thu, 24 Jan 2019 20:25:38 -0800 (PST)
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com. [209.85.167.171])
        by smtp.gmail.com with ESMTPSA id m89sm808348otc.35.2019.01.24.20.25.37
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 20:25:38 -0800 (PST)
Received: by mail-oi1-f171.google.com with SMTP id j21so6770738oii.8
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 20:25:37 -0800 (PST)
X-Received: by 2002:aca:b882:: with SMTP id i124mr329793oif.127.1548390337349;
 Thu, 24 Jan 2019 20:25:37 -0800 (PST)
MIME-Version: 1.0
References: <20181119110903.24383-1-hverkuil@xs4all.nl> <20181119110903.24383-3-hverkuil@xs4all.nl>
 <cdf8bbd9-2f97-bd5e-1819-547b4f75338c@xs4all.nl>
In-Reply-To: <cdf8bbd9-2f97-bd5e-1819-547b4f75338c@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Fri, 25 Jan 2019 13:25:26 +0900
X-Gmail-Original-Message-ID: <CAAFQd5D8v8SVXOQf9R4wkAVOqu0eH=H_YdqM2d_xF1CrNhm8NQ@mail.gmail.com>
Message-ID: <CAAFQd5D8v8SVXOQf9R4wkAVOqu0eH=H_YdqM2d_xF1CrNhm8NQ@mail.gmail.com>
Subject: Re: [PATCHv2.1 2/4] vivid: use per-queue mutexes instead of one
 global mutex.
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Nov 19, 2018 at 9:22 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> From d15ccd98e557a8cef1362cb591eb3011a6d8e1fd Mon Sep 17 00:00:00 2001
> From: Hans Verkuil <hverkuil@xs4all.nl>
> Date: Fri, 16 Nov 2018 12:14:31 +0100
> Subject: [PATCH 2/4] vivid: use per-queue mutexes instead of one global mutex.
>
> This avoids having to unlock the queue lock in stop_streaming.
>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> Reported-by: syzbot+736c3aae4af7b50d9683@syzkaller.appspotmail.com
> ---
> Changes since v2:
> - add mutex_destroy()
> ---
>  drivers/media/platform/vivid/vivid-core.c     | 26 +++++++++++++++----
>  drivers/media/platform/vivid/vivid-core.h     |  5 ++++
>  .../media/platform/vivid/vivid-kthread-cap.c  |  2 --
>  .../media/platform/vivid/vivid-kthread-out.c  |  2 --
>  drivers/media/platform/vivid/vivid-sdr-cap.c  |  2 --
>  5 files changed, 26 insertions(+), 11 deletions(-)
>

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
