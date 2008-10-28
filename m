Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9S8QHk5027647
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 04:26:17 -0400
Received: from shark4.inbox.lv (shark4.inbox.lv [89.111.3.84])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9S8Q3QB015125
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 04:26:03 -0400
Received: from localhost (w13 [10.0.1.23])
	by shark4-plain-b64d2.inbox.lv (Postfix) with ESMTP id 2BAFF1B882
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 10:26:02 +0200 (EET)
Message-ID: <1225182362.4906cc9a38cb1@www.inbox.lv>
Date: Tue, 28 Oct 2008 10:26:02 +0200
From: Gatis <gatisl@inbox.lv>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Creative Vista IM (VF0420) - green pictures
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

Hello!
I set up usb webcam [ Creative Live! Cam Vista IM (VF0420) ] with=0A"EasyCa=
m" automatic driver installer. OS - Ubuntu 8.
I use v4lctl command line tool to periodically take snapshots:
v4lctl snap jpeg full test.jpg
Problem:
20% of taken pictures are heavily colored in green. This is true also=0Awhe=
n using xawtv. I couldn't find any connection between start of this=0Aprobl=
em and any surrounding conditions. If I restart PC, or cover=0Awebcam with =
hand for a while, webcam returns to normal operation.
When tested with official windows drivers on winXP, there was no such=0Apro=
blems.
Question:
Is this driver, camera or settings problem?
Could you please  suggest other usb camera with better image quality,=0Atha=
t is working correctly on linux?
I considered also using analog camera with video capture pci card.=0ACould =
you suggest any tested video capture card for linux?
Best regards,
Gatis Liepins
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
