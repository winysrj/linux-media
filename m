Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p0JJtYCR024869
	for <video4linux-list@redhat.com>; Wed, 19 Jan 2011 14:55:34 -0500
Received: from mail-iw0-f174.google.com (mail-iw0-f174.google.com
	[209.85.214.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0JJtMXQ009265
	for <video4linux-list@redhat.com>; Wed, 19 Jan 2011 14:55:22 -0500
Received: by iwn9 with SMTP id 9so1234472iwn.33
	for <video4linux-list@redhat.com>; Wed, 19 Jan 2011 11:55:22 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 19 Jan 2011 19:51:07 +0100
Message-ID: <AANLkTi=HzxMG-nKKEtHsvKnkSHgC2yf-kbYhfLOHiaAZ@mail.gmail.com>
Subject: GIGABYTE GT-P8000
From: =?ISO-8859-1?Q?Norbert_Pl=F3t=E1r?= <plotter008@gmail.com>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

HI,

 I'm not a professional, but a motivated amateur and I would like to
modify the SAA7134/v4l driver
  in my kernel to support the card mentioned in the title.
 I have some logs and some results, but my main problem is that I
cannot see how the driver should works.
 I mean which module calls in the others, and where starts the whole thing. :)
 As far as I could see more than one module contains for example
tda829x specific parts.
 My other problem is I haven't got any circuit diagram to know the
connections, but I guess it is a usual thing.
 Furthermore in my future plans I would like to use this hybrid card
as a signal processor module for some kind of hobby,
  and to give a good start to others.
 In my plan I would like to prepare a GUI, where I could modify all of
the parameters in all chips on the board, but I guess
  the limitations in ioctl are much more strong than I could achieve that.
 Could you please help me, how should I start working, or much better,
how should I continue.. :)

Thanks a lot!
Regards,
Norbert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
