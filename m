Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8H5WkIN015506
	for <video4linux-list@redhat.com>; Thu, 17 Sep 2009 01:32:46 -0400
Received: from mail-pz0-f132.google.com (mail-pz0-f132.google.com
	[209.85.222.132])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8H5WSV6016320
	for <video4linux-list@redhat.com>; Thu, 17 Sep 2009 01:32:31 -0400
Received: by pzk38 with SMTP id 38so517080pzk.19
	for <video4linux-list@redhat.com>; Wed, 16 Sep 2009 22:32:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <41d311580909161827m3d8d59aam37b1a22396799335@mail.gmail.com>
References: <25f5fcff0909110020m56f881d0q383aae1f5226476@mail.gmail.com>
	<b89eadb20909110234v2b8ee579nc19eed163cc77463@mail.gmail.com>
	<25f5fcff0909110507y635aa97eg1d599710372a6e9e@mail.gmail.com>
	<20090912082426.2dfba603@tele>
	<25f5fcff0909141100m49db178cu178801a4d4fd5976@mail.gmail.com>
	<20090914202855.61b5e8ea@tele>
	<25f5fcff0909141923p1c5a8bd6o8d5314b9b41bf975@mail.gmail.com>
	<41d311580909160826v7ab50508k96ed1035558263f8@mail.gmail.com>
	<25f5fcff0909160957s789f1070n3a69904912f937ee@mail.gmail.com>
	<41d311580909161827m3d8d59aam37b1a22396799335@mail.gmail.com>
Date: Thu, 17 Sep 2009 11:02:25 +0530
Message-ID: <25f5fcff0909162232oad78e5cwa84cfe78713c47f3@mail.gmail.com>
From: Niamathullah sharief <newbiesha@gmail.com>
To: Pei Lin <telent997@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Cc: kernelnewbies@nl.linux.org, video4linux-list@redhat.com
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

yes pei,
   See i am using 2.6.30 kernel. And this module belongs to that kernel only

*sharief@sharief-desktop:/lib/modules$ ls
> *

*2.6.27-7-generic 2.6.30*
>


On Thu, Sep 17, 2009 at 6:57 AM, Pei Lin <telent997@gmail.com> wrote:

