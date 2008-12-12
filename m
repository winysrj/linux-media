Return-path: <video4linux-list-bounces@redhat.com>
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Fri, 12 Dec 2008 14:11:16 +0100
References: <200812121401.55277.laurent.pinchart@skynet.be>
In-Reply-To: <200812121401.55277.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812121411.17044.laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Schimek <mschimek@gmx.at>
Subject: [PATCH v2 4/4] v4l2: Document zoom and privacy controls
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

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
--

As the source isn't under version control I've generated a diff against the
0.24 tarball.

diff -aur v4l2spec-0.24-orig/controls.sgml v4l2spec-0.24/controls.sgml
--- v4l2spec-0.24-orig/controls.sgml	2008-03-06 16:42:11.000000000 +0100
+++ v4l2spec-0.24/controls.sgml	2008-12-12 13:52:20.000000000 +0100
@@ -1645,6 +1645,49 @@
 is enabled is undefined, drivers should ignore such requests.</entry>
           </row>
           <row><entry></entry></row>
+
+          <row>
+            <entry 
spanname="id"><constant>V4L2_CID_ZOOM_ABSOLUTE</constant>&nbsp;</entry>
+            <entry>integer</entry>
+          </row><row><entry spanname="descr">Specify the objective lens
+focal length as an absolute value. The zoom unit is driver-specific and its
+value should be a positive integer.</entry>
+          </row>
+          <row><entry></entry></row>
+
+          <row>
+            <entry 
spanname="id"><constant>V4L2_CID_ZOOM_RELATIVE</constant>&nbsp;</entry>
+            <entry>integer</entry>
+          </row><row><entry spanname="descr">Specify the objective lens
+focal length relatively to the current value. Positive values move the zoom
+lens group towards the telephoto direction, negative values towards the
+wide-angle direction. The zoom unit is driver-specific.</entry>
+          </row>
+          <row><entry></entry></row>
+
+          <row>
+            <entry 
spanname="id"><constant>V4L2_CID_ZOOM_CONTINUOUS</constant>&nbsp;</entry>
+            <entry>integer</entry>
+          </row><row><entry spanname="descr">Move the objective lens group
+at the specified speed until it reaches physical device limits or until an
+explicit request to stop the movement. A positive value moves the zoom lens
+group towards the telephoto direction. A value of zero stops the zoom lens
+group movement. A negative value moves the zoom lens group towards the
+wide-angle direction. The zoom speed unit is driver-specific.</entry>
+          </row>
+          <row><entry></entry></row>
+
+          <row>
+            <entry 
spanname="id"><constant>V4L2_CID_PRIVACY</constant>&nbsp;</entry>
+            <entry>boolean</entry>
+          </row><row><entry spanname="descr">Prevent video from being 
acquired
+by the camera. When this control is set to <constant>TRUE</constant> (1), no
+image can be captured by the camera. Common means to enforce privacy are
+mechanical obturation of the sensor and firmware image processing, but the
+device is not restricted to these methods. Devices that implement the privacy
+control must support read access and may support write access.</entry>
+          </row>
+          <row><entry></entry></row>
         </tbody>
       </tgroup>
     </table>
diff -aur v4l2spec-0.24-orig/videodev2.h v4l2spec-0.24/videodev2.h
--- v4l2spec-0.24-orig/videodev2.h	2008-03-06 16:42:11.000000000 +0100
+++ v4l2spec-0.24/videodev2.h	2008-11-27 10:32:07.000000000 +0100
@@ -1093,6 +1093,12 @@
 #define V4L2_CID_FOCUS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+11)
 #define V4L2_CID_FOCUS_AUTO			(V4L2_CID_CAMERA_CLASS_BASE+12)
 
+#define V4L2_CID_ZOOM_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+13)
+#define V4L2_CID_ZOOM_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+14)
+#define V4L2_CID_ZOOM_CONTINUOUS		(V4L2_CID_CAMERA_CLASS_BASE+15)
+
+#define V4L2_CID_PRIVACY			(V4L2_CID_CAMERA_CLASS_BASE+16)
+
 /*
  *	T U N I N G
  */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
