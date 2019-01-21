Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0508EC282F6
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 09:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D40C921738
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 09:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfAUJ6O (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 04:58:14 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44075 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfAUJ6O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 04:58:14 -0500
Received: by mail-ed1-f66.google.com with SMTP id y56so16032427edd.11;
        Mon, 21 Jan 2019 01:58:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2FK5jNlsShQJzHoLLKIat5FmMB5NfMzifMxo7fd5+GI=;
        b=rl/r+0ecBA9MkThfqiW2kRWpAG33dZxrQ8eE+1sG5mtWIWZOCiFDLlp0j/52wOBNLx
         Dkdqa8WkgkR/VA7SeXBGSg19Zq/BMdOPuty3Il2in/V05g7twQHi8QxUnKB8lVsB9YV4
         EGCVMPT93cTVdI8DWIPKKj6iN7y3gRo1xqwEYIXGJ7I41EhTsmzY9JsKdQrLXHOKhDhg
         JXCi2Jf+Dkuu+XECnESX5JJEVcTsx6tnbgn/zAa7Vnx8WbITgi6HtuS/DcjfzphqCwR6
         WbVb5OoVuKAR0EqHGJSbftUQvNNN4ANAGVKb9gwgbAxQRhU6GlQlaZYYQFW/IogTH/Pw
         uHlA==
X-Gm-Message-State: AJcUukcZzS9keYuXJxLcAhhEADi9eAlUgs2ijmCeffQsO7P9RnqBwluM
        V6SnkpXSfsmYFj9wvtBhWKXxC/1oLa4=
X-Google-Smtp-Source: ALg8bN6E3c6royDOpaLHIKA4G4YO8MMnTNO4A2SRyCP/KcYZPqIwrspYnbg13w+rgDgnEmooZ7ce0A==
X-Received: by 2002:a17:906:9708:: with SMTP id k8-v6mr23991022ejx.205.1548064691798;
        Mon, 21 Jan 2019 01:58:11 -0800 (PST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id y16sm8924433edb.41.2019.01.21.01.58.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 01:58:10 -0800 (PST)
Received: by mail-wr1-f41.google.com with SMTP id c14so22580868wrr.0;
        Mon, 21 Jan 2019 01:58:09 -0800 (PST)
X-Received: by 2002:a5d:4f10:: with SMTP id c16mr28037486wru.177.1548064689599;
 Mon, 21 Jan 2019 01:58:09 -0800 (PST)
MIME-Version: 1.0
References: <20190111173015.12119-1-jernej.skrabec@siol.net>
 <20190111173015.12119-2-jernej.skrabec@siol.net> <CAGb2v66DiqK9sL-hQev4Wy08d9T7f1Yc2DFWJ0gYOnqChJyBRw@mail.gmail.com>
 <20190121095014.b6iq5dubfi7x2pi4@flea>
In-Reply-To: <20190121095014.b6iq5dubfi7x2pi4@flea>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Mon, 21 Jan 2019 17:57:57 +0800
X-Gmail-Original-Message-ID: <CAGb2v66d0wM8Yt2uS4MMhU6PP02h8CKwKjinasO6jtZ4ue1CAQ@mail.gmail.com>
Message-ID: <CAGb2v66d0wM8Yt2uS4MMhU6PP02h8CKwKjinasO6jtZ4ue1CAQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] media: dt: bindings: sunxi-ir: Add A64 compatible
To:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>
Cc:     Rob Herring <robh+dt@kernel.org>,
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

On Mon, Jan 21, 2019 at 5:50 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> Hi,
>
> I'm a bit late to the party, sorry for that.
>
> On Sat, Jan 12, 2019 at 09:56:11AM +0800, Chen-Yu Tsai wrote:
> > On Sat, Jan 12, 2019 at 1:30 AM Jernej Skrabec <jernej.skrabec@siol.net> wrote:
> > >
> > > A64 IR is compatible with A13, so add A64 compatible with A13 as a
> > > fallback.
> >
> > We ask people to add the SoC-specific compatible as a contigency,
> > in case things turn out to be not so "compatible".
> >
> > To be consistent with all the other SoCs and other peripherals,
> > unless you already spotted a "compatible" difference in the
> > hardware, i.e. the hardware isn't completely the same, this
> > patch isn't needed. On the other hand, if you did, please mention
> > the differences in the commit log.
>
> Even if we don't spot things, since we have the stable DT now, if we
> ever had that compatible in the DT from day 1, it's much easier to
> deal with.
>
> I'd really like to have that pattern for all the IPs even if we didn't
> spot any issue, since we can't really say that the datasheet are
> complete, and one can always make a mistake and overlook something.
>
> I'm fine with this version, and can apply it as is if we all agree.

I'm OK with having the fallback compatible. I'm just pointing out
that there are and will be a whole bunch of them, and we don't need
to document all of them unless we are actually doing something to
support them.

On the other hand, the compatible string situation for IR needs a
bit of cleaning up at the moment. Right now we have sun4i-a10 and
sun5i-a13. As Jernej pointed out, the A13's register definition is
different from A64 (or any other SoCs later than sun6i). So we need
someone with an A10s/A13 device that has IR to test it and see if
the driver or the manual is wrong, and we'd likely add a compatible
for the A20.

Also, the earlier SoCs (A10/sun5i/A20) have IR TX capability. This
was lost in A31, and also all of sun8i / sun50i. So we're going to
need to add an A31 compatible that all later platforms would need
to switch to.


Regards
ChenYu
