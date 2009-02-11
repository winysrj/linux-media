Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1BIhBBJ006961
	for <video4linux-list@redhat.com>; Wed, 11 Feb 2009 13:43:11 -0500
Received: from mail-fx0-f10.google.com (mail-fx0-f10.google.com
	[209.85.220.10])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1BIgI1Y003143
	for <video4linux-list@redhat.com>; Wed, 11 Feb 2009 13:42:19 -0500
Received: by fxm3 with SMTP id 3so579880fxm.3
	for <video4linux-list@redhat.com>; Wed, 11 Feb 2009 10:42:18 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 11 Feb 2009 20:42:07 +0200
Message-ID: <36c518800902111042j2fd8db53q58d7e3960d26120c@mail.gmail.com>
From: vasaka@gmail.com
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: v4l2 and skype
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

hello, I am writing v4l2 loopback driver and now it is at working
stage. for now it can feed mplayer and luvcview, but silently fails
with skype it just shows green screen while buffer rotation is going
on. can you help me with debug? I think I missing small and obvious
detail. Is there something special about skype way of working with
v4l2?

loopback is here:
http://code.google.com/p/v4l2loopback/source/checkout
I am feeding it with this app
http://code.google.com/p/v4lsink/source/checkout
this is the simple gstreamer app which takes data from /dev/video0 and
puts it to /dev/video1 which should be my loopback device.
--
Vasily Levin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
