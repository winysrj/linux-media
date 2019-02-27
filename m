Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A945BC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 21:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 699CD21850
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 21:07:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="l8PXE5Gs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbfB0VHv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 16:07:51 -0500
Received: from mail-qt1-f176.google.com ([209.85.160.176]:39355 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727488AbfB0VHv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 16:07:51 -0500
Received: by mail-qt1-f176.google.com with SMTP id o6so20996096qtk.6
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2019 13:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=v1OHE8O4FmvPNgPv9s8FML1t7j8wMn1y8l/+Q/ESlgs=;
        b=l8PXE5GsP/5ERVKj/juW/F7+M7vnJGSx5b4UvijLlUIJbkSigJQFi5x4Uf6HOoRgrS
         SOdXx2x3guJ/OcUvZ/7ZSXVxTBMxm39oTuHRZSjWZS/I91WG/E0g/h2nXCxhDlktq+ES
         CqS63i0QEUmMt33381WgExgcXRrDGZzH44uZOALroaBOLqHr9wrt2gPE2Md4gWcOzyT/
         XCaqS1R5Kc5u3/mHEm23nIxkDZaDOiul4PsOZbMbR1ckmKFJSDOcC1UJvUJDqSQCLTA7
         mMLt29yh+I1R+95abssERyuaSZQdg1oWrqGhcusoPDtByqI79bQJfQXyP8EzD3UjinVQ
         bFaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=v1OHE8O4FmvPNgPv9s8FML1t7j8wMn1y8l/+Q/ESlgs=;
        b=Ax1UpzhbQiGrTyJiuZvCfxN0aY/CuEv3MYeemxlLQq3znHY3NOXHun10o1xlqSsVdf
         E2CYHq5VChDRZdOB/KRToOmyQ3Cy5aRxQuKy6hDGCPdnJkXWu27fSF/2N7EHfcROWBmb
         k5Y4X7IRWH/mPLQBTvaYR90Jqx7bNo+D6yyj8D8KwgYQ7AElfrcAoleGRDkUGvcuvVrL
         eLHGUYPprB750kgDzBviP2ghgy8y0K1uIwwRORl0+XEn3Q70jt3AC5KYXk746T37YA9z
         QhsCxe05DtOcw8JDMiAuDsxHRsnm8ziwa8MgToCe4qFO/IOWSTxlmEntccv5VQaZjLRn
         wXeg==
X-Gm-Message-State: APjAAAUnAqtGNa41aUmflJht+froeClPtVJqhYX9XSLn1wxpWb0N8kwG
        suAkP3VpNNjrOddY5P702kC37A==
X-Google-Smtp-Source: APXvYqy4RoRNRF2aAQw1DiQiyf/E/XIUCJYsMDLpXO5DHUlQwAowmucUHhyHPCKHv81ZrEWCI05n9w==
X-Received: by 2002:a0c:95dd:: with SMTP id t29mr3656663qvt.174.1551301670237;
        Wed, 27 Feb 2019 13:07:50 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id m14sm8969017qkk.45.2019.02.27.13.07.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Feb 2019 13:07:49 -0800 (PST)
Message-ID: <647793c24801de4fd464bac3414cff091c30facf.camel@ndufresne.ca>
Subject: Re: media: rockchip: the memory layout of multiplanes buffer for
 DMA address
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Ayaka <ayaka@soulik.info>, linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, myy@miouyouyou.fr, ezequiel@collabora.com,
        tfiga@chromium.org
Date:   Wed, 27 Feb 2019 16:07:48 -0500
In-Reply-To: <C5689C9D-5F00-41E2-B24F-5BC8D9BA88AF@soulik.info>
References: <C5689C9D-5F00-41E2-B24F-5BC8D9BA88AF@soulik.info>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Ayaka,

Le mercredi 27 février 2019 à 23:13 +0800, Ayaka a écrit :
> Last time in FOSDEM, kwiboo and I talk some problems of the request
> API and stateless decoder, I say the a method to describe a buffer
> with many offsets as the buffer meta data would solve the most of 
> problems we talked, but I have no idea on how to implement it. And I
> think a buffer meta describing a buffer with many offsets would solve
> this problem as well.

for single allocation case, the only supported in-between plane padding
is an evenly distributed padding. This padding is communicated to
userspace through S_FMT, by extending the width and height. Userspace
then reads the display width/height through G_SELECTION API.

For anything else, the MPLANE structure with one of the multi-plane
format can "express" such buffer, though from userspace they are
exposed as two memory pointer or DMABuf FDs (which make importation
complicated if the buffer should initially be within a single
allocation). I'll leave to kernel dev the task to explain what is
feasible there (e.g. sub-buffering, etc.)

Nicolas

