Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0466C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B60F42083D
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:43:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P7Z2bOQK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B60F42083D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbeLGLnT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 06:43:19 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36443 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbeLGLnS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 06:43:18 -0500
Received: by mail-lf1-f65.google.com with SMTP id a16so2812710lfg.3;
        Fri, 07 Dec 2018 03:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ODQEtnuCJlRKrXxoW3vcIw2UtuLeOooXtxQ4nUHkzx0=;
        b=P7Z2bOQKsbu0+25gJ4AbwnQodlagZ2k4ilQraww4TvAloSVpeAziS7rjTynV8QQE6n
         wTB1U+sspWSm8Mm5dffMh/2WzRugZtquZTXiGJcWMLA+a2FCLvV73IInqjTIURsGKlfH
         4dAVnxVpf5QYR5bwI3ziemZsvZA5WNGZJdZBfSLqW9127VlsgoXOgKGG0Fou2v+1TiZj
         rL42Ah5Zd5vMLuWq3OlzxpZOtxMgsHXE7fyfADs7C/g2H88dWC8Z7vjDYLISE11irGbJ
         dmQRq77zRM7VjdHTZQVW59XT1PttcW0651pLa/5BG5N68ahaZnj1ZCU5sqRasD5WS/Rc
         KvFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ODQEtnuCJlRKrXxoW3vcIw2UtuLeOooXtxQ4nUHkzx0=;
        b=TUitLIkAHMea/5rVPlA7nwSv71XEbtMcujCMSVI5gyE8RQWfQ6v43PmKWDPQjFOE0N
         qZLd6VhPUBPabDng8KETPIaYR/qWfUXAOLuzSUv/6304ssPZXOBlMbDZzdO2Y55APoiu
         A7qHQie7htvysL+Ib0O7jBk5T1x+P+Fv0bZNI2rKMRQiAFXFoTGx+r/+9f/lrYMJXymZ
         In48QqL4itQj9nxv6Oo6YL1I0/bMkFeR9NN2IxZCWstaQQsEaorQ+GZvwvDEZzNLHJzM
         Hfd+RKgeIbrSJnE+/mSOgpubzXUl3n6MtWs1DUfOmTJF/vktd7S5ewX9UAVvcL9j6+sH
         BsyA==
X-Gm-Message-State: AA+aEWZy66Nh4pIPVs3SGOVWkwz5UsEJ9eRWpzRF1GPO9E+7y629cc+6
        DJPujdLvlTmZlqv1LkZ+cVw=
X-Google-Smtp-Source: AFSGD/UoV6BSNAAK6fMSBsGXsyl0T7xoQ0CUkbTQPUQn0Hv6Uam1SdDWbuof4Vm56IBceMstfMUUiw==
X-Received: by 2002:a19:4d8d:: with SMTP id a135mr1201523lfb.80.1544182996267;
        Fri, 07 Dec 2018 03:43:16 -0800 (PST)
Received: from acerlaptop.localnet ([2a02:a315:5445:5300:74d5:51ba:2673:f3f4])
        by smtp.gmail.com with ESMTPSA id e13-v6sm528954ljk.53.2018.12.07.03.43.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Dec 2018 03:43:15 -0800 (PST)
From:   =?utf-8?B?UGF3ZcWC?= Chmiel <pawel.mikolaj.chmiel@gmail.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        fischerdouglasc@gmail.com, keescook@chromium.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/5] media: dt-bindings: Add binding for si470x radio
Date:   Fri, 07 Dec 2018 12:43:14 +0100
Message-ID: <2202435.V78jBJhvEB@acerlaptop>
In-Reply-To: <2c8bb6ef-5f37-69ef-6829-a9e9ad04579b@xs4all.nl>
References: <20181205154750.17996-1-pawel.mikolaj.chmiel@gmail.com> <20181205154750.17996-3-pawel.mikolaj.chmiel@gmail.com> <2c8bb6ef-5f37-69ef-6829-a9e9ad04579b@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Dnia pi=C4=85tek, 7 grudnia 2018 12:33:10 CET Hans Verkuil pisze:
> Please combine 2/5 with 5/5. No need to have two patches for these bindin=
gs.
I though that it will be better to separate patches which just adds devicet=
ree support
and those adding new functionality (reset), so for example if there is more=
 work needed on one of them,
the second one can still be picked (devicetree one).

Ok will do this in next version of patchset.
=20
>=20
> Regards,
>=20
> 	Hans
>=20
> On 12/05/2018 04:47 PM, Pawe=C5=82 Chmiel wrote:
> > Add device tree bindings for si470x family radio receiver driver.
> >=20
> > Signed-off-by: Pawe=C5=82 Chmiel <pawel.mikolaj.chmiel@gmail.com>
> > ---
> >  .../devicetree/bindings/media/si470x.txt      | 24 +++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/si470x.txt
> >=20
> > diff --git a/Documentation/devicetree/bindings/media/si470x.txt b/Docum=
entation/devicetree/bindings/media/si470x.txt
> > new file mode 100644
> > index 000000000000..9294fdfd3aae
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/si470x.txt
> > @@ -0,0 +1,24 @@
> > +* Silicon Labs FM Radio receiver
> > +
> > +The Silicon Labs Si470x is family of FM radio receivers with receive p=
ower scan
> > +supporting 76-108 MHz, programmable through an I2C interface.
> > +Some of them includes an RDS encoder.
> > +
> > +Required Properties:
> > +- compatible: Should contain "silabs,si470x"
> > +- reg: the I2C address of the device
> > +
> > +Optional Properties:
> > +- interrupts : The interrupt number
> > +
> > +Example:
> > +
> > +&i2c2 {
> > +        si470x@63 {
> > +                compatible =3D "silabs,si470x";
> > +                reg =3D <0x63>;
> > +
> > +                interrupt-parent =3D <&gpj2>;
> > +                interrupts =3D <4 IRQ_TYPE_EDGE_FALLING>;
> > +        };
> > +};
> >=20
>=20
>=20




