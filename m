Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailoutvs3.siol.net ([185.57.226.194]:38576 "EHLO mail.siol.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727440AbeKKVCD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Nov 2018 16:02:03 -0500
From: Jernej Skrabec <jernej.skrabec@siol.net>
To: mchehab@kernel.org, hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        jernej.skrabec@siol.net
Subject: [PATCH] media: media-request: Add compat ioctl
Date: Sun, 11 Nov 2018 12:06:21 +0100
Message-Id: <20181111110621.18683-1-jernej.skrabec@siol.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently media request ioctl operations fail on 64-bit kernel with
32-bit userspace due to missing .compat_ioctl callback.

Because no ioctl command uses any argument, just reuse existing ioctl
handler for compat_ioctl too.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
---
 drivers/media/media-request.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/media-request.c b/drivers/media/media-request.=
c
index 4e9db1fed697..c71a34ae6383 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -238,6 +238,9 @@ static const struct file_operations request_fops =3D =
{
 	.owner =3D THIS_MODULE,
 	.poll =3D media_request_poll,
 	.unlocked_ioctl =3D media_request_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =3D media_request_ioctl,
+#endif /* CONFIG_COMPAT */
 	.release =3D media_request_close,
 };
=20
--=20
2.19.1
