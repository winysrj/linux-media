Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BBF3C07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58C582084C
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:38:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u6jiCKf4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58C582084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbeLKJiM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 04:38:12 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36956 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbeLKJiM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 04:38:12 -0500
Received: by mail-ed1-f66.google.com with SMTP id h15so11947253edb.4;
        Tue, 11 Dec 2018 01:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=T65kb98BIpX2CP4CdItJ0eur3xiz6i/4W/7NxwA2E5k=;
        b=u6jiCKf4xlUoYcvsQ8Ezw/qjniqaILtiGoN03nKToCh/qvEb5bAtb7CO/KW1gO0c+5
         iVghvVEo65oV07AqCXyitRm6WdgAVe/lgGfMSSBcXTXiZqV9kCwVdLzUQfAcBUassgDu
         SIgw4Ijxy7voimGVoYKsJuO1KirUf4/8zVdFzhP1XxTZtmKc5RbCu4b87WSbht1OskxD
         wGlB+5unLYawVl1UlDU0WUZprZJZf2Ds1+cAVxHY0ndRp6h0eUoEcbiZZ0lz6LcL3aQH
         1ZDS+rMSzgfSyoOy7eCn2/4y50dg1M2qIG6WTrRzrU72ri68YZTLmINoywfNPSR1V/MH
         Y7+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T65kb98BIpX2CP4CdItJ0eur3xiz6i/4W/7NxwA2E5k=;
        b=StKBWU88oX9sdxosAd9iE1KebBE8NUEsEAhhNXRrxLLCnVKtYjVOTh5yjfwnQCqI+J
         KzCgF21DdQW+3raqKIR29s3gcUQLTVNT4SmsAyTrrJr/Wt3BXpPEb6PBFJk2yX1Nqnme
         IaFAph8KeGDMydsv8zHVYCrk0YLE6IcHMZI7gsFoL1/aWK7WdhLGTM/YJHTDQRawnHQY
         dBARKDG6S7u+q5exRjhfh/HpWUGfvDrLyFHdbLH4IRgk8VFVu8GSoh7zjA2z71UpLfio
         zkho3zyhQvGHNyxSo4cDfvODt/6zAnyG9g3AbvvVEvEx2AXurGZyB7hA8OocNX22/qqF
         EJLA==
X-Gm-Message-State: AA+aEWaD3/qgRz8r7Kzk0r5WwYnRCxvN1BANCIJiAYb3UKRHR3DmsBVg
        RiCJ46fIjnbM8TZFZnP/ufk=
X-Google-Smtp-Source: AFSGD/X77MBor2rRcDNXgXiwfq7jYabRpOIRupYMPV7WxPKMp1fL0by5zqiP6D5/f+LaBs6gfR4WOQ==
X-Received: by 2002:a17:906:2555:: with SMTP id j21-v6mr12031434ejb.103.1544521089705;
        Tue, 11 Dec 2018 01:38:09 -0800 (PST)
Received: from localhost (pD9E51040.dip0.t-ipconnect.de. [217.229.16.64])
        by smtp.gmail.com with ESMTPSA id f35sm4134936edd.80.2018.12.11.01.38.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Dec 2018 01:38:08 -0800 (PST)
Date:   Tue, 11 Dec 2018 10:38:07 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] media: tegra-cec: Support Tegra186 and Tegra194
Message-ID: <20181211093807.GA14426@ulmo>
References: <20181210160038.16122-1-thierry.reding@gmail.com>
 <643e8da6-a8ed-145a-604d-f028e501add9@xs4all.nl>
 <20181210205945.GB325@mithrandir>
 <96df2b5f-e388-b933-8823-c718290bd5e3@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <96df2b5f-e388-b933-8823-c718290bd5e3@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 11, 2018 at 10:19:48AM +0100, Hans Verkuil wrote:
> On 12/10/18 9:59 PM, Thierry Reding wrote:
> > On Mon, Dec 10, 2018 at 06:07:10PM +0100, Hans Verkuil wrote:
> >> Hi Thierry,
> >>
> >> On 12/10/18 5:00 PM, Thierry Reding wrote:
> >>> From: Thierry Reding <treding@nvidia.com>
> >>>
> >>> The CEC controller found on Tegra186 and Tegra194 is the same as on
> >>> earlier generations.
> >>
> >> Well... at least for the Tegra186 there is a problem that needs to be =
addressed first.
> >> No idea if this was solved for the Tegra194, it might be present there=
 as well.
