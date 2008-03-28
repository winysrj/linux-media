Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SLr0Lb022778
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 17:53:00 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SLqmiO004988
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 17:52:48 -0400
Message-ID: <47ED6892.7090807@hhs.nl>
Date: Fri, 28 Mar 2008 22:52:18 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: spca50x-devs@lists.sourceforge.net, video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: fedora-kernel-list@redhat.com
Subject: [New Driver]: usbvideo2 webcam core + pac207 driver using it.
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

Hi All,

As explained in my introduction mail I've been working on a standalone v4l2
driver for pac207 based usb webcams. I've attached the hopefully pretty clean
result to this mail.

This is the promised split version of the pac207 driver I've been working on, I 
would like to ask everyone to take a good look at this, as I plan to base a 
number of other (gspca derived) v4l2 drivers on this same core.

I'm currently posting these as .c files for easy reading and compilation /
testing, but I still hope to get a lot of feedback / a thorough review, esp of
the core <-> pac207 split version as I hope to submit that as a patch for
mainline inclusion soon.

Thanks & Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
