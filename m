Return-path: <linux-media-owner@vger.kernel.org>
Received: from home.keithp.com ([63.227.221.253]:51722 "EHLO elaine.keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933591AbcECQDG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2016 12:03:06 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
	Grant Likely <grant.likely@secretlab.ca>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarit.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media\@vger.kernel.org linux-media"
	<linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
In-Reply-To: <CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com>
References: <20160213145317.247c63c7@lwn.net> <87y49zr74t.fsf@intel.com> <20160303071305.247e30b1@lwn.net> <20160303155037.705f33dd@recife.lan> <86egbrm9hw.fsf@hiro.keithp.com> <1457076530.13171.13.camel@winder.org.uk> <CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com> <87a8m9qoy8.fsf@intel.com> <20160308082948.4e2e0f82@recife.lan> <CAKeHnO7R25knFH07+3trdi0ZotsrEE+5ZzDZXdx33+DUW=q2Ug@mail.gmail.com> <20160308103922.48d87d9d@recife.lan> <20160308123921.6f2248ab@recife.lan> <20160309182709.7ab1e5db@recife.lan> <87fuvypr2h.fsf@intel.com> <20160310122101.2fca3d79@recife.lan> <AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de> <8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de> <20160412094620.4fbf05c0@lwn.net> <CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com> <CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com>
Date: Tue, 03 May 2016 08:54:07 -0700
Message-ID: <8660uv2l40.fsf@hiro.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Daniel Vetter <daniel.vetter@ffwll.ch> writes:

> So sphinx/rst y/n? Jon, is that ok with you from the doc maintainer
> pov?

I think the right answer for today is to use sphinx to generate docs
From=20inline comments, to encourage outline docs to give it a try but to
allow doc writers to use whatever works for them.

That will leave the media docs using the existing system so that their
tables don't get wrecked, while providing guidance to new doc writers
and allowing inline docs to include markup.

=2D-=20
=2Dkeith

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVyjJoNsiGmkAAAARAQiEHg//eauVYuPm1pGJtl5q+geJp/82vinoEy45
8yDQkxR1jgO/4L7zQceEq5g8Z0xVIWxeaxbRXz1ZVwtqbOTD78hOcuqceifO1lZH
iKs6FltmcrfN7eKFImJR01II5drnLJGIZP+tg82M+Jvix7QH83jniO6KYpyR7HXr
ielHz9mL3FbUH4VRToLh2Hc+ODNy5dcJx+dW8Erg2nxwJbu/AX4W8AOkYPXeTju+
Ol5M7b86+6wb7w+2jav5/w9NDDwZF0wTMSIsVYwL5MoBU6DHe4rVRAA379M94+R1
MRivCvXe6Hbke1uuGSh2pHk/4o6g3baR+oRMV14PUiyfr0+nkUyx8jZycLQKLY4Z
Gcv7QWfVMe06Dwou8dWk38GeftULcOeG340guHCUsVmDVKhr6zwt5vvl1b2KtBxz
3o2Had+AUZqLqduBFA6d5KcziQmX2cubbo47k9vF8MOXZsVrqAXsC0cthkfx/uDm
FXedwzDgMdd8tf8UpNVq8WQ7bXXKHKG2fnJ7CHtK0WSrn+jq9FLvVV5YKibIMEvw
FLYTuxVHKyDHdG1AwjZGaDCs9wIaY0kfA5Mcb6qJBCO9GhFUVj5lQFMltR78iLwC
l+6R+/Ar02fRYeOcnw0XhiOHaX/SxECvacRuUDKmuh+2eQsaVMj9AyGm2t58FkwY
SmpDDpoz5qE=
=vsqK
-----END PGP SIGNATURE-----
--=-=-=--
