Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.unsolicited.net ([173.255.193.191]:39861 "EHLO
	mx1.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbcEKSrY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 14:47:24 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	gregkh@linuxfoundation.org
From: David R <david@unsolicited.net>
Subject: Patch: V4L stable versions 4.5.3 and 4.5.4
Message-ID: <57337E39.40105@unsolicited.net>
Date: Wed, 11 May 2016 19:47:21 +0100
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020901020809050807070608"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020901020809050807070608
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi

Please consider applying the attached patch (or something like it) to
V4L2, and whatever is appropriate to the mainstream kernel. Without this
my media server crashes and burns at boot.

See https://lkml.org/lkml/2016/5/7/88 for more details

Thanks
David

--------------020901020809050807070608
Content-Type: text/x-patch;
 name="v4l2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="v4l2.diff"

--- drivers/media/v4l2-core/videobuf2-core.c.old	2016-05-11 18:44:50.917083559 +0100
+++ drivers/media/v4l2-core/videobuf2-core.c	2016-05-11 18:45:10.136184837 +0100
@@ -1665,7 +1665,7 @@ static int __vb2_get_done_vb(struct vb2_
 	 * Only remove the buffer from done_list if v4l2_buffer can handle all
 	 * the planes.
 	 */
-	ret = call_bufop(q, verify_planes_array, *vb, pb);
+	ret = pb ? call_bufop(q, verify_planes_array, *vb, pb) : 0;
 	if (!ret)
 		list_del(&(*vb)->done_entry);
 	spin_unlock_irqrestore(&q->done_lock, flags);

--------------020901020809050807070608--
