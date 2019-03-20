Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09715C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 03:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7BF720857
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 03:06:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="L2pIgyCC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfCTDGC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 23:06:02 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36284 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfCTDGB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 23:06:01 -0400
Received: by mail-ot1-f68.google.com with SMTP id o74so835830ota.3
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2019 20:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yMr1RUBK1VUjq0K0x9zOXPkgJoLdgDs5VbUJMJruWbo=;
        b=L2pIgyCChQcpLOr/swrUbZsmcACIcg4yzS8kckFZQYTxtm8Ghb3VBzU/pbAnRj0+hv
         9d6XymhlDQKXAWaCUzBpi+8FILodW5+sdiozjW+CSXkAoVulczBeKB8kgq0LN4s5iYEk
         ZNH4C/hddgQvW6XWIqqIPyw7TXGsfrue0n3RY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yMr1RUBK1VUjq0K0x9zOXPkgJoLdgDs5VbUJMJruWbo=;
        b=gum90YHdCwoHRf+TvkiP71K+e8FJZHaCmxdtPmUrzi9a3TTTZaH+ik37T8vL4HNLKc
         v0U44DuDyaeNzJH/+i6hpc1G9iXz16qyMxa8jV5Vy6OJZsqnu5ZMYSm7J8UcmlWLRo3n
         XIWvIlG5PJtvzelDqTBwFQIXj7HhXZJDsQEg5NmVthYUi/qNgRBjzq3k/wSI79pMJtx1
         AzBU+TuUUoWc0c2shCmJtIkagtNawHmHRpMst3OEEccLB1iZRav4xbyV4Q0DB7GQ/rz2
         fJyvM/M2KzFnv/2Qh2/DXxQ88+8Pm1WQIy/NzuGSwaODcsrGHS3Ijw1XslH53ITcfi6j
         tfng==
X-Gm-Message-State: APjAAAU1QCjXyGwf5br3/erlBbEiOzSzfFyrP14BeApafADLHq2kPjpO
        V1m2dVL+YzBB/9GkDszw8kIfGOhlW4oZ1A==
X-Google-Smtp-Source: APXvYqww6hDVBw4dIQTm2iDLB4qv8hOCMqCJ/gkDTtxWfaU+5Nnbxqao3KaFPA2QQP/e2mQvPgEMrw==
X-Received: by 2002:a9d:a67:: with SMTP id 94mr3873079otg.63.1553051161051;
        Tue, 19 Mar 2019 20:06:01 -0700 (PDT)
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com. [209.85.167.173])
        by smtp.gmail.com with ESMTPSA id 88sm390886otx.57.2019.03.19.20.06.00
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Mar 2019 20:06:00 -0700 (PDT)
Received: by mail-oi1-f173.google.com with SMTP id v84so662779oif.4
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2019 20:06:00 -0700 (PDT)
X-Received: by 2002:aca:b7c4:: with SMTP id h187mr3760677oif.112.1553050789996;
 Tue, 19 Mar 2019 19:59:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.3917a1471bfc8cbdfdde8026566b3857caff5762.1553009355.git-series.maxime.ripard@bootlin.com>
 <9d9fe5c2dc58f9398cb6b1e9bb208640d25ae816.1553009355.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <9d9fe5c2dc58f9398cb6b1e9bb208640d25ae816.1553009355.git-series.maxime.ripard@bootlin.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 20 Mar 2019 11:59:38 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BH25EEXN1KFsQigJo-K_KCfM0vmwVYJmj1-fkw+189Cg@mail.gmail.com>
Message-ID: <CAAFQd5BH25EEXN1KFsQigJo-K_KCfM0vmwVYJmj1-fkw+189Cg@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        jenskuske@gmail.com, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Maxime,

On Wed, Mar 20, 2019 at 12:29 AM Maxime Ripard
<maxime.ripard@bootlin.com> wrote:
>
> From: Pawel Osciak <posciak@chromium.org>
>
> Stateless video codecs will require both the H264 metadata and slices in
> order to be able to decode frames.
>
> This introduces the definitions for a new pixel format for H264 slices that
> have been parsed, as well as the structures used to pass the metadata from
> the userspace to the kernel.
>
> Co-Developped-by: Maxime Ripard <maxime.ripard@bootlin.com>
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> Signed-off-by: Guenter Roeck <groeck@chromium.org>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  Documentation/media/uapi/v4l/biblio.rst            |   9 +-
>  Documentation/media/uapi/v4l/ext-ctrls-codec.rst   | 569 ++++++++++++++-
>  Documentation/media/uapi/v4l/pixfmt-compressed.rst |  19 +-
>  Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  30 +-
>  Documentation/media/videodev2.h.rst.exceptions     |   5 +-
>  drivers/media/v4l2-core/v4l2-ctrls.c               |  42 +-
>  drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +-
>  include/media/h264-ctrls.h                         | 192 +++++-
>  include/media/v4l2-ctrls.h                         |  13 +-
>  include/uapi/linux/videodev2.h                     |   1 +-
>  10 files changed, 880 insertions(+), 1 deletion(-)
>  create mode 100644 include/media/h264-ctrls.h
>

Thanks for the patch and addressing my comments patiently!

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
