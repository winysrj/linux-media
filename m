Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7BMKiFk021563
	for <video4linux-list@redhat.com>; Mon, 11 Aug 2008 18:20:44 -0400
Received: from n1a.bullet.mail.tp2.yahoo.com (n1a.bullet.mail.tp2.yahoo.com
	[203.188.202.90])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7BMKRZd013796
	for <video4linux-list@redhat.com>; Mon, 11 Aug 2008 18:20:27 -0400
Date: Mon, 11 Aug 2008 22:20:20 +0000 (GMT)
From: Malsoaz James <jmalsoaz@yahoo.fr>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <470378.52874.qm@web28411.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Timestamp and buffer
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

Hello,=0A=0AI'm trying to capture some images with a camera in a repetitive=
 way. Unfortunately each time I'm launching my program the first images are=
 not good and match with a previous capture. It seems  that the problem com=
es from the size of the buffer I'm using and that to solve the problem I ha=
ve to change the timestamp of the buffer. However I don't know what are the=
 value I have to set in the timestamp.=0A=0AI hope someone would be able to=
 help me.=0AThank you=0AJames=0A=0A=0A=0A      ____________________________=
_________________________________________________ =0AEnvoyez avec Yahoo! Ma=
il. Une boite mail plus intelligente http://mail.yahoo.fr
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