> When you get a module unrelated to the kernel distribution you should
> place it in one of the version-independent directories under
> /lib/modules.
>
> And do u place them in the right place ?
>
>
> 2009/9/17 Niamathullah sharief <newbiesha@gmail.com>:
> > Yes thank you...Its working fine...but i am having some doubt
> >
> > Insmod is working fine. But modprobe is not working properly..I know
> > modprobe will install all necessary dependent modules. But in this case
> all
> > dependent modules are already installed...But i dont know why its
> happening
> > here..Please help me..see below
> > root@sharief-desktop:/home/sharief/Desktop/video/gspca# modprobe
> v4l1_compat
> >>
> >> root@sharief-desktop:/home/sharief/Desktop/video/gspca# modprobe
> videodev
> >>
> >> root@sharief-desktop:/home/sharief/Desktop/video/gspca# modprobe
> >> gspca_main
> >>
> >> FATAL: Module gspca_main not found.
> >>
> >> root@sharief-desktop:/home/sharief/Desktop/video/gspca# modprobe
> >> gspca_zc3xx
> >>
> >> FATAL: Module gspca_zc3xx not found.
> >>
> >> root@sharief-desktop:/home/sharief/Desktop/video/gspca# insmod
> >> gspca_main.ko
> >>
> >> root@sharief-desktop:/home/sharief/Desktop/video/gspca# insmod
> >> gspca_zc3xx.ko
> >>
> >> root@sharief-desktop:/home/sharief/Desktop/video/gspca#
> >
> >  Please help me....what will be the error
> >
> > On Wed, Sep 16, 2009 at 8:56 PM, Pei Lin <telent997@gmail.com> wrote:
> >>
> >> 2009/9/15 Niamathullah sharief <newbiesha@gmail.com>:
> >> >
> >> > Yes thank you..Now i am not getting my modules exactly. I compiled all
> >> > the
> >> > required modules...ie gspca_main, gspca_zc3xx, v4l1-compat. But i am
> not
> >> > getting this "videodev" module..I dont know why...
> >> > My Makefile
> >> >>
> >> >> obj-m += gspca_main.o
> >> >>
> >> >> obj-m += gspca_zc3xx.o
> >> >>
> >> >> obj-m += v4l1-compat.o
> >> >>
> >> >> obj-m += v4l2-dev.o
> >> >>
> >> >> obj-m += v4l2-ioctl.o
> >> >>
> >> >> obj-m += v4l2-device.o
> >> >
> >> >
> >> >>
> >> >> gspca_main-objs := gspca.o
> >> >>
> >> >> gspca_zc3xx-objs := zc3xx.o
> >> >>
> >> >> videodev-objs := v4l2-dev.o v4l2-ioctl.o v4l2-device.o
> >> >>
> >> what is the result u want to get ?
> >> Is it to make one videodev.ko file?
> >> So it should be like this:
> >> obj-m += gspca_main.o
> >> obj-m += gspca_zc3xx.o
> >> obj-m += videodev.o
> >> gspca_main-objs := gspca.o
> >> gspca_zc3xx-objs := zc3xx.o
> >> videodev-objs := v4l2-dev.o v4l2-ioctl.o v4l2-device.o
> >>
> >> u need read the document about kbuild,module and makefile
> >> http://lxr.linux.no/linux+v2.6.31/Documentation/kbuild/makefiles.txt
> >>
> >> >>
> >> >> all:
> >> >>
> >> >> make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
> >> >>
> >> >> clean:
> >> >>
> >> >> make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
> >> >
> >> > if i compile i am getting the the modules as
> >> >
> >> >
> >> >>  sharief@sharief-desktop:~/Desktop/video/gspca$ make
> >> >>
> >> >> make -C /lib/modules/2.6.30/build M=/home/sharief/Desktop/video/gspca
> >> >> modules
> >> >>
> >> >> make[1]: Entering directory
> >> >> `/home/sharief/Desktop/kernelroot/linux-2.6.30'
> >> >>
> >> >> CC [M] /home/sharief/Desktop/video/gspca/gspca.o
> >> >>
> >> >> CC [M] /home/sharief/Desktop/video/gspca/zc3xx.o
> >> >>
> >> >> LD [M] /home/sharief/Desktop/video/gspca/gspca_main.o
> >> >>
> >> >> LD [M] /home/sharief/Desktop/video/gspca/gspca_zc3xx.o
> >> >>
> >> >> CC [M] /home/sharief/Desktop/video/gspca/v4l1-compat.o
> >> >>
> >> >> CC [M] /home/sharief/Desktop/video/gspca/v4l2-dev.o
> >> >>
> >> >> CC [M] /home/sharief/Desktop/video/gspca/v4l2-ioctl.o
> >> >>
> >> >> CC [M] /home/sharief/Desktop/video/gspca/v4l2-device.o
> >> >>
> >> >> Building modules, stage 2.
> >> >>
> >> >> MODPOST 6 modules
> >> >>
> >> >> CC /home/sharief/Desktop/video/gspca/gspca_main.mod.o
> >> >>
> >> >> LD [M] /home/sharief/Desktop/video/gspca/gspca_main.ko
> >> >>
> >> >> CC /home/sharief/Desktop/video/gspca/gspca_zc3xx.mod.o
> >> >>
> >> >> LD [M] /home/sharief/Desktop/video/gspca/gspca_zc3xx.ko
> >> >>
> >> >> CC /home/sharief/Desktop/video/gspca/v4l1-compat.mod.o
> >> >>
> >> >> LD [M] /home/sharief/Desktop/video/gspca/v4l1-compat.ko
> >> >>
> >> >> CC /home/sharief/Desktop/video/gspca/v4l2-dev.mod.o
> >> >>
> >> >> LD [M] /home/sharief/Desktop/video/gspca/v4l2-dev.ko
> >> >>
> >> >> CC /home/sharief/Desktop/video/gspca/v4l2-device.mod.o
> >> >>
> >> >> LD [M] /home/sharief/Desktop/video/gspca/v4l2-device.ko
> >> >>
> >> >> CC /home/sharief/Desktop/video/gspca/v4l2-ioctl.mod.o
> >> >>
> >> >> LD [M] /home/sharief/Desktop/video/gspca/v4l2-ioctl.ko
> >> >
> >> >   I dont know why i am getting like this...?Please help me
> >> >
> >> >
> >> >
> >> >
> >>
> >>
> >>
> >> --
> >> Best Regards
> >> Lin
> >
> >
>
>
>
> --
> Best Regards
> Lin
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
