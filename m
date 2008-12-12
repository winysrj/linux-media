Return-path: <video4linux-list-bounces@redhat.com>
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Fri, 12 Dec 2008 14:04:10 +0100
References: <200812121401.55277.laurent.pinchart@skynet.be>
In-Reply-To: <200812121401.55277.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812121404.10640.laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Schimek <mschimek@gmx.at>
Subject: [PATCH v2 1/4] v4l2: Add camera zoom controls
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

The zoom controls move the zoom lens group to a an absolute position, as a
relative displacement or at a given speed until reaching physical device
limits. Positive values move the zoom lens group towards the telephoto
direction, negative values towards the wide-angle direction.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
--

diff -r 0280330fd4a0 linux/include/linux/videodev2.h
--- a/linux/include/linux/videodev2.h	Wed Nov 26 00:20:42 2008 +0100
+++ b/linux/include/linux/videodev2.h	Thu Nov 27 15:38:15 2008 +0100
@@ -1118,6 +1118,10 @@
 #define V4L2_CID_FOCUS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+11)
 #define V4L2_CID_FOCUS_AUTO			(V4L2_CID_CAMERA_CLASS_BASE+12)
 
+#define V4L2_CID_ZOOM_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+13)
+#define V4L2_CID_ZOOM_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+14)
+#define V4L2_CID_ZOOM_CONTINUOUS		(V4L2_CID_CAMERA_CLASS_BASE+15)
+
 /*
  *	T U N I N G
  */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
