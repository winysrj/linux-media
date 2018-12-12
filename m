Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAC5C04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 09:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C155A20839
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 09:34:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="YTbPpDFl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C155A20839
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbeLLJem (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 04:34:42 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:38894 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbeLLJel (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 04:34:41 -0500
Received: by mail-yw1-f65.google.com with SMTP id i20so6687119ywc.5
        for <linux-media@vger.kernel.org>; Wed, 12 Dec 2018 01:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AbgKSGoQLXbqknnhWCy8p4/YHmSVhPq4mWk8V9y6LOs=;
        b=YTbPpDFlWLkgSEAI9LmQALNcCACDIfD7IR3dHDDJvMUJQO6lw4Sm91V7Vw3z+VY8QW
         L+Yc2P+zIeRiU/iIDfehcfLIPF96DUDpcFNUm9vsvJK+sb/q2WCTaKTMRb5IskFDkYen
         U7DjnsZq1SIFsgL/EnCQ5gpQYxp7wA5lvxTGU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AbgKSGoQLXbqknnhWCy8p4/YHmSVhPq4mWk8V9y6LOs=;
        b=oGyJ0zqMgu6RjNhwtdKXHeF2LpNA6N2ZWk09Yd+QpvGSB+uiaXEvpLunUXma7hd4fw
         y+KOvbWg/GVDv7G8IUCDZQ3YkyjfPUK/3SSdBN3XFDnUutqH5tosJ2UFp/6+5uNaoW8P
         +gb4iL260KBOGykWjYh8ZWojhDzRMBU70dRMuNOHXzJkhNHx0yWLV9RBDyPkj5Y07179
         SqrHMxGdwXPEHr8P0QwT043T+YUfogAzN3bRkTGzyDd9fK5d0YQsz8+UzU1h5UHctQ42
         b4GW3hMKSzB1UPHAv5snv+MTpzdd9mMhU3K9wVqbchHDC+ObCcTohEHy+xh91dyuhn0E
         Gh1Q==
X-Gm-Message-State: AA+aEWYTKUeJh7sXmRyaOKgVRHBJOe/MjbD2y/Pe8CZLS8Ffffem4lUs
        Cns6MpM+CBXSolpNTj3FGICigbCJct1vlQ==
X-Google-Smtp-Source: AFSGD/XXao9BKRXdbQjUWXozMo/kKU0j5C263r6zZp8TIqefkoEnG+8w6cf5W+36LulYqbvV8OVI9g==
X-Received: by 2002:a0d:e684:: with SMTP id p126mr19332312ywe.315.1544607279468;
        Wed, 12 Dec 2018 01:34:39 -0800 (PST)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id i2sm7138024ywc.59.2018.12.12.01.34.37
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Dec 2018 01:34:38 -0800 (PST)
Received: by mail-yb1-f174.google.com with SMTP id f9so4411485ybm.13
        for <linux-media@vger.kernel.org>; Wed, 12 Dec 2018 01:34:37 -0800 (PST)
X-Received: by 2002:a25:84c6:: with SMTP id x6mr14232621ybm.293.1544607276754;
 Wed, 12 Dec 2018 01:34:36 -0800 (PST)
MIME-Version: 1.0
References: <20180821170629.18408-1-matwey@sai.msu.ru> <20180821170629.18408-3-matwey@sai.msu.ru>
 <2213616.rQm4DhIJ7U@avalon> <20181207152502.GA30455@infradead.org>
 <CAAFQd5C6gUvg8p0+Gtk22Z-dmeMPytdF4HujL9evYAew15bUmA@mail.gmail.com> <20181212090917.GA30598@infradead.org>
In-Reply-To: <20181212090917.GA30598@infradead.org>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 12 Dec 2018 18:34:25 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DhDOfk_2Dhq4MfJmoxpXP=Bm36HMZ55PSXxwkTAoCXSQ@mail.gmail.com>
Message-ID: <CAAFQd5DhDOfk_2Dhq4MfJmoxpXP=Bm36HMZ55PSXxwkTAoCXSQ@mail.gmail.com>
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

On Wed, Dec 12, 2018 at 6:09 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Dec 12, 2018 at 05:57:02PM +0900, Tomasz Figa wrote:
> > How about dma_sync_sg_*()? I'd expect some drivers to export/import
> > such memory via sg, since that's the typical way of describing memory
> > in DMA-buf.
>
> The way it is implemented dma_sync_sg_* would just work, however there
> really should be no need to have sglists for buffers created by this
> API.

The typical DMA-buf import/export flow is as follows:
1) Driver X allocates buffer A using this API for device x and gets a
DMA address inside x's DMA (or IOVA) address space.
2) Driver X creates a dma_buf D(A), backed by buffer A and gives the
user space process a file descriptor FD(A) referring to it.
3) Driver Y gets FD(A) from the user space and needs to map it into
the DMA/IOVA address space of device y. It doe it by calling
dma_buf_map_attachment() which returns an sg_table describing the
mapping.

And then I realized that actually there is no need for the importer
(driver Y) to call dma_sync_*() on its own, since the exporter (driver
X) is expected to map and sync in its .map_dma_buf() dma_buf_ops
callback. But there is still a need to have an sg_table created for
the buffer, because it's what dma_buf_map_attachment() returns.

>
> > Sounds good to me. Thanks for working on this. I'd be happy to be on
> > CC and help with review when you post the patches later.
>
> The patches were already posted here:
>
> https://lists.linuxfoundation.org/pipermail/iommu/2018-December/031982.html

Okay, thanks. I can see it in my inbox.

Best regards,
Tomasz
