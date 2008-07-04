Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m64BAm7T008824
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 07:10:48 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m64BAars012924
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 07:10:36 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KEjBT-0006QF-LP
	for video4linux-list@redhat.com; Fri, 04 Jul 2008 13:10:35 +0200
Message-ID: <486E0507.5050609@hhs.nl>
Date: Fri, 04 Jul 2008 13:09:59 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
Content-Type: multipart/mixed; boundary="------------070004060105020005060200"
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: PATCH: libv4l-pac207-comments.patch
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

This is a multi-part message in MIME format.
--------------070004060105020005060200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

<now with attachment (wipes egg from face)>

Hi,

Add comments to pac207.c about what todays experiments have teached us about
the pac207 compression.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list


--------------070004060105020005060200
Content-Type: text/plain;
 name="libv4l-pac207-comments.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libv4l-pac207-comments.patch"

Add comments to pac207.c about what todays experiments have teached us about
the pac207 compression.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r 61deeffda900 v4l2-apps/lib/libv4l/libv4lconvert/pac207.c
--- a/v4l2-apps/lib/libv4l/libv4lconvert/pac207.c	Fri Jul 04 07:21:55 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/pac207.c	Fri Jul 04 13:06:08 2008 +0200
@@ -170,15 +170,12 @@
 	    inp += pac_decompress_row(inp, outp, width);
 	    break;
 
-	default:
+	case 0x2DD2: /* prefix for "stronger" compressed lines, currently the
+			kernel driver programs the cam so that we should not
+			get any of these */
+
+	default: /* corrupt frame */
 	    /* FIXME add error reporting */
-	    /* Notice this seems to happen with high framerates (low exposure
-	       setting due to much light and bad compressible images, so most
-	       likely the usb just cannot keep us and we miss parts of some
-	       frames (sometimes of many frames in a row) messing things up
-	       completely. It might be worth to try changing the compression
-	       balance setting to see if that can compensate for this.
-	       However currently I cannot reproduce this (no daylight) */
 	    return;
 	}
 	outp += width;

--------------070004060105020005060200
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------070004060105020005060200--
