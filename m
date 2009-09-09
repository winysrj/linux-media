Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n89LbQjV010850
	for <video4linux-list@redhat.com>; Wed, 9 Sep 2009 17:37:26 -0400
Received: from mail-fx0-f209.google.com (mail-fx0-f209.google.com
	[209.85.220.209])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n89LbFvT030085
	for <video4linux-list@redhat.com>; Wed, 9 Sep 2009 17:37:15 -0400
Received: by fxm5 with SMTP id 5so985242fxm.3
	for <video4linux-list@redhat.com>; Wed, 09 Sep 2009 14:37:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7E8593.2030500@gmx.de>
References: <4A7E8593.2030500@gmx.de>
Date: Wed, 9 Sep 2009 17:37:14 -0400
Message-ID: <a728f9f90909091437x5e91a9f9y7c186be30f53973a@mail.gmail.com>
From: Alex Deucher <alexdeucher@gmail.com>
To: Stefan Sassenberg <stefan.sassenberg@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Cc: video4linux-list@redhat.com
Subject: Re: xf86-video-v4l
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

On Sun, Aug 9, 2009 at 4:15 AM, Stefan
Sassenberg<stefan.sassenberg@gmx.de> wrote:
> Hello,
>
> what does the xf86-video-v4l driver do? I think I know the purpose of
> xf86-video-<graphics_card> drivers, but I don't know what the -v4l does. How
> is it used?

It's an old Xv ddx that exposes v4l1 adapters as Xv adapters.  It was
useful about 8-10 years ago, but at this point it's pretty bit-rotten.

Alex

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
