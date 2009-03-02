Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n22FGYXY017210
	for <video4linux-list@redhat.com>; Mon, 2 Mar 2009 10:16:35 -0500
Received: from smtp101.biz.mail.re2.yahoo.com (smtp101.biz.mail.re2.yahoo.com
	[68.142.229.215])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n22FGE0i018640
	for <video4linux-list@redhat.com>; Mon, 2 Mar 2009 10:16:14 -0500
Message-ID: <49ABF746.8000506@embeddedalley.com>
Date: Mon, 02 Mar 2009 18:12:06 +0300
From: Vitaly Wool <vital@embeddedalley.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [patch] tvaudio: remove bogus check
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

Hello Mauro,

below is the patch that removes the subaddr check against ARRAY_SIZE(chip->shadow.bytes).
Regardless of anything, the 'bytes' array is 64 bytes large so this check disables 
easy standard programming (TDA9874A_ESP) which has a number of 255 which is hardly the
intended behavior.

As a matter of fact, we can think of separate check for this case like
	if (subaddr + 1 >= ARRAY_SIZE(chip->shadow.bytes) ||
	    subaddr != 0xFF) {
		... /* weird register, refuse */
	}
but I'm not sure if there are no other special cases so for now I suggest to just disable
it.

 drivers/media/video/tvaudio.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

Signed-off-by: Vitaly Wool <vital@embeddedalley.com> 

Index: linux-next/drivers/media/video/tvaudio.c
===================================================================
--- linux-next.orig/drivers/media/video/tvaudio.c	2009-03-02 17:50:40.000000000 +0300
+++ linux-next/drivers/media/video/tvaudio.c	2009-03-02 18:08:08.000000000 +0300
@@ -169,13 +169,6 @@
 			return -1;
 		}
 	} else {
-		if (subaddr + 1 >= ARRAY_SIZE(chip->shadow.bytes)) {
-			v4l2_info(sd,
-				"Tried to access a non-existent register: %d\n",
-				subaddr);
-			return -EINVAL;
-		}
-
 		v4l2_dbg(1, debug, sd, "chip_write: reg%d=0x%x\n",
 			subaddr, val);
 		chip->shadow.bytes[subaddr+1] = val;
@@ -198,16 +191,8 @@
 	if (mask != 0) {
 		if (subaddr < 0) {
 			val = (chip->shadow.bytes[1] & ~mask) | (val & mask);
-		} else {
-			if (subaddr + 1 >= ARRAY_SIZE(chip->shadow.bytes)) {
-				v4l2_info(sd,
-					"Tried to access a non-existent register: %d\n",
-					subaddr);
-				return -EINVAL;
-			}
-
+		} else
 			val = (chip->shadow.bytes[subaddr+1] & ~mask) | (val & mask);
-		}
 	}
 	return chip_write(chip, subaddr, val);
 }


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
