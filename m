Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6VMHpE0012012
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 18:17:51 -0400
Received: from mail.marywood.edu (mail.marywood.edu [192.159.104.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6VMHbwP014763
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 18:17:37 -0400
Date: Thu, 31 Jul 2008 22:16:19 +0000
From: Chaogui Zhang <czhang1974@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20080731221619.GA4599@gauss.marywood.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Cc: linux-dvb@linuxtv.org
Subject: [PATCH] xc5000.c xc_write_reg() wait time
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

This patch fixes the incorrect wait time in xc_write_reg(). Before the
patch, my Pinnacle PCTV HD 800i cannot tune to any QAM channels. After
the patch, it found all the channels without problems.

This was previously submitted back in January, as part of a much
bigger patch involving other stuff. The other parts involve hybrid tuner 
instance handling, and some code clean up. The tuner instance handling
part is obsolete now since Mike Krufky's tuner refactoring code does
precisely that and in a more efficient way, even though the xc5000 tuner
code has not been modified to take advantage of that yet.

Just for reference, the previous patch in the following thread:

http://www.linuxtv.org/pipermail/linux-dvb/2008-January/023392.html

--

Signed-off-by: Chaogui Zhang <czhang1974@gmail.com>

diff -r 55e8c99c8aa8 linux/drivers/media/common/tuners/xc5000.c
--- a/linux/drivers/media/common/tuners/xc5000.c	Wed Jul 30 07:18:13 2008 -0300
+++ b/linux/drivers/media/common/tuners/xc5000.c	Thu Jul 31 17:43:31 2008 -0400
@@ -250,7 +250,7 @@
 						/* busy flag cleared */
 					break;
 					} else {
-						xc_wait(100); /* wait 5 ms */
+						xc_wait(5); /* wait 5 ms */
 						WatchDogTimer--;
 					}
 				}

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
