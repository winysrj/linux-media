Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m51IIu0C020230
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 14:18:56 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.238])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m51IH7PU025836
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 14:18:46 -0400
Received: by rv-out-0506.google.com with SMTP id f6so694870rvb.51
	for <video4linux-list@redhat.com>; Sun, 01 Jun 2008 11:18:45 -0700 (PDT)
Message-ID: <8ffbc52c0806011118h402bd732m6a81e8bc481bfcf1@mail.gmail.com>
Date: Sun, 1 Jun 2008 14:18:45 -0400
From: "Scott Wills" <mswills@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: two cameras on one 2,4 GHz RF receiver
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

I have an idea for a device driver or application plug-in that seems so
obvious I wonder if it's already been done.

I'm running zoneminder on a linux box, using an inexpensive two-camera IR
CCD system with one 2.4 GHz receiver.  The analog video output goes to a
PCTV card on the linux box.  The receiver has an IR remote control that
selects camera A or B or toggles between the two at about 2 second
intervales.

The motion detection software is already calculating the difference between
successive frames.  Why couldn't it recognize which of the two (A or B
camera) images a frame is most like and queue it on to that virtual channel,
as the receiver toggles between the two cameras?  This could be done in the
application, or at the device level, resulting in two virtual /dev/video
devices, demultiplexed from one physical video input!

Has anyone tackled this?  I've googled every related term I can think of.
Where should I look for starters?

Scott
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
