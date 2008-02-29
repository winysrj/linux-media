Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1TGXJVO009336
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 11:33:19 -0500
Received: from QMTA10.westchester.pa.mail.comcast.net
	(qmta10.westchester.pa.mail.comcast.net [76.96.62.17])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1TGWjgm024820
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 11:32:46 -0500
Message-ID: <47C833A9.9080708@personnelware.com>
Date: Fri, 29 Feb 2008 10:32:41 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: v4l2_driver.h patch
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

Adding #include <stddef.h> solves a build problem I had on Ubnutu.

v4l-dvb/v4l2-apps/test$ make
CC driver-test.o
In file included from driver-test.c:17:
../lib/v4l2_driver.h:26: error: expected specifier-qualifier-list before 'size_t'
make: *** [driver-test.o] Error 1

      24 struct v4l2_t_buf {
      25         void            *start;
      26         size_t          length;
      27 };

http://www.video4linux.org/browser/v4l2-apps/lib/v4l2_driver.h

Carl K

diff -r 127f67dea087 v4l2-apps/lib/v4l2_driver.h
--- a/v4l2-apps/lib/v4l2_driver.h       Tue Feb 26 20:43:56 2008 +0000
+++ b/v4l2-apps/lib/v4l2_driver.h       Thu Feb 28 13:12:58 2008 -0600
@@ -12,6 +12,7 @@
     Lesser General Public License for more details.
    */

+#include <stddef.h>
  #include <stdint.h>
  #include <sys/time.h>
  #include <linux/videodev2.h>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
