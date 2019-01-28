Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF46BC282CC
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 04:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DE3020881
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 04:38:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JgwM9jlA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfA1Eij (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 27 Jan 2019 23:38:39 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:45526 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfA1Eii (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Jan 2019 23:38:38 -0500
Received: by mail-oi1-f195.google.com with SMTP id y1so11956955oie.12
        for <linux-media@vger.kernel.org>; Sun, 27 Jan 2019 20:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4o94gMECcDXjEg3sIpRNb9ndtNzEjbC1OgSnKyAQvlI=;
        b=JgwM9jlA7vZeGN3epEHnd1/PZBv/Wml4B3j2K1N8+m8UzLIkDsEvIjIKWSuIjqfRb9
         6ddTRZccL8WQ2tPDd7tBY2BI60u2jQrjgFj3enqqd9Y2nRSpKHBMpun2fOLHhBKLjM9Z
         0U4L27D4AhPfQDcDxDRcxYZf9XfBecD0BJzVs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4o94gMECcDXjEg3sIpRNb9ndtNzEjbC1OgSnKyAQvlI=;
        b=qT2Sgdg+npibGHdZ5EJAzsCAwnulDgFt38+fgnYVR02CxM4sfT9p+ooHnbBRyzqFJV
         XxNFzCQqmk8/TLWWLa+P+BB7izJb2G7GMJgYD0gJSOeMOthGa3ljpUiYlWg4h8w6jbjQ
         y4G6mKcH3253Q1ba3T21v5yzhtMgbB03DgB7A2ifOAcNXuavIacVzQTiq2qw/OJ/jnyM
         D2IdnARUlqynVIRMnnRlSh3kUlkm+FYuWagsZD9Ic/eSWRqjXl+kTzbIedlvZGbxxjRK
         PZv6F6NE+0QhylaUVFJzywsx9Mx9AmXB3FFXTmFv07BavYylrEbYCd72zEgpfxX8Z/9D
         sT4A==
X-Gm-Message-State: AHQUAuZg2uS2D37FUdXfyFRKGJcVKow10xi3IY7zbN8LWnmJQlfhhzYm
        Kw2t8/e3QWeuVrrkWzmOvKDFHoI+89I=
X-Google-Smtp-Source: AHgI3Iafs0an7t2sIxHyudJM4ggNyFhUoYDdxxcbhoZ3rYOPO1XwCEWtl+2m06BEaHUM21g8LH9tyQ==
X-Received: by 2002:aca:5117:: with SMTP id f23mr5101038oib.72.1548649004769;
        Sun, 27 Jan 2019 20:16:44 -0800 (PST)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com. [209.85.210.44])
        by smtp.gmail.com with ESMTPSA id m207sm4566810oig.2.2019.01.27.20.16.43
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jan 2019 20:16:44 -0800 (PST)
Received: by mail-ot1-f44.google.com with SMTP id a11so13515020otr.10
        for <linux-media@vger.kernel.org>; Sun, 27 Jan 2019 20:16:43 -0800 (PST)
X-Received: by 2002:a9d:177:: with SMTP id 110mr15588936otu.26.1548649003613;
 Sun, 27 Jan 2019 20:16:43 -0800 (PST)
MIME-Version: 1.0
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <CAPBb6MVOPmRhhM=J-RqLOpc+mDbnxYdCMO3mqQfgN-F3b=kBCw@mail.gmail.com>
 <10deb3d1-2b10-43fe-bc77-4465f561c90a@linaro.org> <CAPBb6MUqi3xhgE_WPRP_7gZWcH2WGz8A7vskGGJW9zGM0=D1Sw@mail.gmail.com>
 <80b97fd8-bd3a-df74-c611-5da11bd7adc6@linaro.org>
In-Reply-To: <80b97fd8-bd3a-df74-c611-5da11bd7adc6@linaro.org>
From:   Alexandre Courbot <acourbot@chromium.org>
Date:   Mon, 28 Jan 2019 13:16:31 +0900
X-Gmail-Original-Message-ID: <CAPBb6MWoJ1EPFZkNtChqkzLZkzirOP1umhQa8-_vkErvWyfVFQ@mail.gmail.com>
Message-ID: <CAPBb6MWoJ1EPFZkNtChqkzLZkzirOP1umhQa8-_vkErvWyfVFQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] Venus stateful Codec API
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Jan 25, 2019 at 7:35 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Alex,
>
> On 1/25/19 7:34 AM, Alexandre Courbot wrote:
> > On Thu, Jan 24, 2019 at 7:13 PM Stanimir Varbanov
> > <stanimir.varbanov@linaro.org> wrote:
> >>
> >> Hi Alex,
> >>
> >> Thank you for review and valuable comments!
> >>
> >> On 1/24/19 10:43 AM, Alexandre Courbot wrote:
> >>> Hi Stanimir,
> >>>
> >>> On Fri, Jan 18, 2019 at 1:20 AM Stanimir Varbanov
> >>> <stanimir.varbanov@linaro.org> wrote:
> >>>>
> >>>> Hello,
> >>>>
> >>>> This aims to make Venus decoder compliant with stateful Codec API [1].
> >>>> The patches 1-9 are preparation for the cherry on the cake patch 10
> >>>> which implements the decoder state machine similar to the one in the
> >>>> stateful codec API documentation.
> >>>
> >>> Thanks *a lot* for this series! I am still stress-testing it against
> >>> the Chromium decoder tests, but so far it has been rock-solid. I have
> >>> a few inline comments on some patches ; I will also want to review the
> >>> state machine more thoroughly after refreshing my mind on Tomasz doc,
> >>> but this looks pretty promising already.
> >>
> >> I'm expecting problems with ResetAfterFirstConfigInfo. I don't know why
> >> but this test case is very dirty. I'd appreciate any help to decipher
> >> what is the sequence of v4l2 calls made by this unittest case.
> >
> > I did not see any issue with ResetAfterFirstConfigInfo, however
> > ResourceExhaustion seems to hang once in a while. But I could already
> > see this behavior with the older patchset.
>
> Is it hangs badly?

It just stops processing, no crash. I need to investigate more closely.

> >
> > In any case I plan to thoroughly review the state machine. I agree it
> > is a bit complex to grasp.
>
> yes the state machine isn't simple and I blamed Tomasz many times for
> that :)

If I feel inspired I may try to extract the useful part of your patch
into a framework that we can use everywhere. :) We don't want every
driver to reimplement this complex state machine and introduce new
bugs every time.
