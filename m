Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D60CC169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 21:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF09C20882
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 21:41:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="vfYGx4D6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbfA2Vlk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 16:41:40 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35206 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfA2Vlk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 16:41:40 -0500
Received: by mail-qt1-f193.google.com with SMTP id v11so24065210qtc.2
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 13:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=p8xnOvZSHMvDSgZGAc1wzQUwKncdi8WTrdqxIvluZ0o=;
        b=vfYGx4D6OZSneIa7NZOJF9VhGjHOCtSSkHQyiAvEeG4tFMUixTqqEVi5FzWSUxFiFp
         rg0/BVEs/WVS/SPPolQsI/UwEMXfc/FVCxrXW9W0SgM2jluoSUHazATW5bGRAvkRGMOp
         vM6vXENljThoz2uzjjCqj4puk3H9QKpEx22Z4lzi5tzczZC0NO5Hasbm00Ar5T74iZjr
         BW3BKxE0V85uSntDWII+gx1LClNcqmW4/0QLFE9bfIoRrQ/Ty2jynf47P/KwJ741iVCN
         7Oaf3VpNFfZ5DhGiVwj74XN9XBNi7co9RzeOwVtSZGNM+0weTI6+kDfe4yw8msHu4dzN
         bIIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=p8xnOvZSHMvDSgZGAc1wzQUwKncdi8WTrdqxIvluZ0o=;
        b=OHAFxjzNbJdXQlDMSIr1BkKAqEoUQzRO5GUS0D4EsrFBeM9oB67iw1isBCR20sJA7B
         6SLdElQEApOmLfgaemp/Dh5QGd8Yq4m9nm5V2WU0gt6PJMMcTBTXRFuYraN8c9XeWreW
         PfnXg6Z6pV3tc6oNX9QMJxIzpXkf6cjhgmJWzQzzi+a6/gCcRjtw+Lx1iiWbeafOlp1Y
         68eeVNPskUbVdBlo7XyyL5irwLFn0k6ojTtcc6EuToUcaPsJHyR+HkLvr0MdV6CNmO0a
         KPQz0nAJ66/04/++Ofmv+SJXRWv6pRNNQLh7nnn8WhsTPBSgHqGMlm8R6TDmYbI1dsNP
         2k7w==
X-Gm-Message-State: AJcUukfATXN4HckvX7FlerAg9UB6P2HUF1cKPXQarZiC356ucnUgIEsQ
        JPj6NblDTmgZu6i291IJbxzisg==
X-Google-Smtp-Source: ALg8bN60yPISFL3544dT/MqkG6QDr9VICZrPdWezny+OX7W1Ga8ij8CSzpschO4sUxnVEu3jJff5pw==
X-Received: by 2002:a0c:d792:: with SMTP id z18mr26408815qvi.183.1548798098924;
        Tue, 29 Jan 2019 13:41:38 -0800 (PST)
