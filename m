Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46494 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbaFCRj7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jun 2014 13:39:59 -0400
Message-ID: <1401817194.13385.49.camel@nicolas-tpx230>
Subject: Re: Poll and empty queues
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Date: Tue, 03 Jun 2014 13:39:54 -0400
In-Reply-To: <1715728.xzx1A1Sk00@avalon>
References: <1401738463.2304.15.camel@nicolas-tpx230>
	 <538D6D81.3000001@xs4all.nl> <1401806270.13385.13.camel@nicolas-tpx230>
	 <1715728.xzx1A1Sk00@avalon>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Ly83mq0d+9QUKwq74Zax"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-Ly83mq0d+9QUKwq74Zax
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 03 juin 2014 =C3=A0 18:11 +0200, Laurent Pinchart a =C3=A9crit :
> Hi Nicolas,
>=20
> On Tuesday 03 June 2014 10:37:50 Nicolas Dufresne wrote:
> > Le mardi 03 juin 2014 =C3=A0 08:38 +0200, Hans Verkuil a =C3=A9crit :
> > > On 06/02/2014 09:47 PM, Nicolas Dufresne wrote:
> > > > Hi everyone,
> > > >=20
> > > > Recently in GStreamer we notice that we where not handling the POLL=
ERR
> > > > flag at all. Though we found that what the code do, and what the do=
c
> > > > says is slightly ambiguous.
> > > >=20
> > > >         "When the application did not call VIDIOC_QBUF or
> > > >         VIDIOC_STREAMON yet the poll() function succeeds, but sets =
the
> > > >         POLLERR flag in the revents field."
> > > >=20
> > > > In our case, we first seen this error with a capture device. How th=
ings
> > > > worked is that we first en-queue all allocated buffers. Our
> > > > interpretation was that this would avoid not calling "VIDIOC_QBUF [=
...]
> > > > yet", and only then we would call VIDIOC_STREAMON. This way, in our
> > > > interpretation we would never get that error.
> > > >=20
> > > > Though, this is not what the code does. Looking at videobuf2, if si=
mply
> > > > return this error when the queue is empty.
> > > >=20
> > > > /*
> > > >  * There is nothing to wait for if no buffers have already been que=
ued.
> > > >  */
> > > > if (list_empty(&q->queued_list))
> > > > 	return res | POLLERR;
> > > >=20
> > > > So basically, we endup in this situation where as soon as all exist=
ing
> > > > buffers has been dequeued, we can't rely on the driver to wait for =
a
> > > > buffer to be queued and then filled again. This basically forces us=
 into
> > > > adding a new user-space mechanism, to wait for buffer to come back.=
 We
> > > > are wandering if this is a bug. If not, maybe it would be nice to
> > > > improve the documentation.
> > >=20
> > > Just for my understanding: I assume that gstreamer polls in one proce=
ss or
> > > thread and does the queuing/dequeuing in a different process/thread, =
is
> > > that correct?
> >=20
> > Yes, in this particular case (polling with queues/thread downstream),
> > the streaming thread do the polling, and then push the buffers. The
> > buffer reach a queue element, which will queued and return. Polling
> > restart at this point. The queue will later pass it downstream from the
> > next streaming thread, and eventually the buffer will be released. For
> > capture device, QBUF will be called upon release.
> >=20
> > It is assumed that this call to QBUF should take a finite amount of
> > time. Though, libv4l2 makes this assumption wrong by inter-locking DQBU=
F
> > and QBUF, clearly a bug, but not strictly related to this thread. Also,
> > as we try and avoid blocking in the DQBUF ioctl, it should not be a
> > problem for us.
> >=20
> > > If it was all in one process, then it would make no sense polling for=
 a
