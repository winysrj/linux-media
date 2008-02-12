Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1C82tXJ006815
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 03:02:55 -0500
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.229])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1C82WtH030485
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 03:02:32 -0500
Received: by wr-out-0506.google.com with SMTP id 70so4701824wra.7
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 00:02:31 -0800 (PST)
Message-ID: <22dcca890802120002m19ff0f10x6776cdbdccc1f443@mail.gmail.com>
Date: Tue, 12 Feb 2008 09:02:31 +0100
From: "Youri Matthys" <yourimatthys@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: [PATCH] repeating remote control keys on Compro VideoMate DVB-T300
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

James,

First of all I would like to thank you for your work on this patch.

I've applied your patch for my Compro VideoMate DVB-T200 remote on 2.6.23.
The problem with the repeating keys has gotten a lot better after applying
it, though they aren't resolved.

How could I further extend the width of the low pulse so i can get the
problem resolved?
**
Kind regards, Youri


   - *Date*: Sun, 2 Dec 2007 23:11:57 +1100
   - *From*: James Lawrence
<james.lawrence@xxxxxxxxx<james.lawrence@DOMAIN.HIDDEN>
   >
   - *Subject*: [PATCH] repeating remote control keys on Compro VideoMate
   DVB-T300



Hi all,

In my experience, the Compro VideoMate DVB-T300 remote control has a problem
with inconsistent repeating keys on the remote control. The problem looks
like this (note that key A and key B are any arbitrary keys on the remote):

press key A -> lirc recognizes key A
press key B -> lirc recognizes keys A, B

This makes it very hard to navigate through menus, rendering the remote
control unusable. This patch fixes this problem. I have tested this with two
different TV cards, on 3 motherboards, with multiple distributions and on
many kernel revisions from 2.6.15 to 2.6.23. The additional saa_clearb extends
the width of the low pulse on SAA7134_GPIO_GPRESCAN.

[James@mythtv v4l-dvb]$ hg diff
diff -r 27b2c6a80826 linux/drivers/media/video/saa7134/saa7134-input.c

--- a/linux/drivers/media/video/saa7134/saa7134-input.c Fri Nov 30 18:27:26
2007 +0200 +++ b/linux/drivers/media/video/saa7134/saa7134-input.c Sun Dec
02 23:08:43 2007 +1100

@@ -76,6 +76,12 @@ static int build_key(struct saa7134_dev
 	}
 	/* rising SAA7134_GPIO_GPRESCAN reads the status */
 	saa_clearb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN);
+	/* eliminate repeating keys issue on some boards*/
+	switch (dev->board) {
+	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
+		saa_clearb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN);
+		break;
+	}
 	saa_setb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN);

 	gpio = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2);

Signed-off-by: James Lawrence <james.lawrence@xxxxxxxxx>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