Received: from tpx230-nicolas.collaboramtl (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id r47sm84192955qtc.77.2019.01.29.13.41.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jan 2019 13:41:38 -0800 (PST)
Message-ID: <2442b23d3b0a00c1bd441298a712888e016acf92.camel@ndufresne.ca>
Subject: Re: [linux-sunxi] [PATCH v2 1/2] media: v4l: Add definitions for
 the HEVC slice format and controls
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Alexandre Courbot <acourbot@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     Ayaka <ayaka@soulik.info>, Randy Li <randy.li@rock-chips.com>,
        Jernej =?UTF-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-rockchip@lists.infradead.org
Date:   Tue, 29 Jan 2019 16:41:35 -0500
In-Reply-To: <CAPBb6MUJu3cX9A-E32bSSjxc1cvGP83ayzZzUxa5_QMf6niK4g@mail.gmail.com>
References: <20181123130209.11696-1-paul.kocialkowski@bootlin.com>
         <20181123130209.11696-2-paul.kocialkowski@bootlin.com>
         <5515174.7lFZcYkk85@jernej-laptop>
         <ffe9c81db34b599f675ca5bbf02de360bf0a1608.camel@bootlin.com>
         <776e63c9-d4a5-342a-e0f7-200ef144ffc4@rock-chips.com>
         <64c793e08d61181b78125b3956ec38623fa5d261.camel@bootlin.com>
         <D8005130-F7FD-4CBD-8396-1BB08BB08E81@soulik.info>
         <f982ef378a8ade075bc7077b93640e20ecebf9f4.camel@bootlin.com>
         <82FA0C3F-BC54-4D89-AECB-90D81B89B1CE@soulik.info>
         <c3619a00-17e7-fb92-a427-a7478b96f356@soulik.info>
         <bdf14f97e98f2fd06307545ab9038ac3c2086ae7.camel@bootlin.com>
         <42520087-4EAE-4F7F-BCA0-42E422170E91@soulik.info>
         <ab8ca098ad60f209fe97f79bb93b2d1e898da524.camel@bootlin.com>
         <CAPBb6MUJu3cX9A-E32bSSjxc1cvGP83ayzZzUxa5_QMf6niK4g@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-2kunDr+ALQ68ZYgOww0f"
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-2kunDr+ALQ68ZYgOww0f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 29 janvier 2019 =C3=A0 16:44 +0900, Alexandre Courbot a =C3=A9crit=
 :
> On Fri, Jan 25, 2019 at 10:04 PM Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> > Hi,
> >=20
> > On Thu, 2019-01-24 at 20:23 +0800, Ayaka wrote:
> > > Sent from my iPad
> > >=20
> > > > On Jan 24, 2019, at 6:27 PM, Paul Kocialkowski <paul.kocialkowski@b=
ootlin.com> wrote:
> > > >=20
> > > > Hi,
> > > >=20
> > > > > On Thu, 2019-01-10 at 21:32 +0800, ayaka wrote:
> > > > > I forget a important thing, for the rkvdec and rk hevc decoder, i=
t would
> > > > > requests cabac table, scaling list, picture parameter set and ref=
erence
> > > > > picture storing in one or various of DMA buffers. I am not talkin=
g about
> > > > > the data been parsed, the decoder would requests a raw data.
> > > > >=20
> > > > > For the pps and rps, it is possible to reuse the slice header, ju=
st let
> > > > > the decoder know the offset from the bitstream bufer, I would sug=
gest to
> > > > > add three properties(with sps) for them. But I think we need a me=
thod to
> > > > > mark a OUTPUT side buffer for those aux data.
> > > >=20
> > > > I'm quite confused about the hardware implementation then. From wha=
t
> > > > you're saying, it seems that it takes the raw bitstream elements ra=
ther
> > > > than parsed elements. Is it really a stateless implementation?
> > > >=20
> > > > The stateless implementation was designed with the idea that only t=
he
> > > > raw slice data should be passed in bitstream form to the decoder. F=
or
> > > > H.264, it seems that some decoders also need the slice header in ra=
w
> > > > bitstream form (because they take the full slice NAL unit), see the
> > > > discussions in this thread:
> > > > media: docs-rst: Document m2m stateless video decoder interface
> > >=20
> > > Stateless just mean it won=E2=80=99t track the previous result, but I=
 don=E2=80=99t
> > > think you can define what a date the hardware would need. Even you
> > > just build a dpb for the decoder, it is still stateless, but parsing
> > > less or more data from the bitstream doesn=E2=80=99t stop a decoder b=
ecome a
> > > stateless decoder.
> >=20
> > Yes fair enough, the format in which the hardware decoder takes the
> > bitstream parameters does not make it stateless or stateful per-se.
> > It's just that stateless decoders should have no particular reason for
> > parsing the bitstream on their own since the hardware can be designed
> > with registers for each relevant bitstream element to configure the
> > decoding pipeline. That's how GPU-based decoder implementations are
> > implemented (VAAPI/VDPAU/NVDEC, etc).
> >=20
> > So the format we have agreed on so far for the stateless interface is
> > to pass parsed elements via v4l2 control structures.
> >=20
> > If the hardware can only work by parsing the bitstream itself, I'm not
> > sure what the best solution would be. Reconstructing the bitstream in
> > the kernel is a pretty bad option, but so is parsing in the kernel or
> > having the data both in parsed and raw forms. Do you see another
> > possibility?
>=20
> Is reconstructing the bitstream so bad? The v4l2 controls provide a
> generic interface to an encoded format which the driver needs to
> convert into a sequence that the hardware can understand. Typically
> this is done by populating hardware-specific structures. Can't we
> consider that in this specific instance, the hardware-specific
> structure just happens to be identical to the original bitstream
> format?

At maximum allowed bitrate for let's say HEVC (940MB/s iirc), yes, it
would be really really bad. In GStreamer project we have discussed for
a while (but have never done anything about) adding the ability through
a bitmask to select which part of the stream need to be parsed, as
parsing itself was causing some overhead. Maybe similar thing applies,
though as per our new design, it's the fourcc that dictate the driver
behaviour, we'd need yet another fourcc for drivers that wants the full
bitstream (which seems odd if you have already parsed everything, I
think this need some clarification).

>=20
> I agree that this is not strictly optimal for that particular
> hardware, but such is the cost of abstractions, and in this specific
> case I don't believe the cost would be particularly high?

--=-2kunDr+ALQ68ZYgOww0f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXFDIjwAKCRBxUwItrAao
HMH7AJ9In4tsGt+ueK2AiiooucvNAJ+86QCdFysjbjVAgW9gD81I6i2cYXI9afk=
=CPiw
-----END PGP SIGNATURE-----

--=-2kunDr+ALQ68ZYgOww0f--

