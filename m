Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 260CEC282C6
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 02:29:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E777D218CD
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 02:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbfAYC3Y (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 21:29:24 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36073 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728372AbfAYC3Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 21:29:24 -0500
Received: by mail-ed1-f66.google.com with SMTP id f23so6218885edb.3;
        Thu, 24 Jan 2019 18:29:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y+BmC2uXY8ot1UEWIZyOUHne2SSY9VMJ558CzqzKfKE=;
        b=m+IrvJMhpqHerhk2rlPYt4LR6/+mKKa5cqADLmDqJrgbaJozv7RY0ZloJdxtgvSBcS
         wzW5KGgNbBK3VeDyndWnBB/6YrCE5YwttylIVlqytlhTZjzCSsvFF1qLzujb/q4qeLAO
         GFRGZFbdumb6eA+q2A5UtRE+j6XtKY0S1OnGFx6xWz6jQ6ngPtNoZ4h8UX021wnPjCgA
         +Jvv3BSRGQ0siidByeMXDSNC4ay05MxmV5/4oz1IKgmzz0e2J/zHukr79+NUI+AHbErf
         J+aScs7Xb2Ja+UMiv2xDOYb7JqlI7/C3xEQ/Z3d0d2xWf1MU+OnYCwPfrECSMth19lp/
         1DwQ==
X-Gm-Message-State: AJcUukdVM59x6PrAvAbG0OKzaC+9FfrRz0GxFWLj4DpL/+/SvPgGqtx/
        QbmACjJA13HsoQmqe4yPCxuwrW+tsqY=
X-Google-Smtp-Source: ALg8bN73H/aJ0Rd6EKhqi8x+9cflYR71EHar//n0yGIV8LnaM8gAIlfeFQnNvV8aqWZ+CWmhTnWY0g==
X-Received: by 2002:a50:acc3:: with SMTP id x61mr8785328edc.76.1548383361374;
        Thu, 24 Jan 2019 18:29:21 -0800 (PST)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id a27sm12056653eda.65.2019.01.24.18.29.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 18:29:20 -0800 (PST)
Received: by mail-wr1-f45.google.com with SMTP id p7so8702693wru.0;
        Thu, 24 Jan 2019 18:29:20 -0800 (PST)
X-Received: by 2002:a5d:4f10:: with SMTP id c16mr9694148wru.177.1548383360301;
 Thu, 24 Jan 2019 18:29:20 -0800 (PST)
MIME-Version: 1.0
References: <20190111173015.12119-1-jernej.skrabec@siol.net>
 <20190111173015.12119-2-jernej.skrabec@siol.net> <CAGb2v66DiqK9sL-hQev4Wy08d9T7f1Yc2DFWJ0gYOnqChJyBRw@mail.gmail.com>
 <20190121095014.b6iq5dubfi7x2pi4@flea> <CAGb2v66d0wM8Yt2uS4MMhU6PP02h8CKwKjinasO6jtZ4ue1CAQ@mail.gmail.com>
 <20190122001917.GA31407@bogus> <CAGb2v67YsevDvjvTSh67wJNSJSUBuZ613hQWyorEiSzCUqjjkQ@mail.gmail.com>
 <CAL_Jsq+u2PdLK3YaYMERHndNpN_PprksPF9gVF+V76c343yrMg@mail.gmail.com>
In-Reply-To: <CAL_Jsq+u2PdLK3YaYMERHndNpN_PprksPF9gVF+V76c343yrMg@mail.gmail.com>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Fri, 25 Jan 2019 10:29:07 +0800
X-Gmail-Original-Message-ID: <CAGb2v67saMfK58vSx7=Mhq6Z06Qbj+vmbFv7=psddzB1X-GHkA@mail.gmail.com>
Message-ID: <CAGb2v67saMfK58vSx7=Mhq6Z06Qbj+vmbFv7=psddzB1X-GHkA@mail.gmail.com>
Subject: Re: [PATCH 1/3] media: dt: bindings: sunxi-ir: Add A64 compatible
To:     Rob Herring <robh@kernel.org>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 22, 2019 at 9:38 PM Rob Herring <robh@kernel.org> wrote:
>
> On Mon, Jan 21, 2019 at 8:16 PM Chen-Yu Tsai <wens@csie.org> wrote:
> >
> > On Tue, Jan 22, 2019 at 8:19 AM Rob Herring <robh@kernel.org> wrote:
> > >
> > > On Mon, Jan 21, 2019 at 05:57:57PM +0800, Chen-Yu Tsai wrote:
> > > > On Mon, Jan 21, 2019 at 5:50 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > > > >
> > > > > Hi,
> > > > >
> > > > > I'm a bit late to the party, sorry for that.
> > > > >
> > > > > On Sat, Jan 12, 2019 at 09:56:11AM +0800, Chen-Yu Tsai wrote:
> > > > > > On Sat, Jan 12, 2019 at 1:30 AM Jernej Skrabec <jernej.skrabec@siol.net> wrote:
> > > > > > >
> > > > > > > A64 IR is compatible with A13, so add A64 compatible with A13 as a
> > > > > > > fallback.
> > > > > >
> > > > > > We ask people to add the SoC-specific compatible as a contigency,
> > > > > > in case things turn out to be not so "compatible".
> > > > > >
> > > > > > To be consistent with all the other SoCs and other peripherals,
> > > > > > unless you already spotted a "compatible" difference in the
> > > > > > hardware, i.e. the hardware isn't completely the same, this
> > > > > > patch isn't needed. On the other hand, if you did, please mention
> > > > > > the differences in the commit log.
> > > > >
> > > > > Even if we don't spot things, since we have the stable DT now, if we
> > > > > ever had that compatible in the DT from day 1, it's much easier to
> > > > > deal with.
> > > > >
> > > > > I'd really like to have that pattern for all the IPs even if we didn't
> > > > > spot any issue, since we can't really say that the datasheet are
> > > > > complete, and one can always make a mistake and overlook something.
> > > > >
> > > > > I'm fine with this version, and can apply it as is if we all agree.
> > > >
> > > > I'm OK with having the fallback compatible. I'm just pointing out
> > > > that there are and will be a whole bunch of them, and we don't need
> > > > to document all of them unless we are actually doing something to
> > > > support them.
> > >
> > > Yes, you do. Otherwise, how will we validate what is and isn't a valid
> > > set of compatible strings? It's not required yet, but bindings are
> > > moving to json-schema.
> >
> > Ideally, if we knew which IP blocks in each SoC were compatible with
> > each other, we wouldn't need "per-SoC" compatible strings for each
> > block. However in reality this doesn't happen, due to a combination
> > of lack of time, lack of / uncertainty of documentation, and lack of
> > hardware for testing by the contributors.
> >
> > The per-SoC compatible we ask people to add are a contigency plan,
> > for when things don't actually work, and we need some way to support
> > that specific piece of hardware on old DTs.
>
> You are right up to here.
>
> > At which point we will
> > add that SoC-specific compatible as a new compatible string to the
> > bindings. But not before.
>
> No, the point SoC-specific compatibles is they are already present in
> the DT and you only have to update the OS to fix issues. The SoC
> specific compatible has to be documented when first used in dts files,
> not when the OS uses them. That is the rule.

We also want to be able to differentiate between per-SoC compatibles
vs actual backwards-compatible tuples, such as

    - "allwinner,sun8i-r40-rtc", "allwinner,sun8i-h3-rtc"

found in Documentation/devicetree/bindings/rtc/sun6i-rtc.txt .

In the future, if someone has the time to do an in-depth comparison
and testing, they should be able to deprecated and/or remove the per-SoC
compatible strings that we added for contingency from the bindings.

As such, I'd like implementors to not target the SoC-specific compatibles,
unless imcompatiblities are discovered, at which point the bindings would
also be updated, removing the fallback compatible.

The SoC-specific compatible strings are really a workaround for the lack
of resources of the community supporting this platform, while being able
to support DT stability. I want to make it clear in some way visible to
all that this is an exception, not the norm. And I'd also like to leave
the door open to later cleanup.

What would be an acceptable way to do this? Add extra notes accompanying
the per-SoC compatibles?

Regards
ChenYu
