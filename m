Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8F2O0bE026880
	for <video4linux-list@redhat.com>; Mon, 14 Sep 2009 22:24:00 -0400
Received: from mail-px0-f135.google.com (mail-px0-f135.google.com
	[209.85.216.135])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8F2NoMB020639
	for <video4linux-list@redhat.com>; Mon, 14 Sep 2009 22:23:50 -0400
Received: by pxi41 with SMTP id 41so317347pxi.30
	for <video4linux-list@redhat.com>; Mon, 14 Sep 2009 19:23:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090914202855.61b5e8ea@tele>
References: <25f5fcff0909110020m56f881d0q383aae1f5226476@mail.gmail.com>
	<b89eadb20909110234v2b8ee579nc19eed163cc77463@mail.gmail.com>
	<25f5fcff0909110507y635aa97eg1d599710372a6e9e@mail.gmail.com>
	<20090912082426.2dfba603@tele>
	<25f5fcff0909141100m49db178cu178801a4d4fd5976@mail.gmail.com>
	<20090914202855.61b5e8ea@tele>
Date: Tue, 15 Sep 2009 07:53:50 +0530
Message-ID: <25f5fcff0909141923p1c5a8bd6o8d5314b9b41bf975@mail.gmail.com>
From: Niamathullah sharief <newbiesha@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>, kernelnewbies@nl.linux.org,
	video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
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

Yes thank you..Now i am not getting my modules exactly. I compiled all the
required modules...ie gspca_main, gspca_zc3xx, v4l1-compat. But i am not
getting this "videodev" module..I dont know why...

My Makefile

*obj-m += gspca_main.o**
> *

*obj-m += gspca_zc3xx.o**
> *

*obj-m += v4l1-compat.o**
> *

*obj-m += v4l2-dev.o**
> *

*obj-m += v4l2-ioctl.o**
> *

*obj-m += v4l2-device.o*



> *gspca_main-objs := gspca.o**
> *

*gspca_zc3xx-objs := zc3xx.o**
> *

*videodev-objs := v4l2-dev.o v4l2-ioctl.o v4l2-device.o**
> *

*
> *

*all:**
> *

* make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules**
> *

*
> *

*clean:**
> *

* make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean*



if i compile i am getting the the modules as


* **sharief@sharief-desktop:~/Desktop/video/gspca$ make**
> *

*make -C /lib/modules/2.6.30/build M=/home/sharief/Desktop/video/gspca
> modules**
> *

*make[1]: Entering directory `/home/sharief/Desktop/kernelroot/linux-2.6.30'
> **
> *

* CC [M] /home/sharief/Desktop/video/gspca/gspca.o**
> *

* CC [M] /home/sharief/Desktop/video/gspca/zc3xx.o**
> *

* LD [M] /home/sharief/Desktop/video/gspca/gspca_main.o**
> *

* LD [M] /home/sharief/Desktop/video/gspca/gspca_zc3xx.o**
> *

* CC [M] /home/sharief/Desktop/video/gspca/v4l1-compat.o**
> *

* CC [M] /home/sharief/Desktop/video/gspca/v4l2-dev.o**
> *

* CC [M] /home/sharief/Desktop/video/gspca/v4l2-ioctl.o**
> *

* CC [M] /home/sharief/Desktop/video/gspca/v4l2-device.o**
> *

* Building modules, stage 2.**
> *

* MODPOST 6 modules**
> *

* CC /home/sharief/Desktop/video/gspca/gspca_main.mod.o**
> *

* LD [M] /home/sharief/Desktop/video/gspca/gspca_main.ko**
> *

* CC /home/sharief/Desktop/video/gspca/gspca_zc3xx.mod.o**
> *

* LD [M] /home/sharief/Desktop/video/gspca/gspca_zc3xx.ko**
> *

* CC /home/sharief/Desktop/video/gspca/v4l1-compat.mod.o**
> *

* LD [M] /home/sharief/Desktop/video/gspca/v4l1-compat.ko**
> *

* CC /home/sharief/Desktop/video/gspca/v4l2-dev.mod.o**
> *

* LD [M] /home/sharief/Desktop/video/gspca/v4l2-dev.ko**
> *

* CC /home/sharief/Desktop/video/gspca/v4l2-device.mod.o**
> *

* LD [M] /home/sharief/Desktop/video/gspca/v4l2-device.ko**
> *

* CC /home/sharief/Desktop/video/gspca/v4l2-ioctl.mod.o**
> *

* LD [M] /home/sharief/Desktop/video/gspca/v4l2-ioctl.ko*


  I dont know why i am getting like this...?Please help me
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
