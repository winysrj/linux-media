Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m658rQjK023232
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 04:53:26 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m658r2FI009427
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 04:53:03 -0400
Message-ID: <486F3230.2040501@hhs.nl>
Date: Sat, 05 Jul 2008 10:34:56 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------080503000801080504080808"
Cc: video4linux-list@redhat.com
Subject: PATCH: gspca-default-comp_fac.patch <resend>
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
--------------080503000801080504080808
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jean,

This patch changes the default gspca comp_fac as 30% sometimes causes 
issues with the spca561, whose bayer compression does not allways 
achieve 30%.

I notice that you didn't apply this patch with the latest merging of my 
patches. Note that this patch is _really_ needed for the spca561 to 
work. Without it it works most of the time, but with some images it 
doesn't get a high enough compression and fails.

An other solution would be to add a cam specific get_buff_size op to the 
spca561 driver.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans


--------------080503000801080504080808
Content-Type: text/plain;
 name="gspca-default-comp_fac.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-default-comp_fac.patch"

This patch changes the default gspca comp_fac as 30% sometimes causes issues
with the spca561, whose bayer compression does not allways achieve 30%.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r 15974504cec1 linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Fri Jul 04 10:51:37 2008 +0200
+++ b/linux/drivers/media/video/gspca/gspca.c	Fri Jul 04 10:53:35 2008 +0200
@@ -48,7 +48,9 @@
 
 static int video_nr = -1;
 
-static int comp_fac = 30;	/* Buffer size ratio when compressed in % */
+static int comp_fac = 40;	/* Buffer size ratio when compressed in %,
+				   Note 30% is too small for bayer level
+				   compression like the spca561 */
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 int gspca_debug = D_ERR | D_PROBE;


--------------080503000801080504080808
Content-Type: text/plain;
 name="file:///tmp/nsmail-2.tmp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="file:///tmp/nsmail-2.tmp"

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

--------------080503000801080504080808
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------080503000801080504080808--
