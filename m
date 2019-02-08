Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CCCC282CC
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 04:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 307D72084D
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 04:32:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G7VfV9lp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfBHEcI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 23:32:08 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39990 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbfBHEcI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 23:32:08 -0500
Received: by mail-lf1-f66.google.com with SMTP id t14so1575156lfk.7;
        Thu, 07 Feb 2019 20:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CIitgqpj1Jx3VxIPRhUTrC/lUkFX1AVJEifvXimRfb8=;
        b=G7VfV9lpiXWHYppcFqdErDeJIKYBxNarTdPae0yZNMZnEhowySqTN+Lmh/Q6Ojdsw7
         HOBs7mwjeLZOrSe/io1L3KsmZ5+J/AK+KLqZSC8puFmcAL3ntbsf5fDSk676hx8gJUTf
         T/JhXfrZbKFWaC+ijns4YASYMSBEtD2F6iKOejtSrscfLom2YMybXACwtCwsNdLJB4F6
         L+Ct1Wv7fF9e4lI4qJnFP1rz6R95Jpmq5Zfv9n2/H7/KWg3gD1nCFvzZ4drpJhm+bVqn
         e89k8hlMWusy2sKD88tW6vYiMewZT7j4wxpndPWk19ouUVhss2d3MxPkgavlWBJhk672
         dY6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CIitgqpj1Jx3VxIPRhUTrC/lUkFX1AVJEifvXimRfb8=;
        b=GHdYzht3IccW/jvnL7lcD0HajYvziBRKYkMbytRvwgAcF+TXvDHQyg5JUupyt0ak60
         9aecs9VDWzCZmd6I9avhl1xTYXCEmi1N854punNauRkIWgqXqL78Q5K85Lq5uwHB+Hu3
         466K4Ze6Uo5uPoL8YiIL4EO6LIAmaT8tcgZW+YIgVjBiagS58U/+ENehpPAlWIQeNXua
         YUsXKVX2TVy3d/cdiWTsa3JJV+SnHE36JGIfwvn6e25tcD+1N7jRJ+KTRZ8y8E1HSk7H
         BwEn81wQIXMn0niTBV//NEMCglsWykDV1tdP4IvD9kdGXpC1Ssx+PQgfW/0nCoVTn2QC
         DL9g==
X-Gm-Message-State: AHQUAuaghUJ7QwcL3eTaGd2FIVdxXJ2nSAh4o+zgPPDCASYQPuGKexTo
        Sl9IcdsmkRGhJLYqAKxzpyseCV5JkiZLNqIhlFo=
X-Google-Smtp-Source: AHgI3IYGxJECPQh9dULY/HA6hfWXKCbI8Q8hMLYUq7bibGnt1mvlIY0gCaEtmRMMI67Zkg+3LgM3JDoeOA+VyHGzEUU=
X-Received: by 2002:ac2:43c6:: with SMTP id u6mr12062290lfl.151.1549600326193;
 Thu, 07 Feb 2019 20:32:06 -0800 (PST)
MIME-Version: 1.0
References: <20190207222647.GA30974@ziepe.ca>
In-Reply-To: <20190207222647.GA30974@ziepe.ca>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri, 8 Feb 2019 05:31:55 +0100
Message-ID: <CANiq72=qfNHf5zd8c8VkmrhE8U5_kH6yg3z4JD1N5yEfL727tA@mail.gmail.com>
Subject: Re: [PATCH v2] lib/scatterlist: Provide a DMA page iterator
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Daniel Stone <daniel@fooishbar.org>, "hch@lst.de" <hch@lst.de>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yong.zhi@intel.com" <yong.zhi@intel.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "bingbu.cao@intel.com" <bingbu.cao@intel.com>,
        "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Feb 7, 2019 at 11:28 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> Commit 2db76d7c3c6d ("lib/scatterlist: sg_page_iter: support sg lists w/o
> backing pages") introduced the sg_page_iter_dma_address() function without
> providing a way to use it in the general case. If the sg_dma_len() is not
> equal to the sg length callers cannot safely use the
> for_each_sg_page/sg_page_iter_dma_address combination.
>
> Resolve this API mistake by providing a DMA specific iterator,
> for_each_sg_dma_page(), that uses the right length so
> sg_page_iter_dma_address() works as expected with all sglists.
>
> A new iterator type is introduced to provide compile-time safety against
> wrongly mixing accessors and iterators.
>
> Acked-by: Christoph Hellwig <hch@lst.de> (for scatterlist)
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> ---
>  .clang-format                              |  1 +

Thanks for updating the .clang-format, Jason! :-)

Cheers,
Miguel
