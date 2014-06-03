Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46379 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaFCOh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jun 2014 10:37:57 -0400
Message-ID: <1401806270.13385.13.camel@nicolas-tpx230>
Subject: Re: Poll and empty queues
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Date: Tue, 03 Jun 2014 10:37:50 -0400
In-Reply-To: <538D6D81.3000001@xs4all.nl>
References: <1401738463.2304.15.camel@nicolas-tpx230>
	 <538D6D81.3000001@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-jkObwYlCZIV8mSPW4mpe"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-jkObwYlCZIV8mSPW4mpe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 03 juin 2014 =C3=A0 08:38 +0200, Hans Verkuil a =C3=A9crit :
> Hi Nicholas,
>=20
> On 06/02/2014 09:47 PM, Nicolas Dufresne wrote:
> > Hi everyone,
> >=20
> > Recently in GStreamer we notice that we where not handling the POLLERR
> > flag at all. Though we found that what the code do, and what the doc
> > says is slightly ambiguous.
> >=20
> >         "When the application did not call VIDIOC_QBUF or
> >         VIDIOC_STREAMON yet the poll() function succeeds, but sets the
> >         POLLERR flag in the revents field."
> >        =20
> > In our case, we first seen this error with a capture device. How things
> > worked is that we first en-queue all allocated buffers. Our
> > interpretation was that this would avoid not calling "VIDIOC_QBUF [...]
> > yet", and only then we would call VIDIOC_STREAMON. This way, in our
> > interpretation we would never get that error.
> >=20
> > Though, this is not what the code does. Looking at videobuf2, if simply
> > return this error when the queue is empty.
> >=20
> > 	/*
> > 	 * There is nothing to wait for if no buffers have already been queued=
.
> > 	 */
> > 	if (list_empty(&q->queued_list))
> > 		return res | POLLERR;
> >=20
> > So basically, we endup in this situation where as soon as all existing
> > buffers has been dequeued, we can't rely on the driver to wait for a
> > buffer to be queued and then filled again. This basically forces us int=
o
> > adding a new user-space mechanism, to wait for buffer to come back. We
> > are wandering if this is a bug. If not, maybe it would be nice to
> > improve the documentation.
>=20
> Just for my understanding: I assume that gstreamer polls in one process o=
r
> thread and does the queuing/dequeuing in a different process/thread, is t=
hat
> correct?

Yes, in this particular case (polling with queues/thread downstream),
the streaming thread do the polling, and then push the buffers. The
buffer reach a queue element, which will queued and return. Polling
restart at this point. The queue will later pass it downstream from the
next streaming thread, and eventually the buffer will be released. For
capture device, QBUF will be called upon release.

It is assumed that this call to QBUF should take a finite amount of
time. Though, libv4l2 makes this assumption wrong by inter-locking DQBUF
and QBUF, clearly a bug, but not strictly related to this thread. Also,
as we try and avoid blocking in the DQBUF ioctl, it should not be a
problem for us.

>=20
> If it was all in one process, then it would make no sense polling for a
> buffer to become available if you never queued one.

Not exactly true, the driver may take some time before the buffer we
have queued back is filled and available again. The poll/select FD set
also have a control pipe, so we can stop the process at any moment. Not
polling would mean blocking on an ioctl() which cannot be canceled.

But, without downstream queues (thread), the size of the queue will be
negotiated so that the buffer will be released before we go back
polling. The queue will never be empty in this case.

>=20
> That is probably the reasoning behind what poll does today. That said, I'=
ve
> always thought it was wrong and that it should be replaced by something l=
ike:
>=20
> 	if (!vb2_is_streaming(q))
> 		return res | POLLERR;
>=20
> I.e.: only return an error if we're not streaming.

I think it would be easier for user space and closer to what the doc
says. Though, it's not just about changing that check, there is some
more work involved from what I've seen.

cheers,
Nicolas

--=-jkObwYlCZIV8mSPW4mpe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlON3b4ACgkQcVMCLawGqBwMAACff9ulVTVQWM+MDCWjBPODyyHB
wxUAn3AFuV9wJm0Cpy9AcwG9IEOKrC7q
=kzLN
-----END PGP SIGNATURE-----

--=-jkObwYlCZIV8mSPW4mpe--

