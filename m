Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004B6C43387
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 03:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2BA321741
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 03:24:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="A4PCzdCB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbeLTDYB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 22:24:01 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:34793 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbeLTDYB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 22:24:01 -0500
Received: by mail-yb1-f196.google.com with SMTP id k136so131322ybk.1
        for <linux-media@vger.kernel.org>; Wed, 19 Dec 2018 19:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WigGHmhn8ueQ8GS23th66pOl8fNI6k+244A3qCu/rIY=;
        b=A4PCzdCBcDpDg6jnoPh26NIecKmndkn9twNXlDxDiGE8VvF3QlfIjIIiRhy1cLGxXT
         AeUtg/MyNRsAPtkDWlJD94bIdFBFbL4pbPXuGpePl4m9WtRHymSQawjxvQCmCdC2BX9p
         KzFKIQ7hl7Dcd9B/nKuRUJoM+Tl/jwg7nIfJ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WigGHmhn8ueQ8GS23th66pOl8fNI6k+244A3qCu/rIY=;
        b=rUNx07F9CPqMkrbcGnt+/yCYYoYjm4J/PE+i6/6yy9vj1zwNbMJ5pNi5p325L3VyXp
         zIvFyW6BJHOtsUin59zwQ6NMvF29jGURn/E/bKdgYYdAmGzsOURr5vmfgq6JA4bRKG9p
         p1/4TJYk9Namdyh3V7Ga8ZC2e83iFUAkGHNv6XbeCR1hjP68G38QZnVLrokEV3FdwQ2n
         XPsqq3pmBeAFLaHN+UK6mJ7bz9pgRGecTxJ+y0yhpl6fbk+OPBB+Sbr4hKE4nkV2Ifbg
         IftMGMSxrOJYAEo9O8ssc3sAHOgl6/TFfLbxWIUQApNPm2QlI+84Vn3CNVcOCizy/VQx
         BcBg==
X-Gm-Message-State: AA+aEWZoH/zliY2KOhITpDqdxJSb46Vo2OwA1+EmSWkDNd6eCcspjbO+
        ZvjKo4zdd79lpOlLaWavgb/90IquVOk=
X-Google-Smtp-Source: AFSGD/VA+v2EPXwenTlCoQasQ1YWCPgmhJN/qsi09pih1kTLbTzchbqxm1aBmfzIj82fackBC9gI5Q==
X-Received: by 2002:a25:aa10:: with SMTP id s16mr23971312ybi.327.1545276240176;
        Wed, 19 Dec 2018 19:24:00 -0800 (PST)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id j65sm6919377ywf.21.2018.12.19.19.23.58
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Dec 2018 19:23:59 -0800 (PST)
Received: by mail-yb1-f175.google.com with SMTP id e124so119129ybb.8
        for <linux-media@vger.kernel.org>; Wed, 19 Dec 2018 19:23:58 -0800 (PST)
X-Received: by 2002:a25:9907:: with SMTP id z7mr24009772ybn.114.1545276238429;
 Wed, 19 Dec 2018 19:23:58 -0800 (PST)
MIME-Version: 1.0
References: <20181212135440.GA6137@infradead.org> <CAAFQd5C4RbMxRP+ox+BDuApMusTD=WUD9Vs6aWL3u=HovuWUig@mail.gmail.com>
 <20181213140329.GA25339@infradead.org> <CAAFQd5BudF84jVaiy7KwevzBZnfYUZggDK=4W=g+Znf5VJjHsQ@mail.gmail.com>
 <20181214123624.GA5824@infradead.org> <CAAFQd5BnZHhNjOc6HKt=YVBVQFCcqN0RxAcfDp3S+gDKRvciqQ@mail.gmail.com>
 <20181218073847.GA4552@infradead.org> <CAAFQd5AT3ixnbZRm3TOjoWrk2UNH0bXqgR+Z8wyjMhr0xHtSOg@mail.gmail.com>
 <20181219075150.GA26656@infradead.org> <CAAFQd5DJPDpFDxU_m2r02bA59J8RCHW7iE8zYQUmkL4sFSz05Q@mail.gmail.com>
 <20181219145122.GA31947@infradead.org>
In-Reply-To: <20181219145122.GA31947@infradead.org>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 20 Dec 2018 12:23:46 +0900
X-Gmail-Original-Message-ID: <CAAFQd5CsX-YJdwQUS+eEK6kj1xU94AiGHY0QX=QGnf67JcKyaQ@mail.gmail.com>
Message-ID: <CAAFQd5CsX-YJdwQUS+eEK6kj1xU94AiGHY0QX=QGnf67JcKyaQ@mail.gmail.com>
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

On Wed, Dec 19, 2018 at 11:51 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Dec 19, 2018 at 05:18:35PM +0900, Tomasz Figa wrote:
> > The existing code that deals with dma_alloc_attrs() without
> > DMA_ATTR_NON_CONSISTENT would just call dma_get_sgtable_attrs() like
> > here:
>
> I know.  And dma_get_sgtable_attrs is fundamentally flawed and we
> need to kill this interface as it just can't worked with virtually
> tagged cases.  It is a prime example for an interface that looks
> nice and simple but is plain wrong.

Got it, thanks.

I haven't been following the problems with virtually tagged cases,
would you mind sharing some background, so that we can consider it
when adding non-consistent allocations to VB2?

Best regards,
Tomasz
