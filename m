Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAS839No021739
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 03:03:09 -0500
Received: from web39708.mail.mud.yahoo.com (web39708.mail.mud.yahoo.com
	[209.191.106.54])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAS82uCx008088
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 03:02:56 -0500
Date: Fri, 28 Nov 2008 00:02:55 -0800 (PST)
From: wei kin <kin2031@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <82224.60450.qm@web39708.mail.mud.yahoo.com>
Content-Type: text/plain; charset=us-ascii
Subject: Unable to achieve 30fps using 'read()' in C
Reply-To: kin2031@yahoo.com
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

Hi all, I am new in v4l programming. What I did in my code is I used 'read( )' in C programming to read images from my Logitech Quickcam Express. My problem is I can't get 30frames per second, what I got is just 5fps when I loop and read for 200times. Do anyone know why is it under performance? Thanks

Rgds,
nik2031



      
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
