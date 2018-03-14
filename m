Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52449 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751478AbeCNN1S (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Mar 2018 09:27:18 -0400
Message-ID: <1521033957.1130.5.camel@bootlin.com>
Subject: Re: [RFCv4,19/21] media: vim2m: add request support
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Date: Wed, 14 Mar 2018 14:25:57 +0100
In-Reply-To: <CAPBb6MWAXjCWJB6x-osFKZ-wGzMiucL6oa1ZHEzTgscpJTs35Q@mail.gmail.com>
References: <20180220044425.169493-20-acourbot@chromium.org>
         <1520440654.1092.15.camel@bootlin.com>
         <CAPBb6MUeUaHZj9y1N7wJk9yS8QL+zTqWCGvujcKCY0YpdeiyWg@mail.gmail.com>
         <1520606128.15946.22.camel@bootlin.com>
         <CAPBb6MWAXjCWJB6x-osFKZ-wGzMiucL6oa1ZHEzTgscpJTs35Q@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-kKPa2jGKCmzG1Wx2TdNo"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-kKPa2jGKCmzG1Wx2TdNo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 2018-03-13 at 19:24 +0900, Alexandre Courbot wrote:
> On Fri, Mar 9, 2018 at 11:35 PM, Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> > Hi,
> >=20
> > On Thu, 2018-03-08 at 22:48 +0900, Alexandre Courbot wrote:
> > > Hi Paul!
> > >=20
> > > Thanks a lot for taking the time to try this! I am also working on
> > > getting it to work with an actual driver, but you apparently found
> > > rough edges that I missed.
> > >=20
> > > On Thu, Mar 8, 2018 at 1:37 AM, Paul Kocialkowski
> > > <paul.kocialkowski@bootlin.com> wrote:
> > > > On Tue, 2018-02-20 at 13:44 +0900, Alexandre Courbot wrote:

[...]

> > > > > +static int vim2m_request_submit(struct media_request *req,
> > > > > +                             struct media_request_entity_data
> > > > > *_data)
> > > > > +{
> > > > > +     struct v4l2_request_entity_data *data;
> > > > > +
> > > > > +     data =3D to_v4l2_entity_data(_data);
> > > >=20
> > > > We need to call v4l2_m2m_try_schedule here so that m2m
> > > > scheduling
> > > > can
> > > > happen when only 2 buffers were queued and no other action was
> > > > taken
> > > > from usespace. In that scenario, m2m scheduling currently
> > > > doesn't
> > > > happen.
> > >=20
> > > I don't think I understand the sequence of events that results in
> > > v4l2_m2m_try_schedule() not being called. Do you mean something
> > > like:
> > >=20
> > > *
> > > * QBUF on output queue with request set
> > > * QBUF on capture queue
> > > * SUBMIT_REQUEST
> > >=20
> > > ?
> > >=20
> > > The call to vb2_request_submit() right after should trigger
> > > v4l2_m2m_try_schedule(), since the buffers associated to the
> > > request
> > > will enter the vb2 queue and be passed to the m2m framework, which
> > > will then call v4l2_m2m_try_schedule(). Or maybe you are thinking
> > > about a different sequence of events?
> >=20
> > This is indeed the sequence of events that I'm seeing, but the
> > scheduling call simply did not happen on vb2_request_submit. I
> > suppose I will need to investigate some more to find out exactly
> > why.
> >=20
> > IIRC, the m2m qbuf function is called (and fails to schedule) when
> > the
> > ioctl happens, not when the task is submitted.
> >=20
> > This issue is seen with vim2m as well as the rencently-submitted
> > sunxi-
> > cedrus driver (with the in-driver calls to v4l2_m2m_try_schedule
> > removed, obviously). If needs be, I could provide a standalone test
> > program to reproduce it.
>=20
> If you have a standalone program that can reproduce this on vim2m,
> then I would like to see it indeed, if only to understand what I have
> missed.

You can find the test file for this use case at:
https://gist.github.com/paulkocialkowski/4cfa350e1bbe8e3bf714480bba83ea72

Cheers!

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-kKPa2jGKCmzG1Wx2TdNo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlqpIuUACgkQ3cLmz3+f
v9FDWQf7BtBZSTrUfQdirubgIqDKOoTvi9oc+HCcKeojGitjab05rVnb9URxuvdN
n3+sCRegHw3zOYZpjUFegoSF+jobD7Y+mFjgPrZ+FI+GFbG9zlnIyfwXY4sYeq2l
+sdusBZxvI8GftkHB2AsLvOOcKf843rxuDI7f6opSWThxojEZtTmrCv+AV1eGfMD
tz2fu9cgZlPzFzqEg7grHK2AlzVwIvpOHL1B87goTMcAoV6VesyW/xtJM+4ilZEC
gHXZZUTw/grK2tJYijg97Wi24fMSpuybRq3znMBQQ2tkigWgBDgHsU4tU/9g6KO7
ZE7UpkzjdZbKabmS68kvWfFwQ7tG5Q==
=XD47
-----END PGP SIGNATURE-----

--=-kKPa2jGKCmzG1Wx2TdNo--
