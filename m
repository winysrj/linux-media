Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6395BC37122
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 02:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 333F521721
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 02:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfAVCQa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 21:16:30 -0500
Received: from mail-ed1-f46.google.com ([209.85.208.46]:44882 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbfAVCQa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 21:16:30 -0500
Received: by mail-ed1-f46.google.com with SMTP id y56so18006915edd.11;
        Mon, 21 Jan 2019 18:16:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7SoHKgLs7vVuHGn81uBAUlpOTQtoImghD8Y6F22vX1k=;
        b=anmUry9RUl4pJYuZjAXOMkcoRACPMvReQh4AwXZ87XhaGUG+do3gJvH8KNu8DjYJv7
         fXY+JweRetDMryiJvAZhdlQSLMiob4mxiERMB9zJizQLikP6AZGZ0ou6f30cHfBYOaJt
         n+RZTxJx5I5j/W8RIYSUy9Lh74wlgdl8o8weiCFaGT6Soi7XONn874u1JmuJgceXMFt6
         r98ujvn5cj1onZX55geMfjmgjRpkG6uhFoo25XMrqZnS7UU1LpP5Z/Q/Dp+oi+mErmJ4
         FnO/Z0woCZ8HNRgRWvxa9xKaG2K02cLtH5zpgRU4f7cGtB5Ehv47gRlBHIuENbmlLMIB
         PZoQ==
X-Gm-Message-State: AJcUukfV1+CKoXAGy02EyDQZTJ5IeVz/3P53Nb/dcgY03Z6fqKAtckog
        Cbv6s8+QRJKpLtuEuHs9AVqsjNABt8w=
X-Google-Smtp-Source: ALg8bN6r/GMffSsGazB/I2mXpjDZN98ft0uTHNnn3ZFnwQT7jee56qX+BT2wC7rDf1VMaUHwUBFcVA==
X-Received: by 2002:a50:c8c9:: with SMTP id k9mr28534998edh.6.1548123387755;
        Mon, 21 Jan 2019 18:16:27 -0800 (PST)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id ec19-v6sm5177401ejb.11.2019.01.21.18.16.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 18:16:27 -0800 (PST)
Received: by mail-wm1-f51.google.com with SMTP id y185so7445717wmd.1;
        Mon, 21 Jan 2019 18:16:27 -0800 (PST)
X-Received: by 2002:a1c:c008:: with SMTP id q8mr1378866wmf.99.1548123386752;
 Mon, 21 Jan 2019 18:16:26 -0800 (PST)
MIME-Version: 1.0
References: <20190111173015.12119-1-jernej.skrabec@siol.net>
 <20190111173015.12119-2-jernej.skrabec@siol.net> <CAGb2v66DiqK9sL-hQev4Wy08d9T7f1Yc2DFWJ0gYOnqChJyBRw@mail.gmail.com>
 <20190121095014.b6iq5dubfi7x2pi4@flea> <CAGb2v66d0wM8Yt2uS4MMhU6PP02h8CKwKjinasO6jtZ4ue1CAQ@mail.gmail.com>
 <20190122001917.GA31407@bogus>
In-Reply-To: <20190122001917.GA31407@bogus>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Tue, 22 Jan 2019 10:16:13 +0800
X-Gmail-Original-Message-ID: <CAGb2v67YsevDvjvTSh67wJNSJSUBuZ613hQWyorEiSzCUqjjkQ@mail.gmail.com>
Message-ID: <CAGb2v67YsevDvjvTSh67wJNSJSUBuZ613hQWyorEiSzCUqjjkQ@mail.gmail.com>
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

On Tue, Jan 22, 2019 at 8:19 AM Rob Herring <robh@kernel.org> wrote:
>
> On Mon, Jan 21, 2019 at 05:57:57PM +0800, Chen-Yu Tsai wrote:
> > On Mon, Jan 21, 2019 at 5:50 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > >
> > > Hi,
> > >
> > > I'm a bit late to the party, sorry for that.
> > >
> > > On Sat, Jan 12, 2019 at 09:56:11AM +0800, Chen-Yu Tsai wrote:
> > > > On Sat, Jan 12, 2019 at 1:30 AM Jernej Skrabec <jernej.skrabec@siol.net> wrote:
> > > > >
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
> Yes, you do. Otherwise, how will we validate what is and isn't a valid
> set of compatible strings? It's not required yet, but bindings are
> moving to json-schema.

Ideally, if we knew which IP blocks in each SoC were compatible with
each other, we wouldn't need "per-SoC" compatible strings for each
block. However in reality this doesn't happen, due to a combination
of lack of time, lack of / uncertainty of documentation, and lack of
hardware for testing by the contributors.

The per-SoC compatible we ask people to add are a contigency plan,
for when things don't actually work, and we need some way to support
that specific piece of hardware on old DTs. At which point we will
add that SoC-specific compatible as a new compatible string to the
bindings. But not before.

ChenYu
