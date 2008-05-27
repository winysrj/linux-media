Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4RJYSO2017221
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 15:34:29 -0400
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4RJXmCc010094
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 15:33:48 -0400
Received: by rn-out-0910.google.com with SMTP id j77so1660515rne.7
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 12:33:48 -0700 (PDT)
Message-ID: <412bdbff0805271226t41fe55b0jd0b8e3c737f34734@mail.gmail.com>
Date: Tue, 27 May 2008 15:26:27 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <20080527155942.7693c360@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080522223700.2f103a14@core> <20080526135951.7989516d@gaivota>
	<20080526202317.GA12793@devserv.devel.redhat.com>
	<20080526181027.1ff9c758@gaivota>
	<20080526220154.GA15487@devserv.devel.redhat.com>
	<20080527101039.1c0a3804@gaivota>
	<20080527094144.1189826a@bike.lwn.net>
	<20080527133100.6a9302fb@gaivota>
	<20080527103755.1fd67ec1@bike.lwn.net>
	<20080527155942.7693c360@gaivota>
Cc: Alan Cox <alan@redhat.com>, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jonathan Corbet <corbet@lwn.net>
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

Hello Mauro,

On Tue, May 27, 2008 at 2:59 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> For example, em28xx has already a lock at the operations that change values at
> "dev" struct, including open() method. However, since the lock is not called at
> get operations, it needs to be fixed. I would also change it from mutex to a
> read/write semaphore, since two (or more) get operations can safely happen in
> parallel.

Please bear in mind that we have not worked out the locking semantics
for hybrid tuner devices, and it's entirely possible that the get()
routines will need to switch the tuner mode, which would eliminate any
benefits of converting to a read/write semaphore.

I'm not sure yet exactly how that's going to work, but it's something
that might prompt you to defer converting it from a mutex until we
have that worked out.

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