> > > buffer to become available if you never queued one.
> >=20
> > Not exactly true, the driver may take some time before the buffer we
> > have queued back is filled and available again. The poll/select FD set
> > also have a control pipe, so we can stop the process at any moment. Not
> > polling would mean blocking on an ioctl() which cannot be canceled.
> >=20
> > But, without downstream queues (thread), the size of the queue will be
> > negotiated so that the buffer will be released before we go back
> > polling. The queue will never be empty in this case.
> >=20
> > > That is probably the reasoning behind what poll does today. That said=
,
> > > I've always thought it was wrong and that it should be replaced by
> > > something like:
> > >
> > > 	if (!vb2_is_streaming(q))
> > > 		return res | POLLERR;
> > >=20
> > > I.e.: only return an error if we're not streaming.
> >=20
> > I think it would be easier for user space and closer to what the doc sa=
ys.
>=20
> I tend to agree, and I'd like to raise a different but related issue.
>=20
> I've recently run into a problem with a V4L2 device (OMAP4 ISS if you wan=
t=20
> details) that sometimes crashes during video capture. When this occurs th=
e=20
> device is rendered completely unusable, and userspace need to stop the vi=
deo=20
> stream and close the video device node in order to reset the device. That=
's=20
> not ideal, but until I pinpoint the root cause that's what we have to liv=
e=20
> with.
>=20
> When the OMAP4 ISS driver detects the error it immediately completes all=
=20
> queued buffers with the V4L2_BUF_FLAG_ERROR flag set, and returns -EIO fr=
om=20
> all subsequent VIDIOC_QBUF calls. The next few VIDIOC_DQBUF calls will re=
turn=20
> buffers with the V4L2_BUF_FLAG_ERROR flag set, after which the next=20
> VIDIOC_DQBUF call will block in __vb2_wait_for_done_vb() on
>=20
>         ret =3D wait_event_interruptible(q->done_wq,
>                         !list_empty(&q->done_list) || !q->streaming);
>=20
> as the queue is still streaming and the done list stays empty.
>=20
> (Disclaimer : I'm using gstreamer 0.10 for this project due to TI shippin=
g the=20
> OMAP4 H.264 codec for this version only)

Nod, nothing I can help with. This is a very similar problem to
out-of-tree kernel drivers. We need to teach vendors to upstream in
gst-plugins-bad, otherwise it becomes un-maintain.

> =20
> As gstreamer doesn't handle POLLERR in v4l2src the gst_poll_wait() call i=
n=20
> gst_v4l2src_grab_frame() will return success, and the function then proce=
eds=20
> to call gst_v4l2_buffer_pool_dqbuf() which will block. Trying to stop the=
=20
> pipeline at that point just hangs forever on the VIDIOC_DQBUF call.

This is what I'm working on right now, don't expect a fix for 0.10, it
has been un-maintained for 2 years now. For the reference:

https://bugzilla.gnome.org/show_bug.cgi?id=3D731015

>=20
> This kind of fatal error condition should be detected and reported to the=
=20
> application.
>=20
> If we modified the poll() behaviour to return POLLERR on !vb2_is_streamin=
g()=20
> instead of list_empty(&q->queued_list) the poll call would block and stop=
ping=20
> the pipeline would be possible.
>=20
> We would however still miss a mechanism to detect the fatal error and rep=
ort=20
> it to the application. As I'm not too familiar with gstreamer I'd appreci=
ate=20
> any help I could get to implement this.

It might not be the appropriate list but oh well ...

GStreamer abstract polling through GstPoll (reason: special features and
multi-platform). To detect the POLLERR, simply keep the GstPollFD
structure around in the object, and call gst_poll_fd_has_error(poll,
pollfd), you can read errno as usual. If you change the kernel as we
said, this code should never be reached, hence shall be a fatal error
(return GST_FLOW_ERROR and GST_ELEMENT_ERROR so application is notified
and can handle it).

It would indeed be a good mechanism to trigger fatal run-time error in
my opinion. We would need to document values of errno that make sense I
suppose. The ERROR flag is clearly documented as a mechanism for
recoverable errors.

>=20
> > Though, it's not just about changing that check, there is some more wor=
k
> > involved from what I've seen.
>=20
> What have you seen ? :-)
>=20

My bad, miss-read the next statement:

        if (list_empty(&q->done_list))
        		poll_wait(file, &q->done_wq, wait);

Nothing complex to do indeed.


--=-Ly83mq0d+9QUKwq74Zax
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlOOCGoACgkQcVMCLawGqBxT+gCfcArE5FTJ2vjG8ryA7oRvufP4
fMoAn3d8hjs2PeF4TpHuxyI+AyIAiOgm
=cGzf
-----END PGP SIGNATURE-----

--=-Ly83mq0d+9QUKwq74Zax--

