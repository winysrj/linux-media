Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9KAuUe1011187
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 06:56:30 -0400
Received: from shark4.inbox.lv (shark4.inbox.lv [89.111.3.84])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9KAuFTT018092
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 06:56:16 -0400
Received: from localhost (w16 [10.0.1.26])
	by shark4-plain-b64d2.inbox.lv (Postfix) with ESMTP id C7BED1B7C1
	for <video4linux-list@redhat.com>;
	Mon, 20 Oct 2008 13:56:14 +0300 (EEST)
Message-ID: <1224500174.48fc63cec8239@www.inbox.lv>
Date: Mon, 20 Oct 2008 13:56:14 +0300
From: Gatis <gatisl@inbox.lv>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Python script + v4lctl
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
Intro:
I wrote script that in case of some event takes picture using usb=0Awebcam =
[Creative Live! Cam Vista IM (VF0420)] and command line utility=0Av4lctl (f=
rom package xawtv).
Problem:
When script is run from /etc/init.d (in runlevel 2) during boot, no=0Apictu=
res are taken. I can't tell error message, because I have not yet=0Amanaged=
 to get error messages into logfile.
If I execute v4lctl now from commandline (while my script is running=0Ain b=
ackground), picture is taken.
If script is restarted (using same init.d startup script that was=0Aused by=
 pc to start my python script) pictures are taken - all works.
I set in rc2.d that script starts at the end of boot - "S99script" -=0Aso i=
t starts after webcam drivers are loaded.
I set delay of minute at the begining of script to allow pc to finish=0Aboo=
t - no results.
In dmesg there are error messages:
"v4lctl: segm: ...... : error 4"
Command executed: v4lctl -c /dev/video0 snap jpeg full test.jpg
Using Linux Ubuntu 8.
Drivers for webcam - using EasyCam=0A[https://help.ubuntu.com/community/Eas=
yCam].
Where can be found v4lctl return codes?
Best regards,
Gatis Liepins
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
