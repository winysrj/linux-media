Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n883XjcP025820
	for <video4linux-list@redhat.com>; Mon, 7 Sep 2009 23:33:45 -0400
Received: from mail-bw0-f209.google.com (mail-bw0-f209.google.com
	[209.85.218.209])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n883XSLo029302
	for <video4linux-list@redhat.com>; Mon, 7 Sep 2009 23:33:29 -0400
Received: by bwz5 with SMTP id 5so2308874bwz.3
	for <video4linux-list@redhat.com>; Mon, 07 Sep 2009 20:33:28 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 8 Sep 2009 00:33:28 -0300
Message-ID: <fa40cc720909072033l5ec82188va19da7b06b943fa2@mail.gmail.com>
From: Guilherme Raymo Longo <grlongo.ireland@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Subject: VIDIOC_QUERYCAP: Invalid argument - app from scratch for an USB
	GENIUS videoCAM Look 310p
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

Good morning gentleman.

I am building my first driver from scratch and I am hanving a hard time
trying to figure all the steps I have to follow to get to what I need to
achieve.

What I am trying to do now is to develop a application to activate my webcam
and to start capturing!

I am getting the following error trying to query the capabilities:

VIDIOC_QUERYCAP: Invalid argument

I am implementing the video capturing interface and that is what I have got
so far:
http://pastebin.com/m4b5bdd36

Could I get some help from here??
My webcam is an usb Genius videoCAM look 310p
I am using Slackware 13 and v4l2 api that I am following from here:
http://v4l2spec.bytesex.org/spec/

It works great on amsn and others applications so I presume I can develop I
application to make it work!

Thanks all in advanced!
Guilherme Longo
Software deloper
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
