Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45916 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbZKQNwZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 08:52:25 -0500
Message-ID: <4B02AA78.6050102@infradead.org>
Date: Tue, 17 Nov 2009 11:51:52 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Bertrand <ba@cykian.net>
Subject: [Fwd: [PATCH 2.6.31.5 1/1] v4l2: add new define for last camera class
 	control id]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bertrand,

Please, always send patches c/c to:
        linux-media@vger.kernel.org. 
This way, people can better review it.

For more details, please read:
        http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches

There are some additional details on how patch submission works at:
        http://linuxtv.org/hg/v4l-dvb/file/tip/README.patches

I'm forwarding it to the ML. I'll comment about it there.

Cheers,
Mauro.

-------- Mensagem original --------
Assunto: [PATCH 2.6.31.5 1/1] v4l2: add new define for last camera class 	control id
Data: Wed, 11 Nov 2009 22:00:24 +0100
De: Bertrand <ba@cykian.net>
Para: Mauro Carvalho Chehab <mchehab@infradead.org>

The videodev2.h file contains, among other things, defines that point
to the control properties of video devices.

For the standard video controls, there is a V4L2_CID_BASE define for
the base, and a pointer to the last control ID plus 1 named
V4L2_CID_LASTP1.
This allows automatic, version independent enumeration of the controls.

There are other controls which are specific to the camera class
devices. While there is a V4L2_CID_CAMERA_CLASS_BASE define, there was
none for the last one.
As a result it was not possible to do an enumeration of the controls
of that class. This patch corrects this by adding a
V4L2_CID_CAMERA_CLASS_LASTP1 define.

Signed-off-by: Bertrand Achard <ba@cykian.net>

--- linux-2.6.31.5/include/linux/videodev2.h	2009-10-23 00:57:56.000000000 +0200
+++ linux-2.6.31.5-n/include/linux/videodev2.h	2009-11-11
21:48:48.000000000 +0100
@@ -1147,6 +1147,8 @@ enum  v4l2_exposure_auto_type {

 #define V4L2_CID_PRIVACY			(V4L2_CID_CAMERA_CLASS_BASE+16)

+#define V4L2_CID_CAMERA_CLASS_LASTP1		(V4L2_CID_CAMERA_CLASS_BASE+17)
+
 /*
  *	T U N I N G
  */
