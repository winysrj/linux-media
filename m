Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F06C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 04:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DA8B20881
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 04:38:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cl8EdIBT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfA1Eii (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 27 Jan 2019 23:38:38 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35086 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbfA1Eih (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Jan 2019 23:38:37 -0500
Received: by mail-oi1-f193.google.com with SMTP id v6so12014757oif.2
        for <linux-media@vger.kernel.org>; Sun, 27 Jan 2019 20:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bR08rzA7EA7sJsJgXK9I/eXr2roF79WHvtrbxmvWV/A=;
        b=cl8EdIBTzLhhJsFrCheyz5QNufgmACGXKTnxqMUG0LBvuqKTXSI9XncypCfV4j5nXG
         wxSczAkzU5kBA05W1vqZdPOsLo+EvZfgDEnLPcYcSJsXz/q7wbjz7VQAbEpWJ2cFc79I
         +KW+pFW8wGKtm4DqC8pF4sXbrHN2IaVLq2OFc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bR08rzA7EA7sJsJgXK9I/eXr2roF79WHvtrbxmvWV/A=;
        b=EsqTVz2e8rA1m/zQpvT+yiDqwkGl5I3S/1axt4fJCBMoTQlPWBRFb5XURat37dFHxI
         LaaNpdnlXH6vk8iMv+O6x31lEWDFDGGTa9zgbtr+JgYzdUQUTUjJSnXpbWEXJo1utU0d
         9tl0159B6CJq5jHZzAmj0/+ZEXtHuA2JgphAXfC7AeFNL0Gfhap/E2ajGmoO832NYQcr
         HAx6uWWpB1r/TU3x42pqE814FQ8wCGSsMUkYGkyysHOpX4LCxmSwP/6IfEYkdbbsyDcc
         s67i2R/YicqYHx1E7zFtJLcw5EFFNP0ZtYvHsfd58BuZav4Xm+Ffu2IWicMMJY91k/36
         5/Og==
X-Gm-Message-State: AHQUAuYUqxXrAv4eWtwIm2+BOXfifDiFTNKCnTPZc/aVoFtaO1LA6kfv
        KIxbuB2k2t7BRehkRQpoAMZB3vmLBFM=
X-Google-Smtp-Source: ALg8bN5zrAEUpJhYmnlO/JuyG/4U494fUUN3MC7racDzITJs20RSnfh8BIttIO2J1yC87xtLq5xQUg==
X-Received: by 2002:aca:f0d5:: with SMTP id o204mr5133651oih.359.1548649846125;
        Sun, 27 Jan 2019 20:30:46 -0800 (PST)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com. [209.85.210.52])
        by smtp.gmail.com with ESMTPSA id q10sm4095410otl.15.2019.01.27.20.30.43
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jan 2019 20:30:44 -0800 (PST)
Received: by mail-ot1-f52.google.com with SMTP id a11so13531565otr.10
        for <linux-media@vger.kernel.org>; Sun, 27 Jan 2019 20:30:43 -0800 (PST)
X-Received: by 2002:a9d:1b67:: with SMTP id l94mr14351362otl.147.1548649843040;
 Sun, 27 Jan 2019 20:30:43 -0800 (PST)
MIME-Version: 1.0
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <CAPBb6MVOPmRhhM=J-RqLOpc+mDbnxYdCMO3mqQfgN-F3b=kBCw@mail.gmail.com>
 <10deb3d1-2b10-43fe-bc77-4465f561c90a@linaro.org> <CAPBb6MUqi3xhgE_WPRP_7gZWcH2WGz8A7vskGGJW9zGM0=D1Sw@mail.gmail.com>
 <80b97fd8-bd3a-df74-c611-5da11bd7adc6@linaro.org> <CAPBb6MWoJ1EPFZkNtChqkzLZkzirOP1umhQa8-_vkErvWyfVFQ@mail.gmail.com>
In-Reply-To: <CAPBb6MWoJ1EPFZkNtChqkzLZkzirOP1umhQa8-_vkErvWyfVFQ@mail.gmail.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Mon, 28 Jan 2019 13:30:32 +0900
X-Gmail-Original-Message-ID: <CAAFQd5Cj=xpY_seGmJ5NM2H6_Jf=5AxE6XcL3DPqRH9SnPXjhQ@mail.gmail.com>
Message-ID: <CAAFQd5Cj=xpY_seGmJ5NM2H6_Jf=5AxE6XcL3DPqRH9SnPXjhQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] Venus stateful Codec API
To:     Alexandre Courbot <acourbot@chromium.org>
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Malathi Gottam <mgottam@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Jan 28, 2019 at 1:16 PM Alexandre Courbot <acourbot@chromium.org> wrote:
>
> On Fri, Jan 25, 2019 at 7:35 PM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
> >
> > Hi Alex,
> >
> > On 1/25/19 7:34 AM, Alexandre Courbot wrote:
> > > On Thu, Jan 24, 2019 at 7:13 PM Stanimir Varbanov
> > > <stanimir.varbanov@linaro.org> wrote:
> > >>
> > >> Hi Alex,
> > >>
> > >> Thank you for review and valuable comments!
> > >>
> > >> On 1/24/19 10:43 AM, Alexandre Courbot wrote:
> > >>> Hi Stanimir,
> > >>>
> > >>> On Fri, Jan 18, 2019 at 1:20 AM Stanimir Varbanov
> > >>> <stanimir.varbanov@linaro.org> wrote:
> > >>>>
> > >>>> Hello,
> > >>>>
> > >>>> This aims to make Venus decoder compliant with stateful Codec API [1].
> > >>>> The patches 1-9 are preparation for the cherry on the cake patch 10
> > >>>> which implements the decoder state machine similar to the one in the
> > >>>> stateful codec API documentation.
> > >>>
> > >>> Thanks *a lot* for this series! I am still stress-testing it against
> > >>> the Chromium decoder tests, but so far it has been rock-solid. I have
> > >>> a few inline comments on some patches ; I will also want to review the
> > >>> state machine more thoroughly after refreshing my mind on Tomasz doc,
> > >>> but this looks pretty promising already.
> > >>
> > >> I'm expecting problems with ResetAfterFirstConfigInfo. I don't know why
> > >> but this test case is very dirty. I'd appreciate any help to decipher
> > >> what is the sequence of v4l2 calls made by this unittest case.
> > >
> > > I did not see any issue with ResetAfterFirstConfigInfo, however
> > > ResourceExhaustion seems to hang once in a while. But I could already
> > > see this behavior with the older patchset.
> >
> > Is it hangs badly?
>
> It just stops processing, no crash. I need to investigate more closely.
>
> > >
> > > In any case I plan to thoroughly review the state machine. I agree it
> > > is a bit complex to grasp.
> >
> > yes the state machine isn't simple and I blamed Tomasz many times for
> > that :)

Don't shoot the messenger! I'm just carrying what hardware and
userspace made for us. ;)

>
> If I feel inspired I may try to extract the useful part of your patch
> into a framework that we can use everywhere. :) We don't want every
> driver to reimplement this complex state machine and introduce new
> bugs every time.

Yeah, we definitely need such a framework, especially given how the
m2m framework is overused for handling codecs.

Best regards,
Tomasz
