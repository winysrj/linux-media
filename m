Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D649C31680
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 17:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF0B82089F
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 17:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbfAURjl convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 12:39:41 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42425 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfAURjl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 12:39:41 -0500
Received: by mail-ed1-f67.google.com with SMTP id y20so17191485edw.9;
        Mon, 21 Jan 2019 09:39:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wtKWupWOVAPiWJSuxk5cYsPaqbkthRI/t7KdeUs+oa8=;
        b=XDhtFIa2qxgrIut7wWplXZVF4Mt6EpxKkwD2JNpvM+c/m7EhZVZjFYeOzm5LgO01hu
         5pzB3NuOYNJVwS5GGA0p4D4b7v+/dP7VluhnBWdlV3CrJ1+w4Xoe+xxo4afjGrWJXjhF
         cPlL2IcG85AghRWXRic4WSID51QOUueVobYxfkGyCp/vXJ6MxvXH6+0jmAXnL39iPt1g
         Dbrqssp6Eg1qmab8AqJIdHLDDwZgVwtlB/zy/z+Bh/0LS7BoOFLEKXwtEEvMMiNk/9Z9
         wu5qq+XV/4iBJufz57E60svydqjm2QYaIBqzXIS49pr9K/Ni0dVzux5O09/vIVWiGoQ2
         lgjQ==
X-Gm-Message-State: AJcUukcxyLyiE1UqvtAdhpPsUvIqSkpfWWnqx9KqimYpVLj0j7sG6cMr
        f9v4Fuyfw0blX+P7lvLl1iJU9kIaPuI=
X-Google-Smtp-Source: ALg8bN5OuVTn/PWWAWOv3eCzLmCuiHr/639rAACq/EuAZrYA8tmi/1wdCfxCOQaX07oVTadOeLCoVg==
X-Received: by 2002:a50:c017:: with SMTP id r23mr28348991edb.278.1548092379076;
        Mon, 21 Jan 2019 09:39:39 -0800 (PST)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id z2sm9380740edd.4.2019.01.21.09.39.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 09:39:38 -0800 (PST)
Received: by mail-wm1-f51.google.com with SMTP id y139so11559529wmc.5;
        Mon, 21 Jan 2019 09:39:38 -0800 (PST)
X-Received: by 2002:a1c:2382:: with SMTP id j124mr367501wmj.14.1548092378363;
 Mon, 21 Jan 2019 09:39:38 -0800 (PST)
MIME-Version: 1.0
References: <20190111173015.12119-1-jernej.skrabec@siol.net>
 <20190121095014.b6iq5dubfi7x2pi4@flea> <CAGb2v66d0wM8Yt2uS4MMhU6PP02h8CKwKjinasO6jtZ4ue1CAQ@mail.gmail.com>
 <3128239.8RYQUhiYef@jernej-laptop>
In-Reply-To: <3128239.8RYQUhiYef@jernej-laptop>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Tue, 22 Jan 2019 01:39:26 +0800
X-Gmail-Original-Message-ID: <CAGb2v65t6kO9HfSTuXZsBu6Pyc+mueLq-5tsYsw9vxwg5o=v4A@mail.gmail.com>
Message-ID: <CAGb2v65t6kO9HfSTuXZsBu6Pyc+mueLq-5tsYsw9vxwg5o=v4A@mail.gmail.com>
Subject: Re: [PATCH 1/3] media: dt: bindings: sunxi-ir: Add A64 compatible
To:     =?UTF-8?Q?Jernej_=C5=A0krabec?= <jernej.skrabec@siol.net>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 22, 2019 at 1:33 AM Jernej Škrabec <jernej.skrabec@siol.net> wrote:
>
> Dne ponedeljek, 21. januar 2019 ob 10:57:57 CET je Chen-Yu Tsai napisal(a):
> > On Mon, Jan 21, 2019 at 5:50 PM Maxime Ripard <maxime.ripard@bootlin.com>
> wrote:
> > > Hi,
> > >
> > > I'm a bit late to the party, sorry for that.
> > >
> > > On Sat, Jan 12, 2019 at 09:56:11AM +0800, Chen-Yu Tsai wrote:
> > > > On Sat, Jan 12, 2019 at 1:30 AM Jernej Skrabec <jernej.skrabec@siol.net>
> wrote:
> > > > > A64 IR is compatible with A13, so add A64 compatible with A13 as a
> > > > > fallback.
> > > >
> > > > We ask people to add the SoC-specific compatible as a contigency,
> > > > in case things turn out to be not so "compatible".
> > > >
> > > > To be consistent with all the other SoCs and other peripherals,
> > > > unless you already spotted a "compatible" difference in the
> > > > hardware, i.e. the hardware isn't completely the same, this
> > > > patch isn't needed. On the other hand, if you did, please mention
> > > > the differences in the commit log.
> > >
> > > Even if we don't spot things, since we have the stable DT now, if we
> > > ever had that compatible in the DT from day 1, it's much easier to
> > > deal with.
> > >
> > > I'd really like to have that pattern for all the IPs even if we didn't
> > > spot any issue, since we can't really say that the datasheet are
> > > complete, and one can always make a mistake and overlook something.
> > >
> > > I'm fine with this version, and can apply it as is if we all agree.
> >
> > I'm OK with having the fallback compatible. I'm just pointing out
> > that there are and will be a whole bunch of them, and we don't need
> > to document all of them unless we are actually doing something to
> > support them.
>
> If you don't document them, checkpatch will complain. But if you can live with
> this warning, that's fine by me.
>
> >
> > On the other hand, the compatible string situation for IR needs a
> > bit of cleaning up at the moment. Right now we have sun4i-a10 and
> > sun5i-a13. As Jernej pointed out, the A13's register definition is
> > different from A64 (or any other SoCs later than sun6i). So we need
> > someone with an A10s/A13 device that has IR to test it and see if
> > the driver or the manual is wrong, and we'd likely add a compatible
> > for the A20.
> >
> > Also, the earlier SoCs (A10/sun5i/A20) have IR TX capability. This
> > was lost in A31, and also all of sun8i / sun50i. So we're going to
> > need to add an A31 compatible that all later platforms would need
> > to switch to.
> >
>
> H6 has IR TX peripheral too, but it's different IP block...
>
> Do you want me to switch all A31 and newer to different compatible in this
> series? I can do this, but I haven't any A13 device to test if this is really
> needed. Or you can argue that this is needed anyway due to missing TX
> capability.

The lack of TX capability does necessitate switching to an A31 compatible.
So yes, please switch. Lets leave the A10s/A13 alone for now, unless
someone complains. I think this was done from inception, so if it was
broken, someone should've complained a long time ago. I just want to
be sure where the error is, and put in a comment explaining it. However
I don't have the hardware either.

ChenYu
