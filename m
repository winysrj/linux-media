Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1HJQCjr030384
	for <video4linux-list@redhat.com>; Tue, 17 Feb 2009 14:26:12 -0500
Received: from mail-gx0-f171.google.com (mail-gx0-f171.google.com
	[209.85.217.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1HJPCce017972
	for <video4linux-list@redhat.com>; Tue, 17 Feb 2009 14:25:12 -0500
Received: by gxk19 with SMTP id 19so4204465gxk.3
	for <video4linux-list@redhat.com>; Tue, 17 Feb 2009 11:25:12 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 17 Feb 2009 14:25:11 -0500
Message-ID: <412bdbff0902171125o79dc3587vc7c25b8da6df03fe@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: video4linux-list <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: V4L2 ioctl for OTA/cable?
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

I was doing some work on the xc5000 analog support, and that chip in
particular has some optimizations for analog cable versus analog over
the air reception.

Is there a v4l2 API for configuring which the reception mode?
Obviously the applications would have to provide some way to ask the
user which is used, but before we can get to that point we need a
kernel ioctl call to be implemented.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
