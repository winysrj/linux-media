Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1F3C04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 08:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ED972084E
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 08:57:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="OWal2l5X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2ED972084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbeLLI5P (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 03:57:15 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:42645 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbeLLI5P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 03:57:15 -0500
Received: by mail-yb1-f195.google.com with SMTP id m129so1201404ybf.9
        for <linux-media@vger.kernel.org>; Wed, 12 Dec 2018 00:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BVZgFNf9WHF+xHaCgaoxUE1kaeM8S4ksks7q9NZZRnE=;
        b=OWal2l5Xd3rmOLIt2j03zlUDCAKQGGigEZY4oWX6oNZq5Xdf9x7YDw6Ks2a644kTkh
         NSEm5yUsaasOjkQHrcNnTcnz7ofJQWX56rQP/aDRqkgNnsakiXxx3nNE+tGeIF5/Jz5e
         sEuAgJkNmR8UYr2Y2B4HOwOHy9CyjHSukkqhY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BVZgFNf9WHF+xHaCgaoxUE1kaeM8S4ksks7q9NZZRnE=;
        b=LAuaQ+/hqiL17D7Gjxv01PqnDynhwQt46Nxili7lHQkjz6yxV4uAsZ/uo9Z+DG5rnL
         vJm3etOB3xIhjxaEvQGoyytDv1iYaXCw2FhUgFuob5onQhpNKHGjfUjtoH2o/zMNY+ux
         5mRRxANUDAxr3QdQRS5SyzaLYguKEMwwLhCsGfOA+kjSGcSjU4fmbdr5oYrri06sxrrh
         ZL/g0Ds6i0B2t+DyCcTayhkDP3pJIrI25QVc7/2E2nZqQj2J72OspM64otQS0+6JOlgE
         /H0Aw2jzz3lP4Xd1p5jJ6AB/BY7BwLh7Qgy4YX9sQFCFVrWiNLgIwQkm3r/RB/VhS00A
         Tu0A==
X-Gm-Message-State: AA+aEWYDklvKkNHLkAHZp3uYbAPa63oJrQiZbYyEnhOaZpzZMn/x8evb
        S7EB4/H9GXjSTigHH32s5rveKSCyZHwPhQ==
X-Google-Smtp-Source: AFSGD/VWp4xQs8caEUpuANcph7a11bHy+3E6fw4FLJMZRnVEJAy7UobKHgMzTi4P0L0gS2ImNueJKg==
X-Received: by 2002:a5b:50f:: with SMTP id o15-v6mr18900301ybp.297.1544605034723;
        Wed, 12 Dec 2018 00:57:14 -0800 (PST)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id f188sm6061924ywc.70.2018.12.12.00.57.14
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Dec 2018 00:57:14 -0800 (PST)
Received: by mail-yb1-f170.google.com with SMTP id f4so7354578ybq.4
        for <linux-media@vger.kernel.org>; Wed, 12 Dec 2018 00:57:14 -0800 (PST)
X-Received: by 2002:a25:d644:: with SMTP id n65mr3201928ybg.204.1544605034002;
 Wed, 12 Dec 2018 00:57:14 -0800 (PST)
MIME-Version: 1.0
References: <20180821170629.18408-1-matwey@sai.msu.ru> <20180821170629.18408-3-matwey@sai.msu.ru>
 <2213616.rQm4DhIJ7U@avalon> <20181207152502.GA30455@infradead.org>
In-Reply-To: <20181207152502.GA30455@infradead.org>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 12 Dec 2018 17:57:02 +0900
X-Gmail-Original-Message-ID: <CAAFQd5C6gUvg8p0+Gtk22Z-dmeMPytdF4HujL9evYAew15bUmA@mail.gmail.com>
Message-ID: <CAAFQd5C6gUvg8p0+Gtk22Z-dmeMPytdF4HujL9evYAew15bUmA@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Matwey V. Kornilov" <matwey.kornilov@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>, hdegoede@redhat.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        rostedt@goodmis.org, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        keiichiw@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Christoph,

On Sat, Dec 8, 2018 at 12:25 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> Folks, can you take a look at this tree and see if this is useful
> for USB:
>
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dma-noncoherent-allocator
>
> The idea is that you use dma_alloc_attrs with the DMA_ATTR_NON_CONSISTENT
> now that I've made sure it is avaiable everywhere [1], and we can use
> dma_sync_single_* on it.

How about dma_sync_sg_*()? I'd expect some drivers to export/import
such memory via sg, since that's the typical way of describing memory
in DMA-buf.

>
> The only special case USB will need are the HCD_LOCAL_MEM devices, for
> which we must use dma_alloc_coherent (or dma_alloc_attrs without
> DMA_ATTR_NON_CONSISTENT) and must skip the dma_sync_single_* calls,
> so we'll probably need USB subsystem wrappers for those calls.
>
> [1] except powerpc in this tree - I have another series to make powerpc
> use the generic dma noncoherent code, which would cover it.

Sounds good to me. Thanks for working on this. I'd be happy to be on
CC and help with review when you post the patches later.

Best regards,
Tomasz
