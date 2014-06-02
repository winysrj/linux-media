Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:45926 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaFBTru (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jun 2014 15:47:50 -0400
Message-ID: <1401738463.2304.15.camel@nicolas-tpx230>
Subject: Poll and empty queues
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 02 Jun 2014 15:47:43 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-dDqj56JLnRrkySJz6dgE"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-dDqj56JLnRrkySJz6dgE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi everyone,

Recently in GStreamer we notice that we where not handling the POLLERR
flag at all. Though we found that what the code do, and what the doc
says is slightly ambiguous.

        "When the application did not call VIDIOC_QBUF or
        VIDIOC_STREAMON yet the poll() function succeeds, but sets the
        POLLERR flag in the revents field."
       =20
In our case, we first seen this error with a capture device. How things
worked is that we first en-queue all allocated buffers. Our
interpretation was that this would avoid not calling "VIDIOC_QBUF [...]
yet", and only then we would call VIDIOC_STREAMON. This way, in our
interpretation we would never get that error.

Though, this is not what the code does. Looking at videobuf2, if simply
return this error when the queue is empty.

	/*
	 * There is nothing to wait for if no buffers have already been queued.
	 */
	if (list_empty(&q->queued_list))
		return res | POLLERR;

So basically, we endup in this situation where as soon as all existing
buffers has been dequeued, we can't rely on the driver to wait for a
buffer to be queued and then filled again. This basically forces us into
adding a new user-space mechanism, to wait for buffer to come back. We
are wandering if this is a bug. If not, maybe it would be nice to
improve the documentation.

cheers,
Nicolas

--=-dDqj56JLnRrkySJz6dgE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlOM1N8ACgkQcVMCLawGqBxxeQCggrxinn6keyoSID+xxZm61Y7t
FEYAoN7yD+4o8A512im0BIMqYz2WJIeg
=BKo/
-----END PGP SIGNATURE-----

--=-dDqj56JLnRrkySJz6dgE--

