Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8U4sOd3031987
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 00:54:24 -0400
Received: from ip2-vg2.iplannetworks.net (ip2-vg2.iplannetworks.net
	[201.216.250.60])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8U4raiv005655
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 00:53:37 -0400
Message-ID: <48E1B0CA.2010405@unixlan.com.ar>
Date: Tue, 30 Sep 2008 01:53:30 -0300
From: Normando Hall <nhall@unixlan.com.ar>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Kodicom 4400 and kernel 2.6.9
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

I know Kodicom is fully supported from kernel 2.6.13 and up, but I want 
to know if there is an alternative to run under 2.6.9.

I have download the last V4L2 0.9.15 source, and added manually the 
kodicom code, as from 2.6.13 source code. (bttv-cards.c and bttv.h). I 
have compiled, and load succesfully. From command line I have load as 
modprobe bttv card=122,121,122,122 (my custom card numbers) and with a 
zoneminder utility I get the driver is correctly load. video0 = slave, 1 
= master, 2 = slave, 3 = slave.

But nothing happens. I can't get the video from the camera.

It is absolutelly imposible to run kodicom 4400 under 2.6.9 kernel?

Thank you in advance, and sorry my bad english.

Normando

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
