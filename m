Return-Path: <SRS0=KeAI=PK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19AD2C43612
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 19:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF2CD218DE
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 19:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfABTBQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 2 Jan 2019 14:01:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48688 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728395AbfABTBQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Jan 2019 14:01:16 -0500
Received: from office.codethink.co.uk ([148.252.241.226] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1gellM-0002FH-Ko; Wed, 02 Jan 2019 19:01:08 +0000
Received: from ben by deadeye with local (Exim 4.91)
        (envelope-from <ben@decadent.org.uk>)
        id 1gellM-0006bN-1k; Wed, 02 Jan 2019 19:01:08 +0000
Message-ID: <ae0bc57fad9bf7db15b9b3943dd5bb093a9d386d.camel@decadent.org.uk>
Subject: Re: [PATCH v3.16 2/2] v4l: event: Add subscription to list before
 calling "add" operation
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org,
        "for 4.14 and up" <stable@vger.kernel.org>
Date:   Wed, 02 Jan 2019 19:01:03 +0000
In-Reply-To: <20181108120350.17266-3-sakari.ailus@linux.intel.com>
References: <20181108120350.17266-1-sakari.ailus@linux.intel.com>
         <20181108120350.17266-3-sakari.ailus@linux.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-qHRfDUuyAE4UTEbXvWnX"
User-Agent: Evolution 3.30.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 148.252.241.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-qHRfDUuyAE4UTEbXvWnX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-11-08 at 14:03 +0200, Sakari Ailus wrote:
> [ upstream commit 92539d3eda2c090b382699bbb896d4b54e9bdece ]
>=20
> Patch ad608fbcf166 changed how events were subscribed to address an issue
> elsewhere. As a side effect of that change, the "add" callback was called
> before the event subscription was added to the list of subscribed events,
> causing the first event queued by the add callback (and possibly other
> events arriving soon afterwards) to be lost.
>=20
> Fix this by adding the subscription to the list before calling the "add"
> callback, and clean up afterwards if that fails.
[...]

I've queued this up for the next update, thanks.

Ben.

--=20
Ben Hutchings
Absolutum obsoletum. (If it works, it's out of date.) - Stafford Beer



--=-qHRfDUuyAE4UTEbXvWnX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlwtCm8ACgkQ57/I7JWG
EQm8lA/+MsQoeOOzqZnnRlBGacKSAdd7PaVxCQ1rwH7o/GVLmUmBCKe3CSAtgbvw
ccvZXGjZoPmB3x0eKIfDXsJ00vDWxRFtmnxuhuZKLzinx0gRy8yb+23doc+vhxqZ
D91bL0q6xlc/BdmDdn/cVc//UvDA1xi7Llkq2R3zRn5yPUxgFpbVe13PO9sB0Iw9
Z6swsQadiyNZjgDiORB/KFzZYenvaTQU1SDE7HGdF7BTKEXA21Bf+aL5aCshSpeF
UP0espUVqyjX3ajuakEOBjCzhl+remRyvfgmmBS8jp4fxT+69ca1UphIW4BE7oLP
RuXpk88+hULfAe9kF1QqAdtW07+WWENy+GpnptTe05VA4d28Uap8uzickw5N1Zlr
7K+YnhDvKC6T8G5yCwTJdLAu353pMLVLLI8yXwsr01QZcL5BZwbgcSo1fzW5vh96
6T0ffwoR3kFB3KxLrJtp0SQC/UvDXXqcxdBUUkf1xmAvhQflHcI7ISvU54zAj4fS
WKgf7zTmONVvjOSiYFSr1edorYEC3ZC70/tHLQUeAIdXlMrWqCjjUEs5wv0LoUg3
953YTEXLFuE7nwO9ya87T/DRVzZzOiWNDjWpucld2eXMNcA5qLnCAMHgGaN6c3Qg
QgNk8oQJCzG31cViyldK0WruTsZm4Mx3uxxdI0B6JLKWfIgzMGc=
=8il0
-----END PGP SIGNATURE-----

--=-qHRfDUuyAE4UTEbXvWnX--
