Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:54181 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750884AbeDSHuB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 03:50:01 -0400
Message-ID: <ffde372d4e8ec711743459314de35437efd218a0.camel@bootlin.com>
Subject: Re: [RFCv11 PATCH 00/29] Request API
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Thu, 19 Apr 2018 09:48:46 +0200
In-Reply-To: <CAPBb6MW9f6MPxMj9W8TMfqdhEMYZPX85w3y159sL5kQq5jjsBA@mail.gmail.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
         <CAPBb6MVLpV6gbUWBnQpYiNoWmjqdhYOhicrsetT0S5p_w28HDw@mail.gmail.com>
         <95c7bf3a-06f0-46d6-d51f-47e851180681@xs4all.nl>
         <CAPBb6MVg+3JHZC1F5qz2=ZiScnHpVD7kvouYYWOEFN3CaqFPeQ@mail.gmail.com>
         <d9fa6ca0e79672dc523e1c56ba19ec07c5d5259d.camel@bootlin.com>
         <CAPBb6MW9f6MPxMj9W8TMfqdhEMYZPX85w3y159sL5kQq5jjsBA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-+rTDw127Pw4khcOlRS9A"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-+rTDw127Pw4khcOlRS9A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 2018-04-18 at 02:06 +0000, Alexandre Courbot wrote:
> On Tue, Apr 17, 2018 at 8:41 PM Paul Kocialkowski <
> paul.kocialkowski@bootlin.com> wrote:
> On Tue, 2018-04-17 at 06:17 +0000, Alexandre Courbot wrote:
> > > On Tue, Apr 17, 2018 at 3:12 PM Hans Verkuil <hverkuil@xs4all.nl>
> > > wrote:
> > >=20
> > > > On 04/17/2018 06:33 AM, Alexandre Courbot wrote:
> > > > > On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.
> > > > > nl>
> > > > > wrote:
> > > > >=20
> > > > > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > > > > Hi all,
> > > > > > This is a cleaned up version of the v10 series (never posted
> > > > > > to
> > > > > > the list since it was messy).
> > > > >=20
> > > > > Hi Hans,
> > > > >=20
> > > > > It took me a while to test and review this, but finally have
> > > > > been
> > > > > able
> > >=20
> > > to
> > > > > do it.
> > > > >=20
> > > > > First the result of the test: I have tried porting my dummy
> > > > > vim2m
> > > > > test
> > > > > program
> > > > > (https://gist.github.com/Gnurou/34c35f1f8e278dad454b51578d239a
> > > > > 42
> > > > > for
> > > > > reference),
> > > > > and am getting a hang when trying to queue the second OUTPUT
> > > > > buffer
> > >=20
> > > (right
> > > > > after
> > > > > queuing the first request). If I move the calls the
> > > > > VIDIOC_STREAMON
> > >=20
> > > after
> > > > > the
> > > > > requests are queued, the hang seems to happen at that moment.
> > > > > Probably a
> > > > > deadlock, haven't looked in detail yet.
> > > > >=20
> > > > > I have a few other comments, will follow up per-patch.
> > > > >=20
> > > >=20
> > > > I had a similar/same (?) report about this from Paul:
> > > > https://www.mail-archive.com/linux-media@vger.kernel.org/msg1291
> > > > 77.h
> > > > tml
> > >=20
> > > I saw this and tried to move the call to STREAMON to after the
> > > requests are queued in my example program, but it then hanged
> > > there.
> > > So there is probably something more intricate taking place.
> > I figured out the issue (but forgot to report back to the list):
> > Hans'
> > version of the request API doesn't set the POLLIN bit but POLLPRI
> > instead, so you need to select for expect_fds instead of read_fds in
> > the
> > select call. That's pretty much all there is to it.
>=20
> I am not using select() but poll() in my test program (see the gist
> link
> above) and have set POLLPRI as the event to poll for. I may be missing
> something but this looks correct to me?

You're right, I overlooked your email and assumed you were hitting the
same issue that I had at first.

Anyway, I also had a similar issue when calling the STREAMON ioctl
*before* enqueuing the request. What happens here is that
v4l2_m2m_streamon (called from the ioctl) will also try to schedule a
device run (v4l2_m2m_try_schedule). When the ioctl is called and the
request was not queued yet, the lack of buffers will delay the streamon
call. Then, when the request is later submitted, vb2_streamon is called
with the queue directly, and there is no m2m-specific provision there,
so no device run is scheduled and nothing happens. If the STREAMON ioctl
happens after queuing the request, then things should be fine (but
that's definitely not what we want userspace to be doing) since
the vb2_streamon call from the ioctl handler will take effect
and v4l2_m2m_try_schedule will be called.

The way that I have solved this with the Sunxi-Cedrus driver is to add a
req_complete callback function pointer (holding a call
to v4l2_m2m_try_schedule) in media_device_ops and call it (if available)
from media_request_ioctl_queue. I initially put this in req_queue
directly, but since it is wrapped by the request queue mutex lock and
provided that device_run needs to access the request queue, we need an
extra op called out of this lock, before completing the ioctl handler.

I will be sending v2 of my driver with preliminary patches to fix this
(perhaps I should also fix vim2m that way along the way).

Cheers,

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-+rTDw127Pw4khcOlRS9A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrYSd4ACgkQ3cLmz3+f
v9EZ+wf/ZB4SBfHu2H0mu7NAUWkVNrKqMY5sU7ZAA+ToOs7PhjBkdeZLIF80EGk5
sC462WlzZXImhezcnUI0mttZwXqeYDnJZ0jk0hTpktXA+cvDWeBE3/RFb4maFiya
oi2Mlopt2vQSaUza+AMtjD365OHv42rtNGHobQLooxcL2/aYRs+++Lq5AeSsQIs2
MGFJbaUNbyoowMnltgpZny4TrnHWvrQ/fh8guvLhGAuerAbKCnXwOqY4MSaXk96K
Y6G6T5BScOrtaH7ki/OxmQcvsnI0loeNWLSHWtfntpvVWm7cknr8J6L7N5WtqRt6
TbU3pyEQMo8KyHaMsQ/LI11HOI4KYw==
=WWzc
-----END PGP SIGNATURE-----

--=-+rTDw127Pw4khcOlRS9A--
