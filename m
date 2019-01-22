Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3925C282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 13:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2526217D8
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 13:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548164292;
	bh=jodr6i6s3jvg2nhf0kijRpn+bTr+EGnPky61yayyNdU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=AT8kLwq9nPzu5uda1GTQEDDP4C33A/aJE0UeEpjk6zS/c4Ppxo+SUZsy0EzMgnMa9
	 hTXySUSfgkAqbu1e4+Mz6BlMezZDvmFzQLcnInT75puiprqUyb0VsFfkl1gehxrbLu
	 6MGx7AUOZVyn15TAqWzwiNPT7m16Nky8TZ8zmQaI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbfAVNiG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 08:38:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728305AbfAVNiF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 08:38:05 -0500
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED269217F9;
        Tue, 22 Jan 2019 13:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548164284;
        bh=jodr6i6s3jvg2nhf0kijRpn+bTr+EGnPky61yayyNdU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=p6P9jCixubpZqW9mQ9FjNqhZFrMnRzLp5ynzREMTh8/uSUtAePuOsv8uKy5l+Sgo/
         LELpzJWUSSF5w6N2yFOUyfUkzVDkL/zWL9sP/vSlMZap+3XllIO+aUhtYB2hmyrl12
         etYfCwZuEHYfaVsJfqQ11c1/w//DdrHkW3AiyT10=
Received: by mail-qt1-f180.google.com with SMTP id l11so27627609qtp.0;
        Tue, 22 Jan 2019 05:38:03 -0800 (PST)
X-Gm-Message-State: AJcUukcmVoFoUTvwPlbcjmNbuaAEL93QjflSQjIXStWBRFGqICUx9GxM
        v/5QuE4JaxVYfVbgC9HlcZEUXSt5+e5M0WN1oQ==
X-Google-Smtp-Source: ALg8bN4etqq10Dl4Ve0aHvgW7iUFq/uRu0ytKakxodDc1gBLnyubvCHhqLHe7MWZZ23Nm1vbcopo7UiQdvK1GbtoFO8=
X-Received: by 2002:ac8:1712:: with SMTP id w18mr30740377qtj.76.1548164283123;
 Tue, 22 Jan 2019 05:38:03 -0800 (PST)
MIME-Version: 1.0
References: <20190111173015.12119-1-jernej.skrabec@siol.net>
 <20190111173015.12119-2-jernej.skrabec@siol.net> <CAGb2v66DiqK9sL-hQev4Wy08d9T7f1Yc2DFWJ0gYOnqChJyBRw@mail.gmail.com>
 <20190121095014.b6iq5dubfi7x2pi4@flea> <CAGb2v66d0wM8Yt2uS4MMhU6PP02h8CKwKjinasO6jtZ4ue1CAQ@mail.gmail.com>
 <20190122001917.GA31407@bogus> <CAGb2v67YsevDvjvTSh67wJNSJSUBuZ613hQWyorEiSzCUqjjkQ@mail.gmail.com>
In-Reply-To: <CAGb2v67YsevDvjvTSh67wJNSJSUBuZ613hQWyorEiSzCUqjjkQ@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 22 Jan 2019 07:37:51 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+u2PdLK3YaYMERHndNpN_PprksPF9gVF+V76c343yrMg@mail.gmail.com>
Message-ID: <CAL_Jsq+u2PdLK3YaYMERHndNpN_PprksPF9gVF+V76c343yrMg@mail.gmail.com>
Subject: Re: [PATCH 1/3] media: dt: bindings: sunxi-ir: Add A64 compatible
To:     Chen-Yu Tsai <wens@csie.org>
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

On Mon, Jan 21, 2019 at 8:16 PM Chen-Yu Tsai <wens@csie.org> wrote:
>
> On Tue, Jan 22, 2019 at 8:19 AM Rob Herring <robh@kernel.org> wrote:
> >
> > On Mon, Jan 21, 2019 at 05:57:57PM +0800, Chen-Yu Tsai wrote:
> > > On Mon, Jan 21, 2019 at 5:50 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > I'm a bit late to the party, sorry for that.
> > > >
> > > > On Sat, Jan 12, 2019 at 09:56:11AM +0800, Chen-Yu Tsai wrote:
> > > > > On Sat, Jan 12, 2019 at 1:30 AM Jernej Skrabec <jernej.skrabec@siol.net> wrote:
> > > > > >
> > > > > > A64 IR is compatible with A13, so add A64 compatible with A13 as a
> > > > > > fallback.
> > > > >
> > > > > We ask people to add the SoC-specific compatible as a contigency,
> > > > > in case things turn out to be not so "compatible".
> > > > >
> > > > > To be consistent with all the other SoCs and other peripherals,
> > > > > unless you already spotted a "compatible" difference in the
> > > > > hardware, i.e. the hardware isn't completely the same, this
> > > > > patch isn't needed. On the other hand, if you did, please mention
> > > > > the differences in the commit log.
> > > >
> > > > Even if we don't spot things, since we have the stable DT now, if we
> > > > ever had that compatible in the DT from day 1, it's much easier to
> > > > deal with.
> > > >
> > > > I'd really like to have that pattern for all the IPs even if we didn't
> > > > spot any issue, since we can't really say that the datasheet are
> > > > complete, and one can always make a mistake and overlook something.
> > > >
> > > > I'm fine with this version, and can apply it as is if we all agree.
> > >
> > > I'm OK with having the fallback compatible. I'm just pointing out
> > > that there are and will be a whole bunch of them, and we don't need
> > > to document all of them unless we are actually doing something to
> > > support them.
> >
> > Yes, you do. Otherwise, how will we validate what is and isn't a valid
> > set of compatible strings? It's not required yet, but bindings are
> > moving to json-schema.
>
> Ideally, if we knew which IP blocks in each SoC were compatible with
> each other, we wouldn't need "per-SoC" compatible strings for each
> block. However in reality this doesn't happen, due to a combination
> of lack of time, lack of / uncertainty of documentation, and lack of
> hardware for testing by the contributors.
>
> The per-SoC compatible we ask people to add are a contigency plan,
> for when things don't actually work, and we need some way to support
> that specific piece of hardware on old DTs.

You are right up to here.

> At which point we will
> add that SoC-specific compatible as a new compatible string to the
> bindings. But not before.

No, the point SoC-specific compatibles is they are already present in
the DT and you only have to update the OS to fix issues. The SoC
specific compatible has to be documented when first used in dts files,
not when the OS uses them. That is the rule.

Rob
