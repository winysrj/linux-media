Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46148 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaDPTeN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 15:34:13 -0400
Message-ID: <1397676846.10347.11.camel@nicolas-tpx230>
Subject: [PATCH] vb2: Update buffer state flags after __vb2_dqbuf
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Date: Wed, 16 Apr 2014 15:34:06 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-b0XBOUakKoYEgxc3juAQ"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-b0XBOUakKoYEgxc3juAQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Previously we where updating the buffer state using __fill_v4l2_buffer
before the state transition was completed through __vb2_dqbuf. This
would cause the V4L2_BUF_FLAG_DONE to be set, which would mean it still
queued. The spec says the dqbuf should clean the DONE flag, right not it
alway set it.

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-=
core/videobuf2-core.c
index f9059bb..ac5026a 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1943,14 +1943,15 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, =
struct v4l2_buffer *b, bool n
=20
 	call_vb_qop(vb, buf_finish, vb);
=20
-	/* Fill buffer information for the userspace */
-	__fill_v4l2_buffer(vb, b);
 	/* Remove from videobuf queue */
 	list_del(&vb->queued_entry);
 	q->queued_count--;
 	/* go back to dequeued state */
 	__vb2_dqbuf(vb);
=20
+	/* Fill buffer information for the userspace */
+	__fill_v4l2_buffer(vb, b);
+
 	dprintk(1, "dqbuf of buffer %d, with state %d\n",
 			vb->v4l2_buf.index, vb->state);
=20
--=20
1.9.0



--=-b0XBOUakKoYEgxc3juAQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlNO2y8ACgkQcVMCLawGqBw+OACgz4oUdzGXE9jC1snkKQN0IITg
ZPAAnRW+CSQdvRb7+uoEfgwV72ZDkM23
=ANUY
-----END PGP SIGNATURE-----

--=-b0XBOUakKoYEgxc3juAQ--

