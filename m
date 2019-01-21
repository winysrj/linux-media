Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D6EC2F441
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 16:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF09320989
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 16:17:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="ahPZ0nHa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730129AbfAUQRr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 11:17:47 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44890 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729870AbfAUQRr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 11:17:47 -0500
Received: by mail-qk1-f196.google.com with SMTP id o8so12524338qkk.11
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2019 08:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=3YaC5obh8LrRNDtRYaqTA9J53MNcL2EhkMZjfogjA60=;
        b=ahPZ0nHaUJBt/HJW2gwg1d/0gHCW2ccrlCXkaosLRfzEw+WjJ5h87iO9g7nGKzbREE
         nG/f6U8Ds6kvFeDQvMFESbPwR+aS/ZHymeEmv9lhVeOHG/VKX6fvtKxwIOfEAyu/Ot10
         Z1FdundeuxTNu4gMlc97DbN/VOV0fDSADTzCVi21kHZ19rZhpXikjzcT0GpXRxU0xrxT
         UoFyy6Qfl8l9Vm5DCYm+t17a+M3Xdi28H4CZAivU37tBDhKGu9qSYCja1tLNPl+1g7cu
         r2fWxOOY9mZpw3y1SpNSxgPy+T83aPYDE2uGlnSlhY33TiGg47M+K8AKvj+3D7hwXSAu
         m44Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=3YaC5obh8LrRNDtRYaqTA9J53MNcL2EhkMZjfogjA60=;
        b=t7SeL8i65So++iUvi/tgCvPHxcGZXg/hh74b3Clv9f+IwOkpPtCdyvfj5z+LQ4bxNt
         +qZt1rpcMhu4u0Tba7qqs92t58LfgxXK/yQo6+cpL4J95QSfNPpQgV3PQYVwgCop4DDl
         LHOUgHNzepVIWZdKD467y5DeY8LZdwNIrsYLB71eYWra2BldbKlExjw46WiXzd9mwZqU
         cOMDe1lLqO130tkqcmFfYzMZfwbY+NDMQcCJ4+NIKpq1hJEOtcm2xd2GmZmzL89/Tqlj
         bCv/ygZWEQ8W2nAMGhaRUU/WzePNWE2ar9kbff3wEmgzwKK8HFIp1vj7JQppfsyuAfAu
         YInA==
X-Gm-Message-State: AJcUukdT/SlY4m7erBvOLHxJteZnqvvOEbDdvNH3G3jh74mEv9bLjk6D
        qvb12Eph+WgEHOwmqv2hTNtncw==
X-Google-Smtp-Source: ALg8bN49SCBn/3b7+uAgCtJlWaNbC4ypXyuvKZZSu8rrPNU6X2tFlTxbsktoeEQdRwj03Ugakz0kXQ==
X-Received: by 2002:a37:9046:: with SMTP id s67mr23782148qkd.289.1548087466105;
        Mon, 21 Jan 2019 08:17:46 -0800 (PST)
Received: from tpx230-nicolas (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id 32sm76898525qto.55.2019.01.21.08.17.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 21 Jan 2019 08:17:45 -0800 (PST)
Message-ID: <26befa99cb1ddb0c36823cb573f2012d4bd98015.camel@ndufresne.ca>
Subject: Re: [PATCH v2 1/3] media: dt-bindings: media: document allegro-dvt
 bindings
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        Michael Tretter <m.tretter@pengutronix.de>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     mchehab@kernel.org, robh+dt@kernel.org, kernel@pengutronix.de,
        tfiga@chromium.org
Date:   Mon, 21 Jan 2019 11:17:43 -0500
In-Reply-To: <1548068375.3287.1.camel@pengutronix.de>
References: <20190118133716.29288-1-m.tretter@pengutronix.de>
         <20190118133716.29288-2-m.tretter@pengutronix.de>
         <1548068375.3287.1.camel@pengutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-lQPxKoB79i4VAHIKDfTM"
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-lQPxKoB79i4VAHIKDfTM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 21 janvier 2019 =C3=A0 11:59 +0100, Philipp Zabel a =C3=A9crit :
> On Fri, 2019-01-18 at 14:37 +0100, Michael Tretter wrote:
> > Add device-tree bindings for the Allegro DVT video IP core found on the
> > Xilinx ZynqMP EV family.
> >=20
> > Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
> > ---
> > Changes since v1:
> > none
> >=20
> > ---
> >  .../devicetree/bindings/media/allegro.txt     | 35 +++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/allegro.txt
> >=20
> > diff --git a/Documentation/devicetree/bindings/media/allegro.txt b/Docu=
mentation/devicetree/bindings/media/allegro.txt
> > new file mode 100644
> > index 000000000000..765f4b0c1a57
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/allegro.txt
> > @@ -0,0 +1,35 @@
> > +Device-tree bindings for the Allegro DVT video IP codecs present in th=
e Xilinx
> > +ZynqMP SoC. The IP core may either be a H.264/H.265 encoder or H.264/H=
.265
> > +decoder ip core.
> > +
> > +Each actual codec engines is controlled by a microcontroller (MCU). Ho=
st
> > +software uses a provided mailbox interface to communicate with the MCU=
. The
> > +MCU share an interrupt.
> > +
> > +Required properties:
> > +  - compatible: value should be one of the following
> > +    "allegro,al5e-1.1", "allegro,al5e": encoder IP core
> > +    "allegro,al5d-1.1", "allegro,al5d": decoder IP core
> > +  - reg: base and length of the memory mapped register region and base=
 and
> > +    length of the memory mapped sram
> > +  - reg-names: must include "regs" and "sram"
> > +  - interrupts: shared interrupt from the MCUs to the processing syste=
m
> > +  - interrupt-names: "vcu_host_interrupt"
> > +
> > +Example:
> > +	al5e: al5e@a0009000 {
>=20
> Should the node names be "vpu" or "video-codec"?

Xilinx calls this IP the "vcu", so "vpu" would be even more confusing.
Was this just a typo ? That being said, is this referring to the actual
HW or the firmware that runs on a microblaze (the firmware being
Allegro specific) ?

>=20
> > +		compatible =3D "allegro,al5e";
> > +		reg =3D <0 0xa0009000 0 0x1000>,
> > +		      <0 0xa0000000 0 0x8000>;
> > +		reg-names =3D "regs", "sram";
> > +		interrupt-names =3D "vcu_host_interrupt";
> > +		interrupts =3D <0 96 4>;
> > +	};
> > +	al5d: al5d@a0029000 {
> > +		compatible =3D "allegro,al5d";
> > +		reg =3D <0 0xa0029000 0 0x1000>,
> > +		      <0 0xa0020000 0 0x8000>;
> > +		reg-names =3D "regs", "sram";
> > +		interrupt-names =3D "vcu_host_interrupt";
> > +		interrupts =3D <0 96 4>;
> > +	};
>=20
> regards
> Philipp

--=-lQPxKoB79i4VAHIKDfTM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXEXwpwAKCRBxUwItrAao
HOxvAJ9u6EA5OXi54w54InkgrTzEnra5EQCgvjCgJtcdd55aViXVaME0Y4dcekI=
=JHsK
-----END PGP SIGNATURE-----

--=-lQPxKoB79i4VAHIKDfTM--

