Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mASD3QOq019947
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 08:03:26 -0500
Received: from tomts27-srv.bellnexxia.net (tomts27.bellnexxia.net
	[209.226.175.101])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mASD37DR026344
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 08:03:07 -0500
From: Jonathan Lafontaine <jlafontaine@ctecworld.com>
To: "'kin2031@yahoo.com'" <kin2031@yahoo.com>, "video4linux-list@redhat.com"
	<video4linux-list@redhat.com>
Date: Fri, 28 Nov 2008 08:02:47 -0500
Message-ID: <09CD2F1A09A6ED498A24D850EB1012081700909BA5@Colmatec004.COLMATEC.INT>
In-Reply-To: <82224.60450.qm@web39708.mail.mud.yahoo.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: 
Subject: RE: Unable to achieve 30fps using 'read()' in C
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

Is your webcam is connected to a usb2 port(if it requires)?

Do lsusb

And dmesg | grep usb

dmesg | grep Logitech

which driver r u using for v4l2

-----Original Message-----
From: video4linux-list-bounces@redhat.com [mailto:video4linux-list-bounces@redhat.com] On Behalf Of wei kin
Sent: 28 novembre 2008 03:03
To: video4linux-list@redhat.com
Subject: Unable to achieve 30fps using 'read()' in C

Hi all, I am new in v4l programming. What I did in my code is I used 'read( )' in C programming to read images from my Logitech Quickcam Express. My problem is I can't get 30frames per second, what I got is just 5fps when I loop and read for 200times. Do anyone know why is it under performance? Thanks

Rgds,
nik2031




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

--

This message has been verified by LastSpam (http://www.lastspam.com) eMail security service, provided by SoluLAN
Ce courriel a ete verifie par le service de securite pour courriels LastSpam (http://www.lastspam.com), fourni par SoluLAN (http://www.solulan.com)
www.solulan.com


No virus found in this incoming message.
Checked by AVG - http://www.avg.com
Version: 8.0.175 / Virus Database: 270.9.9/1807 - Release Date: 2008-11-27 09:02

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
