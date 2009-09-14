Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8EI0b6D023011
	for <video4linux-list@redhat.com>; Mon, 14 Sep 2009 14:00:37 -0400
Received: from mail-px0-f135.google.com (mail-px0-f135.google.com
	[209.85.216.135])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8EI0R8W017337
	for <video4linux-list@redhat.com>; Mon, 14 Sep 2009 14:00:27 -0400
Received: by pxi41 with SMTP id 41so300400pxi.30
	for <video4linux-list@redhat.com>; Mon, 14 Sep 2009 11:00:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090912082426.2dfba603@tele>
References: <25f5fcff0909110020m56f881d0q383aae1f5226476@mail.gmail.com>
	<b89eadb20909110234v2b8ee579nc19eed163cc77463@mail.gmail.com>
	<25f5fcff0909110507y635aa97eg1d599710372a6e9e@mail.gmail.com>
	<20090912082426.2dfba603@tele>
Date: Mon, 14 Sep 2009 23:30:27 +0530
Message-ID: <25f5fcff0909141100m49db178cu178801a4d4fd5976@mail.gmail.com>
From: Niamathullah sharief <newbiesha@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>, kernelnewbies@nl.linux.org,
	video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: 
Subject: Re: About Webcam module
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

Here i am facing a new problem. I tried to compile and install the
gspca_main and gspca_zc3xx modules separately. I compiled them successfully=
.
but i am getting error when inserting that modules


root@sharief-desktop:/home/sharief/Desktop/video/gspca# insmod
> gspca_zc3xx.ko
>
insmod: error inserting 'gspca_zc3xx.ko': -1 Unknown symbol in module
>
root@sharief-desktop:/home/sharief/Desktop/video/gspca# insmod gspca_main.k=
o
>
>
insmod: error inserting 'gspca_main.ko': -1 Unknown symbol in module
>

I think this both modules what some other modules to get insert in to
kernel...But i am sure about that modules. Can anyone help me?





On Sat, Sep 12, 2009 at 11:54 AM, Jean-Francois Moine <moinejf@free.fr>wrot=
e:

> On Fri, 11 Sep 2009 17:37:19 +0530
> Niamathullah sharief <newbiesha@gmail.com> wrote:
>
>        [snip]
> > sharief@sharief-desktop:~$ modinfo -d gspca_zc3xx
> > >
> > GSPCA ZC03xx/VC3xx USB Camera Driver
> > >
> > sharief@sharief-desktop:~$ modinfo -d gspca_main
> > >
> > GSPCA USB Camera Driver
> > >
> > sharief@sharief-desktop:~$ modinfo -d videodev
> > >
> > Device registrar for Video4Linux drivers v2
> > >
> > sharief@sharief-desktop:~$ modinfo -d v4l1_compat
> > >
> > v4l(1) compatibility layer for v4l2 drivers.
> > >
> > sharief@sharief-desktop:~$
> > >
> >
> > So first two things are showing as camera driver. bur how it is
> > possible. kindly help me
>
> Hi,
>
> The driver of a USB device is easily found looking at
>        /lib/modules/`uname -r`/modules.usbmap
>
> So, your driver is gspca_zc3xx. Then, this module uses the gspca
> framework, i.e it calls functions of the module gspca_main. This last
> one calls functions of the common video module videodev. Then again, if
> v4l1 compatibility is enabled, videodev calls functions of v4l1_compat.
>
> lsmod shows all that directly:
>
> Module              Size   Used by
> gspca_zc3xx        55936   0
> gspca_main         29312   1   gspca_zc3xx
> videodev           41344   1   gspca_main
> v4l1_compat        22404   1   videodev
>
> Regards.
>
> --
> Ken ar c'henta=C5=84 |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
