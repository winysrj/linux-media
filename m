Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o0M6jbt0023805
	for <video4linux-list@redhat.com>; Fri, 22 Jan 2010 01:45:37 -0500
Received: from mail-fx0-f216.google.com (mail-fx0-f216.google.com
	[209.85.220.216])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0M6jM9x013189
	for <video4linux-list@redhat.com>; Fri, 22 Jan 2010 01:45:22 -0500
Received: by fxm8 with SMTP id 8so954479fxm.27
	for <video4linux-list@redhat.com>; Thu, 21 Jan 2010 22:45:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49418.71.237.141.102.1264142487.squirrel@sensoray.com>
References: <13c9a3ca1001211916n558736e9ic8dc17f4dfe99d37@mail.gmail.com>
	<49418.71.237.141.102.1264142487.squirrel@sensoray.com>
Date: Thu, 21 Jan 2010 22:45:21 -0800
Message-ID: <13c9a3ca1001212245j7a271fd2wa4f8a75e903606d8@mail.gmail.com>
Subject: Re: streamer
From: Cristiana Tenti <cristenti@gmail.com>
To: charlie@sensoray.com
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,
first of all thank you for your answer!!

So, I can compile every in my Ubuntu-pc and then what have I to crosscompile
for uclinux?

Can I only copy and move streamer?
And what is it? an executable file stand alone?

Thank you so much!!

2010/1/21 <charlie@sensoray.com>

> You may compile whole xawtv against the same kernel that you will use for
> uclinux, with a development PC. Then, copy and move the streamer to your
> target uclinux platform. Sure, the streamer is a really good capture
> tool/utility. I like it too.
>
> > Hello,
> > I'm a new user :)
> >
> > I'm working on a simple project and for that I only need to a software
> for
> > uclinux to acquire a raw image from my usb webcam.
> > On Ubuntu I'm using STREAMER but I cannot find the source code to install
> > it
> > on my uclinux platform.
> >
> > Anyway I found xawtv and I saw that this usefull software has as tool
> > STREAMER.
> >
> > Do you know if it is possible compile only streamer and not all package
> of
> > xawtv?
> >
> > Please, if you can help me answer me!!!
> >
> > Thank you in advance,
> >
> > Best Regards
> >
> > --
> > -Cristiana
> > --
> > video4linux-list mailing list
> > Unsubscribe mailto:video4linux-list-request@redhat.com
> ?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
> >
>
>


-- 
-Cristiana
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
