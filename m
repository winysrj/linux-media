Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m64AwrvU003196
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 06:58:53 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m64AwcP4007373
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 06:58:39 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KEizt-00060x-LA
	for video4linux-list@redhat.com; Fri, 04 Jul 2008 12:58:37 +0200
Message-ID: <486E023A.6010801@hhs.nl>
Date: Fri, 04 Jul 2008 12:58:02 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------000308010809060803060004"
Cc: video4linux-list@redhat.com
Subject: PATCH: gspca-pac207-fix-daylight-frame-decode-errors.patch
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
--------------000308010809060803060004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch fixes the frame decoding errors seen when using the pac207 in full
daylight.

The problem is that in full daylight, the exposure time was set so low, that
in 352x288 mode the usb bandwidth is not enough and packets get dropped
resulting in corrupt frames. This patch worksaround this issue by increasing
the minimum allowed exposure time, reducing the max framerate and thus the max
needed bandwidth.

The proper fix for this would be to lower the compression balance setting when
in 352x288 mode. The problem with this is that when the compression balance
gets lowered below 0x80, the pac207 starts using a different compression
algorithm for some lines, these lines get prefixed with a 0x2dd2 prefix
and currently we do not know how to decompress these lines, so for now
we use a minimum exposure value of 5

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------000308010809060803060004
Content-Type: text/plain;
	name="gspca-pac207-fix-daylight-frame-decode-errors.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="gspca-pac207-fix-daylight-frame-decode-errors.patch"

This patch fixes the frame decoding errors seen when using the pac207 in full
daylight.

The problem is that in full daylight, the exposure time was set so low, that
in 352x288 mode the usb bandwidth is not enough and packets get dropped
resulting in corrupt frames. This patch worksaround this issue by increasing
the minimum allowed exposure time, reducing the max framerate and thus the max
needed bandwidth.

The proper fix for this would be to lower the compression balance setting when
in 352x288 mode. The problem with this is that when the compression balance
gets lowered below 0x80, the pac207 starts using a different compression
algorithm for some lines, these lines get prefixed with a 0x2dd2 prefix   
and currently we do not know how to decompress these lines, so for now
we use a minimum exposure value of 5

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r 2ce25c86c3a9 linux/drivers/media/video/gspca/pac207.c
--- a/linux/drivers/media/video/gspca/pac207.c	Fri Jul 04 10:56:40 2008 +0200
+++ b/linux/drivers/media/video/gspca/pac207.c	Fri Jul 04 12:51:09 2008 +0200
@@ -40,9 +40,17 @@
 #define PAC207_BRIGHTNESS_MAX		255
 #define PAC207_BRIGHTNESS_DEFAULT	4 /* power on default: 4 */
 
-#define PAC207_EXPOSURE_MIN		4
+/* An exposure value of 4 also works (3 does not) but then we need to lower
+   the compression balance setting when in 352x288 mode, otherwise the usb
+   bandwidth is not enough and packets get dropped resulting in corrupt
+   frames. The problem with this is that when the compression balance gets
+   lowered below 0x80, the pac207 starts using a different compression
+   algorithm for some lines, these lines get prefixed with a 0x2dd2 prefix
+   and currently we do not know how to decompress these lines, so for now
+   we use a minimum exposure value of 5 */
+#define PAC207_EXPOSURE_MIN		5
 #define PAC207_EXPOSURE_MAX		26
-#define PAC207_EXPOSURE_DEFAULT		4 /* power on default: 3 ?? */
+#define PAC207_EXPOSURE_DEFAULT		5 /* power on default: 3 ?? */
 #define PAC207_EXPOSURE_KNEE		11 /* 4 = 30 fps, 11 = 8, 15 = 6 */
 
 #define PAC207_GAIN_MIN			0

--------------000308010809060803060004
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------000308010809060803060004--
