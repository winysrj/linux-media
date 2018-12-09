Return-Path: <SRS0=qcaw=OS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130C7C67838
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 11:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3FB220865
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 11:37:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3FB220865
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ucw.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbeLILhR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 06:37:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55535 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbeLILhR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2018 06:37:17 -0500
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 916F480809; Sun,  9 Dec 2018 12:37:11 +0100 (CET)
Date:   Sun, 9 Dec 2018 12:37:14 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     shuah <shuah@kernel.org>, perex@perex.cz, tiwai@suse.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [RFC PATCH v8 1/4] media: Media Device Allocator API
Message-ID: <20181209113714.GA21784@amd>
References: <cover.1541109584.git.shuah@kernel.org>
 <e474dd16f1d6443c12b1361376193c9d0efcced6.1541109584.git.shuah@kernel.org>
 <20181119085931.GA28607@amd>
 <73c22137-9c7a-75c8-8cd1-3736c63c2d40@kernel.org>
 <20181209080944.GA7561@amd>
 <20181209092715.50a7e4e4@coco.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20181209092715.50a7e4e4@coco.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > On Thu 2018-12-06 08:33:14, shuah wrote:
> > > On 11/19/18 1:59 AM, Pavel Machek wrote: =20
> > > >On Thu 2018-11-01 18:31:30, shuah@kernel.org wrote: =20
> > > >>From: Shuah Khan <shuah@kernel.org>
> > > >>
> > > >>Media Device Allocator API to allows multiple drivers share a media=
 device.
> > > >>Using this API, drivers can allocate a media device with the shared=
 struct
> > > >>device as the key. Once the media device is allocated by a driver, =
other
> > > >>drivers can get a reference to it. The media device is released whe=
n all
> > > >>the references are released. =20
> > > >
> > > >Sounds like a ... bad idea?
> > > >
> > > >That's what new "media control" framework is for, no?
> > > >
> > > >Why do you need this? =20
> > >=20
> > > Media control framework doesn't address this problem of ownership of =
the
> > > media device when non-media drivers have to own the pipeline. In this=
 case,
> > > snd-usb owns the audio pipeline when an audio application is using the
> > > device. Without this work, media drivers won't be able to tell if snd=
-usb is
> > > using the tuner and owns the media pipeline.
> > >=20
> > > I am going to clarify this in the commit log. =20
> >=20
> > I guess I'll need the explanation, yes.
> >=20
> > How can usb soundcard use the tuner? I thought we'd always have
> > userspace component active and moving data between tuner and usb sound
> > card?
>=20
> It sounds that the description of the patch is not 100%, as it seems
> that you're not seeing the hole picture.
>=20
> This is designed to solve a very common usecase for media devices
> where one physical device (an USB stick) provides both audio
> and video.

Aha, ok, it makes sense now. Thanks!
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlwM/moACgkQMOfwapXb+vKOCACcCSevIvvLj57RR7yYVXHr54DH
emcAoK0Pb/5LFFQjUm/27hJjWMsRwkXQ
=XydS
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
