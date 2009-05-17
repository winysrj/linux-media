Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:60540 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbZEQWa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 18:30:59 -0400
Received: by gxk10 with SMTP id 10so5650585gxk.13
        for <linux-media@vger.kernel.org>; Sun, 17 May 2009 15:31:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242576510.1986.0@lhost.ldomain>
References: <alpine.LNX.2.00.0905141424460.11396@banach.math.auburn.edu>
	 <1242576510.1986.0@lhost.ldomain>
Date: Sun, 17 May 2009 18:31:00 -0400
Message-ID: <c2fe070d0905171531l9b2378do62fd2b7310f29e7d@mail.gmail.com>
Subject: Re: working on webcam driver
From: leandro Costantino <lcostantino@gmail.com>
To: video4linux-list@redhat.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mark,
just searching "0c45:612a gspca" could save you lot of time.
I suppose you were looking at the old gspca homepage, because it
listed on Jean F. Moine site
http://moinejf.free.fr/webcam.html ( it dont know even it that page if
still updated )

About the "gstreamer", what kind of troubles are you having?. It's the
webcam streaming?
Did you follow the steps using libv4lconvert?.

I wrote that patch a year ago, so , if there's any problem let me know.
If you need help, about the lib4vlconvert thing, look at deaglecito.blogspot.com

Best Regards
Costantino Leandro

On Sun, May 17, 2009 at 12:08 PM, MK <halfcountplus@intergate.com> wrote:
> Thanks much for the feedback!  Here's what happened:
>
> Because the vendor id (0c45) is listed by the gspca website but not
> the product (612a), I decided to try inserting the id into one of the
> drivers/media/video/gspca.  When I actually grepped (had not grepped
> the tree itself yet), low and behold 612a is in sonixj.  The module
> compiles and responds to the camera, although the results in gstreamer,
> et. al, are disappointing -- the camera is not really usable, I suspect
> from the output it is the kernel driver, but I am not sure.  Since I
> didn't write this stuff, I think working alone it will be more trouble
> than it is worth to track the problem down, esp. if this is mostly a
> problem with an (obscure) inexpensive item that few linux users
> actually possess.
>
> So, I am going to cut my "loses" early on this project and cop out.
> I've learned a bunch about the kernel and in the process written some
> nifty little char drivers that are probably more useful to me than a
> webcam anyway. I think my time would be better spent on other things,
> eg, I might become useful in someone else's (more significant) linux
> kernel/driver project.  I will have a look around.
>
> But thanks again!  You were much nicer than mr Greg Kroah-Hartman ;) :0
>
> Sincerely, Mark Eriksen (getting his feet wet)
>
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
