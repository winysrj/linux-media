Return-path: <video4linux-list-bounces@redhat.com>
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Fri, 12 Dec 2008 14:06:49 +0100
References: <200812121401.55277.laurent.pinchart@skynet.be>
In-Reply-To: <200812121401.55277.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812121406.49805.laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Schimek <mschimek@gmx.at>
Subject: [PATCH v2 2/4] v4l2: Add privacy control
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

The privacy control prevents video from being acquired by the camera. A true 
value indicates that no image can be captured. Devices that implement the 
privacy control must support read access and may support write access.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
--

diff -r 0280330fd4a0 linux/include/linux/videodev2.h
--- a/linux/include/linux/videodev2.h	Wed Nov 26 00:20:42 2008 +0100
+++ b/linux/include/linux/videodev2.h	Thu Nov 27 15:38:23 2008 +0100
@@ -1122,6 +1122,8 @@
 #define V4L2_CID_ZOOM_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+14)
 #define V4L2_CID_ZOOM_CONTINUOUS		(V4L2_CID_CAMERA_CLASS_BASE+15)
 
+#define V4L2_CID_PRIVACY			(V4L2_CID_CAMERA_CLASS_BASE+16)
+
 /*
  *	T U N I N G
  */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
