Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4S2luE9031235
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 22:47:56 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4S2lh6K029437
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 22:47:44 -0400
Received: by wf-out-1314.google.com with SMTP id 25so2339599wfc.6
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 19:47:43 -0700 (PDT)
Message-ID: <412bdbff0805271947h23f71911vb8f13c76ffb7c6d2@mail.gmail.com>
Date: Tue, 27 May 2008 22:47:42 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1211942221.3197.154.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080522223700.2f103a14@core>
	<20080527094144.1189826a@bike.lwn.net>
	<20080527133100.6a9302fb@gaivota>
	<20080527103755.1fd67ec1@bike.lwn.net>
	<20080527155942.7693c360@gaivota>
	<412bdbff0805271226t41fe55b0jd0b8e3c737f34734@mail.gmail.com>
	<20080527180048.6a27dbf7@gaivota>
	<1211932138.3197.29.camel@palomino.walls.org>
	<412bdbff0805271746x3db9ae28h3c0f0b565f50d4c6@mail.gmail.com>
	<1211942221.3197.154.camel@palomino.walls.org>
Cc: video4linux-list@redhat.com, Jonathan Corbet <corbet@lwn.net>,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Alan Cox <alan@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] video4linux: Push down the BKL
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

> Maybe return an EBUSY or E-something else for these cases when Myth
> tries to open() the second device node, when there's an underlying
> factor that requires things to be mutually exclusive.  Allowing things
> like read() to allow hardware mode switching between analog and digital
> seems like it could result in really weird behaviors at the application.

Pardon me for not being clear.  I wasn't suggesting having a mutex for
on the open call itself.  The mutex we have in the em28xx driver is
only in place when we are *switching* between modes.  The thinking was
to have open return EBUSY if the device is already in use in the other
mode, but we weren't sure if that would cause problems with MythTV
(since the open call would fail)  If MythTV can gracefully handle that
scenario, then that would be the ideal solution from a driver
perspective.

> But in this case I can't.  The driver probably shouldn't hold a lock and
> suspend an open() indefinitely (IMO).  It should say the device is BUSY
> as that is the truth: an underlying hardware device or resource is busy.

Yeah, this was just me not being clear.

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