> >>
> >> The Tegra186 hardware connected the CEC lines of both HDMI outputs tog=
ether. This is
> >> a HW bug, and it means that only one of the two HDMI outputs can use t=
he CEC block.
> >=20
> > I don't know where you got that information from, but I can't find any
> > indication of that in the documentation. My understanding is that there
> > is a single CEC block that is completely independent and it is merely a
> > decision of the board designer where to connect it. I'm not aware of any
> > boards that expose more than a single CEC.
>=20
> Sorry, my memory was not completely correct.
>=20
> The problem is that the 186 can be configured with two HDMI outputs, but =
it has
> only one CEC block. So CEC can be used for only one of the two. I checked=
 the TRM
> for the Tegra194 and that has up to four HDMI outputs, but still only one=
 CEC
> block.
>=20
> And yes, it is the responsibility for the board designer to hook up the C=
EC pin
> to only one of the outputs, but the TRM never explicitly mentions this an=
d given
> the general lack of knowledge about CEC it wouldn't surprise me at all if=
 there
> will be wrong board designs.
>=20
> But be that as it may, the core problem remains: you cannot allow multiple
> HDMI outputs to be connected to the same CEC device.
>=20
> However, I now realize that your patches will actually work fine since ea=
ch
> HDMI connector tries to get a cec notifier for its own HDMI device, but t=
he
> tegra-cec driver will only register a notifier for the HDMI device pointed
> to by the hdmi-phandle property. So only one of the HDMI devices will act=
ually
> get a working CEC.
>=20
> Although if board designers mess this up and connect multiple CEC lines to
> the same CEC pin, this would still break, but there is nothing that can be
> done about that. I still believe the TRM should have made this clear since
> it is not obvious. Even better would be to have the same number of CEC bl=
ocks
> as there are configurable HDMI outputs. Typically, if you support CEC on =
one
> HDMI output, you want to support it for all. And today that's not possible
> without adding external CEC devices (as we - Cisco - do).

I wasn't aware that anyone was using a Tegra with support for multiple
HDMI outputs. Do you have a contact that you can forward this kind of
request to? It certainly sounds like something that would be useful to
add in future chips if there's a customer need.

I can also forward this internally, but I expect it to have more weight
coming directly from Cisco. =3D)

> Apologies for the confusion, I should never send emails after 5pm :-)

No worries.

Thierry

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIyBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlwPhXwACgkQ3SOs138+
s6HBQQ/3Z8dlWVgMjUhrQM7y1Vif5mx4TZ2u7tddJWrlfQyyZsWOQSiYdqdfA+Kd
cGCKNRPZdRdaUqFS4mSIbd3vii4sLPIxcstFCan5qrMk1ibiQsSdKPHlrtXLGqEd
XYBEgF0t3mG/iNafaG8+QBWTb9FShgRusi91Qc9bzzJvrDyMsjXAZ3/bPv/BBfnO
9qPg8zcM6WEr9Q0Mkdnp/oebhsAgB2OgRd0UKGkfvB8vWJxVoyNl38xIGMGlgPP4
H46OIiulbFQnba3TIv3oRKaaci3FldYqQYgA0+R0WE+RSqpM9idjhrVZ6lswWqmO
98dgviKeM2+UBBbM+oGcmD0s5Es2Lw1DVsxeBgKQ4QaJZN5YLlvidtg4kG0HZ3+x
1EW8F2GkGo/mV0Wsq6I9QIyX9gc7khWbgvUlwf3D8crvlxno+ZoDXPlKSgBM75G1
dLwhNvVHwMF81R6oX1s+9wuY1Dwnw0t8CWfdi18jqSEb48TlQ7ibrTmloxjfjygx
6QDioRzu7UG40dBnw8HzZOtGwlH01dzZrT+BQiBh0hmqZCO2Gu4sQPiuqJUnoyCT
V+6bVw5N5Di6ag/SDvjPfweMuIHXNLrbR7l+Q3a6khJNI8tR6xfe7y0ZLGpoFKhg
T0UKrvuqQMswys+NAcdArPdaMfqqr5TeRF28FPEU/6uWQorhzw==
=nCZF
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
