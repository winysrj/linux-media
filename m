Return-Path: <SRS0=yUb4=PN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D905C43387
	for <linux-media@archiver.kernel.org>; Sat,  5 Jan 2019 15:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D35882085A
	for <linux-media@archiver.kernel.org>; Sat,  5 Jan 2019 15:09:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uYGpwF8L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbfAEPJn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 5 Jan 2019 10:09:43 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46435 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfAEPJn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2019 10:09:43 -0500
Received: by mail-pf1-f193.google.com with SMTP id c73so19673775pfe.13;
        Sat, 05 Jan 2019 07:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aDyU9vLBXKdK2v/2uqJ6XoS4sWAqaAzy5gcVfcR5DZo=;
        b=uYGpwF8LrKHB6d0eLYNVblUrG2M6bkItztBiGoigXQu0QCqJDqP0Nwy4gg46XpzkV8
         cQecn7+MRgm/Ta1f6z2JuihJ/QYLbXrBxeu/25E0hOhQ4UvFePRljL2siY5h9OQSlrpW
         qXAbRV/fj6WmHdy/r/B9vPhmUc4k1MAuL5/pUHFWKi08LZ5h61uwPpNLghvKOx1OzhuZ
         YHA/2OL3dLgzGsZPPN8TZ0wpyCkQN6NiklcU2BMML1NKdMVpxRGarvgIWj7K7CI/3wyE
         9mHcU0w/L7ns4RU+CtWnRxmkraIJN+gZvVHlLDB+dhpjvyNXf+B5gKJxBwaJryu2He+x
         xNJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aDyU9vLBXKdK2v/2uqJ6XoS4sWAqaAzy5gcVfcR5DZo=;
        b=ksqXQkZmyGjwA3bavNkmaul+oO77tzeWdpNAx1X0lskeqSF5ElhKynaGgj4qTD5ykN
         2xX2+I9EUEEHZVebes9BlC2L1ss6RXq0qXYxnDVese8fhEnkyW2ceXNXqAd92V5d7YHZ
         ymeoVXthzi+HJENU2fW19vXZs11D0j9qs9pOZVfbQnhj2fG9x2Ivx/5IVrRLZX7SgPHy
         2luYfuWPmx54ioURblXQPSUQX+k8M8ZrPbmpdNc/wMEsCv0fJLCV3dTUG6R0993vnT4m
         SzSX8mR//GruuxjlaP1BVV0mj1Qty16pQUzyVdtOd//7jd5W7pkl4BR6W0sOagX0R4o/
         L91g==
X-Gm-Message-State: AJcUukeNy5fMCIa7cMFob+sMep8/8nmgb0Ek3JyMkf73jN32peaYpmx7
        aUPFMyllG4snnrbRvbd328qSD2spfZQ0mUrwrW0=
X-Google-Smtp-Source: ALg8bN7pKDCubOgbl4G2EfY2aAvaMX7I1G1CQSgqnG1wS+WExAcN+F5o6yyjAf9mPUOle3210gXt2P1p91utvfijl3M=
X-Received: by 2002:a63:2b01:: with SMTP id r1mr5060491pgr.432.1546700981947;
 Sat, 05 Jan 2019 07:09:41 -0800 (PST)
MIME-Version: 1.0
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
 <1545498774-11754-3-git-send-email-akinobu.mita@gmail.com> <20190103211240.GA31467@bogus>
In-Reply-To: <20190103211240.GA31467@bogus>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Sun, 6 Jan 2019 00:09:30 +0900
Message-ID: <CAC5umyh69A2ugGKv1cvT1okgzdbLyoS05vj1gA84ganLPaq50Q@mail.gmail.com>
Subject: Re: [PATCH 02/12] media: i2c: mt9m001: dt: add binding for mt9m001
To:     Rob Herring <robh@kernel.org>
Cc:     linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

2019=E5=B9=B41=E6=9C=884=E6=97=A5(=E9=87=91) 6:12 Rob Herring <robh@kernel.=
org>:
>
> On Sun, Dec 23, 2018 at 02:12:44AM +0900, Akinobu Mita wrote:
> > Add device tree binding documentation for the MT9M001 CMOS image sensor=
.
> >
> > Cc: Rob Herring <robh@kernel.org>
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> >  .../devicetree/bindings/media/i2c/mt9m001.txt      | 37 ++++++++++++++=
++++++++
> >  1 file changed, 37 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9m001=
.txt
> >
> > diff --git a/Documentation/devicetree/bindings/media/i2c/mt9m001.txt b/=
Documentation/devicetree/bindings/media/i2c/mt9m001.txt
> > new file mode 100644
> > index 0000000..794b787
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/i2c/mt9m001.txt
> > @@ -0,0 +1,37 @@
> > +MT9M001: 1/2-Inch Megapixel Digital Image Sensor
> > +
> > +The MT9M001 is an SXGA-format with a 1/2-inch CMOS active-pixel digita=
l
> > +image sensor. It is programmable through a simple two-wire serial
> > +interface.
>
> I2C?

Sounds good.

> > +
> > +Required Properties:
> > +
> > +- compatible: shall be "onnn,mt9m001".
> > +- clocks: reference to the master clock into sensor
> > +
> > +Optional Properties:
> > +
> > +- reset-gpios: GPIO handle which is connected to the reset pin of the =
chip.
> > +  Active low.
> > +- standby-gpios: GPIO handle which is connected to the standby pin of =
the chip.
> > +  Active high.
> > +
> > +For further reading on port node refer to
> > +Documentation/devicetree/bindings/media/video-interfaces.txt.
>
> You still need to state how many ports/endpoints and what they are.

I'll write the following description that is copied from
Documentation/devicetree/bindings/media/i2c/mt9m111.txt.

"The device node must contain one 'port' child node with one 'endpoint' chi=
ld
sub-node for its digital output video port, in accordance with the video
interface bindings defined in:
Documentation/devicetree/bindings/media/video-interfaces.txt"

> > +
> > +Example:
> > +
> > +     &i2c1 {
> > +             mt9m001@5d {
>
> camera-sensor@5d

OK.

> > +                     compatible =3D "onnn,mt9m001";
> > +                     reg =3D <0x5d>;
> > +                     reset-gpios =3D <&gpio0 0 GPIO_ACTIVE_LOW>;
> > +                     standby-gpios =3D <&gpio0 1 GPIO_ACTIVE_HIGH>;
> > +                     clocks =3D <&camera_clk>;
> > +                     port {
> > +                             mt9m001_out: endpoint {
> > +                                     remote-endpoint =3D <&vcap_in>;
> > +                             };
> > +                     };
> > +             };
> > +     };
> > --
> > 2.7.4
> >
