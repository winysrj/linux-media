Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC69C282C5
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 02:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58CDE218D9
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 02:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbfAYCuQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 21:50:16 -0500
Received: from mail-ed1-f43.google.com ([209.85.208.43]:39987 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfAYCuQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 21:50:16 -0500
Received: by mail-ed1-f43.google.com with SMTP id g22so6231059edr.7;
        Thu, 24 Jan 2019 18:50:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=P1zzXln1riUs/zkYl5yWs+M8mhcZVCnbTojUF9bsN5Y=;
        b=qDLmKpjIXiq3aL2KpSxWjIXZHdlBjkSP7USiZQmFFlHV+3I9G7ftoTHbcF0WZpSmUy
         dkI0gIRslYeHPhM7rFS+k2dnHX7FEMwKBMnHpGILQTMqHyzeIxqtEaB7IHWCt0MSVYZC
         5PpHDR1QGIKTFBwXmdnEZvFjN4OxmQWvsR67shikTPmJfaKb0eFttYCfsC0wO+xfXWbj
         erpZNrt1aq5N1MKx9MNL5/3DeuAbH0Q4SDQhSaBpRjeU40EKMGfORgn1xa3PHe+6ufmz
         YcXwiN5Z8FBqQgZsOo2fADll1EuJIXOcIc07Hjj+8ZYglZNAPafkrhCMEdr4IJRgcBN/
         yJcg==
X-Gm-Message-State: AJcUukegZW9H/+IoFt9O/eQPG+wKgeDcA5K3c7CxdLft7FGsX11YYf1L
        KBnuvYagv9pQE89seqCrj2zPwo1rrUA=
X-Google-Smtp-Source: ALg8bN5q4/A6GkXF8L1z2swVZZ9HbVJEYQbBc1e5KP/oXZq5jPMklBiJS0K1HVlHyiDAEnErQ+i22g==
X-Received: by 2002:a50:9291:: with SMTP id k17mr8947875eda.243.1548384612869;
        Thu, 24 Jan 2019 18:50:12 -0800 (PST)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id p30sm11299201eda.68.2019.01.24.18.50.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 18:50:12 -0800 (PST)
Received: by mail-wr1-f46.google.com with SMTP id p7so8731375wru.0;
        Thu, 24 Jan 2019 18:50:12 -0800 (PST)
X-Received: by 2002:adf:891a:: with SMTP id s26mr9414215wrs.44.1548384611813;
 Thu, 24 Jan 2019 18:50:11 -0800 (PST)
MIME-Version: 1.0
References: <20190111173015.12119-1-jernej.skrabec@siol.net>
 <20190121095014.b6iq5dubfi7x2pi4@flea> <CAGb2v66d0wM8Yt2uS4MMhU6PP02h8CKwKjinasO6jtZ4ue1CAQ@mail.gmail.com>
 <2800701.S2xdS7azMu@jernej-laptop>
In-Reply-To: <2800701.S2xdS7azMu@jernej-laptop>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Fri, 25 Jan 2019 10:49:58 +0800
X-Gmail-Original-Message-ID: <CAGb2v66wm3ZVjHxqBvU1EgBjj3Dn9keyG8jGrdiiXEFa_HD2kg@mail.gmail.com>
Message-ID: <CAGb2v66wm3ZVjHxqBvU1EgBjj3Dn9keyG8jGrdiiXEFa_HD2kg@mail.gmail.com>
Subject: Re: [PATCH 1/3] media: dt: bindings: sunxi-ir: Add A64 compatible
To:     =?UTF-8?Q?Jernej_=C5=A0krabec?= <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
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

On Fri, Jan 25, 2019 at 2:57 AM Jernej Škrabec <jernej.skrabec@siol.net> wrote:
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
>
> Actually, A13 also doesn't have IR TX capability. So I still think it's best
> having A13 compatible as a fallback and not A31. Unless A31 was released
> before A13?

No, but the A31 IR receiver has some additional bits in the FIFO control
and status registers, as well as the config register (which controls
sampling parameters). Looks like the A31 has an improved version. That
would make it backward compatible, if not for the fact that the FIFO
level bits are at a different offset, which might have been moved to
make way for the extra bits. That would make them incompatible. But
this should really be tested.

So the fallback compatible should be the A31's, not the A13's.

The A64's looks like the same hardware as the A31, with two extra bits:

  - CGPO: register 0x00, bit offset 8. Controls output level of
          "non-existing" TX pin

  - DRQ_EN: register 0x2c, bit offset 5. Controls DRQ usage for DMA.
            Not really useful as there isn't a DMA request line for
            the hardware.

Both bits are also togglable on the A31, but since actual hardware
don't support these two features, I think we can ignore them.

So it looks like for the A64 has the same IP block as the A31, in
which case we won't need the per-SoC compatible as we've done the
work to compare them.

Maxime, what do you think? And do you guys have any A10s/A13 hardware
to test the FIFO level bits?


Regards
ChenYu
