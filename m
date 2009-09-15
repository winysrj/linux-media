Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8FGlTJ2004681
	for <video4linux-list@redhat.com>; Tue, 15 Sep 2009 12:47:29 -0400
Received: from mail-px0-f135.google.com (mail-px0-f135.google.com
	[209.85.216.135])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8FGlEJk031889
	for <video4linux-list@redhat.com>; Tue, 15 Sep 2009 12:47:14 -0400
Received: by pxi41 with SMTP id 41so375272pxi.30
	for <video4linux-list@redhat.com>; Tue, 15 Sep 2009 09:47:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090915161531.GA3013@michaelblizek.twilightparadox.com>
References: <25f5fcff0909150109s4a4b3f40tcab41dc78834006e@mail.gmail.com>
	<20090915161531.GA3013@michaelblizek.twilightparadox.com>
Date: Tue, 15 Sep 2009 22:17:13 +0530
Message-ID: <25f5fcff0909150947k68699266q782647ed8b319397@mail.gmail.com>
From: Niamathullah sharief <newbiesha@gmail.com>
To: Michael Blizek <michi1@michaelblizek.twilightparadox.com>
Content-Type: text/plain; charset=ISO-8859-1
Cc: kernelnewbies@nl.linux.org, video4linux-list@redhat.com
Subject: Re: Missing main function
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

No actually i disabled the entire "gspca" in kernel config before compiling
the kernel. The folder contains

* conex.c**
*
*etoms.c*
*finepix.c*
*gspca.c*
*gspca.h*
*jpeg.h*
*Kconfig*
*Makefile*
*mars.c*
*mr97310a.c*
*ov519.c*
*ov534.c*
*pac207.c*
*pac3711.c*
*pac_common.h*
*sonixb.c*
*sonixj.c*
*spca500.c*
*spca501.c*
*spca505.c*
*spca506.c*
*spca508.c*
*spca561.c*
*sq905.c*
*sq905c.c*
*stk014.c*
*sunplus.c*
*t613.c*
*tv8532.c*
*vc032x.c*
*zc3xx.c*
*zc3xx-reg.h*

  This are the files in that folder which i disabled. In this gspca.c
program the main function is missing.

On Tue, Sep 15, 2009 at 9:45 PM, Michael Blizek <
michi1@michaelblizek.twilightparadox.com> wrote:

> Hi!
>
> On 13:39 Tue 15 Sep     , Niamathullah sharief wrote:
> > Hi friends,
> >    I am having the video drivers..ie "gspca.c, v4l1.compat.c,
> v4l2-device.c,
> > v4l2-ioctl.c,v4l2-dev.c".
> >    When i tried to read all this programs but i didn't find main function
> in
> > any programs.
> >    I don't know how this programs works. From where is the main function
> for
> > this programs.
> >    I took this drivers from Version 2.6.30 kernel. Kindly help me.
>
> You might be looking for "module_init". It defines a function which is
> executed on kernel boot or module load time.
>
>        -Michi
> --
> programing a layer 3+4 network protocol for mesh networks
> see http://michaelblizek.twilightparadox.com
>
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
