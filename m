Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6GNBGXf019109
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 19:11:16 -0400
Received: from n23c.bullet.mail.mud.yahoo.com (n23c.bullet.mail.mud.yahoo.com
	[68.142.206.39])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6GNB2OU007221
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 19:11:03 -0400
Date: Wed, 16 Jul 2008 16:10:57 -0700 (PDT)
From: Krish K <rtos_q@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <264168.24331.qm@web59602.mail.ac4.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: Question on V4L2 VBI operation
Reply-To: rtos_q@yahoo.com
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

Hello



I am new to V4L2 and have a question on how V4L2 expects=20

VBI data to be provided.



It is not clear to me if the VBI data (CC, WSS, etc) can be=20

embedded in the frame? If the video capture device does=20

not provide the VBI data separately, should the driver=20

extract it from the frame? Is this what drivers usually do?

If the device provides VBI data separately (either in some

registers or FIFO),=A0 then the driver should obtain this from=20

the device for each frame?



Thanks

Krish



=0A=0A=0A      
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
