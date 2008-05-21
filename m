Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4L3SxIU030791
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 23:28:59 -0400
Received: from psmtp.com (exprod8ob118.obsmtp.com [64.18.3.35])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4L3SkKL013893
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 23:28:47 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Date: Tue, 20 May 2008 20:06:37 -0700
Message-ID: <A0E1B902C85838448AEA276170BCB5A5097886C8@NEVAEH.startrac.com>
From: "Dan Taylor" <dtaylor@startrac.com>
To: <video4linux-list@redhat.com>
Content-Transfer-Encoding: 8bit
Subject: where to send patch for SAA7134-cards.c?
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

I have fixed a problem with the S-Video input on the AverMedia A16D.
It's a minor patch to add gpio mask and values to the entry in the
saa7134_boards structure.  Should the patch be at the directory level of
the file (.../drivers/media/video/saa7134) or higher in the tree?  Do I
just post it to this list, or should I send it to a specific maintainer
(and, if so, who?)?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
