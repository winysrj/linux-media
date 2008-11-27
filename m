Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mARII7G5018780
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 13:18:07 -0500
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.247])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mARIHuX2002834
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 13:17:56 -0500
Received: by an-out-0708.google.com with SMTP id b2so417124ana.36
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 10:17:55 -0800 (PST)
Message-ID: <2df568dc0811271017h1598b038g6f21e92b005538a@mail.gmail.com>
Date: Thu, 27 Nov 2008 11:17:55 -0700
From: "Gordon Smith" <spider.karma+video4linux-list@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Advice needed: gspca IR LED control
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

Hello everyone,

I have a Z-Star Microelectronics Corp. ZC0305 USB WebCam that works fine
during daylight with the gspca webcam driver.
I'd like to turn on the IR LED's on the webcam for nighttime capture and it
looks like the driver doesn't have that capability.

Any advice on how to find out how to control the LED's?

In addition to Linux, I have a windows machine with the capture software
that came with the webcam that turns on the LED's during capture.
Would it be difficult to capture and interpret USB traffic on the windows
machine?

Cheers,
Gordon
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
