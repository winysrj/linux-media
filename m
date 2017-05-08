Return-path: <linux-media-owner@vger.kernel.org>
Received: from asip.xyz ([198.211.98.88]:49704 "EHLO asip.xyz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752274AbdEHCMM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 22:12:12 -0400
Received: from aslap.home.asip.xyz (pool-108-49-81-28.bstnma.east.verizon.net [108.49.81.28])
        by asip.xyz (Postfix) with ESMTPSA id 9D2145FA21
        for <linux-media@vger.kernel.org>; Sun,  7 May 2017 22:05:21 -0400 (EDT)
Date: Sun, 7 May 2017 22:05:19 -0400
From: Andrew Siplas <andrew@asip.xyz>
To: linux-media@vger.kernel.org
Subject: [PATCH] updated 'dvb-apps' source/headers to reflect FSF's new
 physical address
Message-ID: <20170508020518.GC3589@aslap.home.asip.xyz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Sources from https://linuxtv.org/hg/dvb-apps contain outdated address.

Easily verifiable via fsf.org , etc.


# HG changeset patch
# User Andrew Siplas <andrew@asip.xyz>
# Date 1494134745 14400
#      Sun May 07 01:25:45 2017 -0400
# Node ID de11eebb3d835387a2d0a5c3622f4dd91f2b4bbd
# Parent  3d43b280298c39a67d1d889e01e173f52c12da35
Updated FSF mailing address--thanks to RedHat's rpmlint.

diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/asn_1.c
--- a/lib/libdvben50221/asn_1.c	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/asn_1.c	Sun May 07 01:25:45 2017 -0400
@@ -17,7 +17,7 @@
=20
 	You should have received a copy of the GNU Lesser General Public
 	License along with this library; if not, write to the Free Software
-	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1335 =
USA
 */
=20
 #include <stdio.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/asn_1.h
--- a/lib/libdvben50221/asn_1.h	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/asn_1.h	Sun May 07 01:25:45 2017 -0400
@@ -17,7 +17,7 @@
=20
 	You should have received a copy of the GNU Lesser General Public
 	License along with this library; if not, write to the Free Software
-	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1335 =
USA
 */
=20
 #ifndef __ASN_1_H__
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_ai.c
--- a/lib/libdvben50221/en50221_app_ai.c	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_ai.c	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #include <string.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_ai.h
--- a/lib/libdvben50221/en50221_app_ai.h	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_ai.h	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #ifndef __EN50221_APPLICATION_AI_H__
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_auth.c
--- a/lib/libdvben50221/en50221_app_auth.c	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_auth.c	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #include <string.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_auth.h
--- a/lib/libdvben50221/en50221_app_auth.h	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_auth.h	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #ifndef __EN50221_APPLICATION_auth_H__
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_ca.c
--- a/lib/libdvben50221/en50221_app_ca.c	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_ca.c	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #include <string.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_ca.h
--- a/lib/libdvben50221/en50221_app_ca.h	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_ca.h	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #ifndef __EN50221_APPLICATION_ca_H__
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_datetime=
=2Ec
--- a/lib/libdvben50221/en50221_app_datetime.c	Fri Mar 21 20:26:36 2014 +01=
00
+++ b/lib/libdvben50221/en50221_app_datetime.c	Sun May 07 01:25:45 2017 -04=
00
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #include <string.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_datetime=
=2Eh
--- a/lib/libdvben50221/en50221_app_datetime.h	Fri Mar 21 20:26:36 2014 +01=
00
+++ b/lib/libdvben50221/en50221_app_datetime.h	Sun May 07 01:25:45 2017 -04=
00
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #ifndef __EN50221_APPLICATION_DATETIME_H__
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_dvb.c
--- a/lib/libdvben50221/en50221_app_dvb.c	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_dvb.c	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #include <string.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_dvb.h
--- a/lib/libdvben50221/en50221_app_dvb.h	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_dvb.h	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #ifndef __EN50221_APPLICATION_DVB_H__
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_epg.c
--- a/lib/libdvben50221/en50221_app_epg.c	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_epg.c	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #include <string.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_epg.h
--- a/lib/libdvben50221/en50221_app_epg.h	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_epg.h	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #ifndef __EN50221_APPLICATION_epg_H__
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_lowspeed=
=2Ec
--- a/lib/libdvben50221/en50221_app_lowspeed.c	Fri Mar 21 20:26:36 2014 +01=
00
+++ b/lib/libdvben50221/en50221_app_lowspeed.c	Sun May 07 01:25:45 2017 -04=
00
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #include <string.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_lowspeed=
=2Eh
--- a/lib/libdvben50221/en50221_app_lowspeed.h	Fri Mar 21 20:26:36 2014 +01=
00
+++ b/lib/libdvben50221/en50221_app_lowspeed.h	Sun May 07 01:25:45 2017 -04=
00
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #ifndef __EN50221_APPLICATION_LOWSPEED_H__
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_mmi.c
--- a/lib/libdvben50221/en50221_app_mmi.c	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_mmi.c	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #include <string.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_mmi.h
--- a/lib/libdvben50221/en50221_app_mmi.h	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_mmi.h	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #ifndef __EN50221_APPLICATION_mmi_H__
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_rm.c
--- a/lib/libdvben50221/en50221_app_rm.c	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_rm.c	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #include <string.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_rm.h
--- a/lib/libdvben50221/en50221_app_rm.h	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_rm.h	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #ifndef __EN50221_APPLICATION_RM_H__
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_smartcar=
d.c
--- a/lib/libdvben50221/en50221_app_smartcard.c	Fri Mar 21 20:26:36 2014 +0=
100
+++ b/lib/libdvben50221/en50221_app_smartcard.c	Sun May 07 01:25:45 2017 -0=
400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #include <string.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_smartcar=
d.h
--- a/lib/libdvben50221/en50221_app_smartcard.h	Fri Mar 21 20:26:36 2014 +0=
100
+++ b/lib/libdvben50221/en50221_app_smartcard.h	Sun May 07 01:25:45 2017 -0=
400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #ifndef __EN50221_APPLICATION_smartcard_H__
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_tags.h
--- a/lib/libdvben50221/en50221_app_tags.h	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_tags.h	Sun May 07 01:25:45 2017 -0400
@@ -17,7 +17,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #ifndef __EN50221_APP_TAGS_H__
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_teletext=
=2Ec
--- a/lib/libdvben50221/en50221_app_teletext.c	Fri Mar 21 20:26:36 2014 +01=
00
+++ b/lib/libdvben50221/en50221_app_teletext.c	Sun May 07 01:25:45 2017 -04=
00
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #include <string.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_teletext=
=2Eh
--- a/lib/libdvben50221/en50221_app_teletext.h	Fri Mar 21 20:26:36 2014 +01=
00
+++ b/lib/libdvben50221/en50221_app_teletext.h	Sun May 07 01:25:45 2017 -04=
00
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #ifndef __EN50221_APPLICATION_teletext_H__
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_utils.c
--- a/lib/libdvben50221/en50221_app_utils.c	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_utils.c	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #include "en50221_app_utils.h"
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_app_utils.h
--- a/lib/libdvben50221/en50221_app_utils.h	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_app_utils.h	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #ifndef __EN50221_APP_UTILS_H__
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_errno.h
--- a/lib/libdvben50221/en50221_errno.h	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_errno.h	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #ifndef EN50221_ERRNO
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_session.c
--- a/lib/libdvben50221/en50221_session.c	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_session.c	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #include <stdio.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_session.h
--- a/lib/libdvben50221/en50221_session.h	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_session.h	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
=20
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_stdcam.c
--- a/lib/libdvben50221/en50221_stdcam.c	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_stdcam.c	Sun May 07 01:25:45 2017 -0400
@@ -16,7 +16,7 @@
=20
 	You should have received a copy of the GNU Lesser General Public
 	License along with this library; if not, write to the Free Software
-	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1335 =
USA
 */
=20
 #include <stdio.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_stdcam.h
--- a/lib/libdvben50221/en50221_stdcam.h	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_stdcam.h	Sun May 07 01:25:45 2017 -0400
@@ -16,7 +16,7 @@
=20
 	You should have received a copy of the GNU Lesser General Public
 	License along with this library; if not, write to the Free Software
-	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1335 =
USA
 */
=20
 #ifndef EN50221_STDCAM_H
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_stdcam_hlci.c
--- a/lib/libdvben50221/en50221_stdcam_hlci.c	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_stdcam_hlci.c	Sun May 07 01:25:45 2017 -0400
@@ -16,7 +16,7 @@
=20
 	You should have received a copy of the GNU Lesser General Public
 	License along with this library; if not, write to the Free Software
-	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1335 =
USA
 */
=20
 #include <stdio.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_stdcam_llci.c
--- a/lib/libdvben50221/en50221_stdcam_llci.c	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_stdcam_llci.c	Sun May 07 01:25:45 2017 -0400
@@ -16,7 +16,7 @@
=20
 	You should have received a copy of the GNU Lesser General Public
 	License along with this library; if not, write to the Free Software
-	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1335 =
USA
 */
=20
 #include <stdio.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_transport.c
--- a/lib/libdvben50221/en50221_transport.c	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_transport.c	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
 #include <stdio.h>
diff -r 3d43b280298c -r de11eebb3d83 lib/libdvben50221/en50221_transport.h
--- a/lib/libdvben50221/en50221_transport.h	Fri Mar 21 20:26:36 2014 +0100
+++ b/lib/libdvben50221/en50221_transport.h	Sun May 07 01:25:45 2017 -0400
@@ -18,7 +18,7 @@
=20
     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 U=
SA
+    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-13=
35 USA
 */
=20
=20
Signed-off-by: Andrew Siplas <andrew@asip.xyz>

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQGcBAEBAgAGBQJZD9JeAAoJECFsCi5VxjMmlwML/jiPlkxAbCsfrbCN0H0MZLLr
vk2cDCy/O+vMhj/cRcXv1atsGvarzGa0ThqfHdnPv1J/G3I7Pk4LHzgHq3DBHejx
ChHSFNmNm8W1ohC/8ey06eKMieZeU0v1P6b7uQxhZKq4CLN0UqbjuCyxLMaSzX1D
p657UrAxCQdmXBrKRSfTQRQv3FM07PliiHODtQujLSpO8RxujDh57H5TnuDsEtkA
poTR1/IT2eFKYpMZsbTme/Vu38+9K4hylaveWX2lLnYlYrE7KePtGJcQsbOWQBBd
uE+7Is2oNkG3LXKMD1Z0Iad+/HIgX1haIvRCqeHRomh6ZpVgu8dyCDfB+W3kZe90
BHAMY0tfBdLW6eLdZjMK+W1HLTymX24rF8L3clIAQFWjM4AYdU5UXvmfa61LoL5K
VQJwZJLZDS32pjmZMl7b2ZyYAqPjDmSVFWEr/qQ4/n7bonmFHL5YdqEd0O6C0byo
qnhcn3eIifRVIOmxMbdy4l8+NjM+XrPtCDqNw2jBVg==
=nBUp
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
