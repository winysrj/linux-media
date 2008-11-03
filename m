Return-path: <video4linux-list-bounces@redhat.com>
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Mon, 3 Nov 2008 21:47:04 +0100
References: <200811032103.36711.laurent.pinchart@skynet.be>
In-Reply-To: <200811032103.36711.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811032147.04546.laurent.pinchart@skynet.be>
Cc: mchehab@redhat.com
Subject: [PATCH 2/2] v4l2: Add camera privacy control.
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

Documentation part of the patch. As I haven't found any repository in which
the source was stored, I've generated a diff against the 0.24 tarball.

Laurent Pinchart

diff -Naur v4l2spec-0.24/controls.sgml v4l2spec-0.24/controls.sgml
--- v4l2spec-0.24/controls.sgml	2008-03-06 16:42:11.000000000 +0100
+++ v4l2spec-0.24/controls.sgml	2008-11-03 17:11:25.000000000 +0100
@@ -1644,6 +1644,15 @@
 adjustments. The effect of manual focus adjustments while this feature
 is enabled is undefined, drivers should ignore such requests.</entry>
           </row>
+
+          <row>
+            <entry spanname="id"><constant>V4L2_CID_PRIVACY</constant>&nbsp;</entry>
+            <entry>boolean</entry>
+          </row><row><entry spanname="descr">Prevent video from being acquired
+by the camera sensor. A true value indicates that no image can be captured by
+the sensor. Devices that implement the privacy control must support read access
+and may support write access.
+          </row>
           <row><entry></entry></row>
         </tbody>
       </tgroup>
diff -Naur v4l2spec-0.24/videodev2.h v4l2spec-0.24/videodev2.h
--- v4l2spec-0.24/videodev2.h	2008-03-06 16:42:11.000000000 +0100
+++ v4l2spec-0.24/videodev2.h	2008-11-03 17:01:35.000000000 +0100
@@ -1093,6 +1093,8 @@
 #define V4L2_CID_FOCUS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+11)
 #define V4L2_CID_FOCUS_AUTO			(V4L2_CID_CAMERA_CLASS_BASE+12)
 
+#define V4L2_CID_PRIVACY			(V4L2_CID_CAMERA_CLASS_BASE+13)
+
 /*
  *	T U N I N G
  */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
