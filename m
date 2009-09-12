Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8C6OpAO025397
	for <video4linux-list@redhat.com>; Sat, 12 Sep 2009 02:24:51 -0400
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8C6OXHx016324
	for <video4linux-list@redhat.com>; Sat, 12 Sep 2009 02:24:38 -0400
Date: Sat, 12 Sep 2009 08:24:26 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Niamathullah sharief <newbiesha@gmail.com>
Message-ID: <20090912082426.2dfba603@tele>
In-Reply-To: <25f5fcff0909110507y635aa97eg1d599710372a6e9e@mail.gmail.com>
References: <25f5fcff0909110020m56f881d0q383aae1f5226476@mail.gmail.com>
	<b89eadb20909110234v2b8ee579nc19eed163cc77463@mail.gmail.com>
	<25f5fcff0909110507y635aa97eg1d599710372a6e9e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Steven Yao <yaohaiping.linux@gmail.com>, kernelnewbies@nl.linux.org,
	video4linux-list@redhat.com
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

On Fri, 11 Sep 2009 17:37:19 +0530
Niamathullah sharief <newbiesha@gmail.com> wrote:

	[snip]
> sharief@sharief-desktop:~$ modinfo -d gspca_zc3xx
> >
> GSPCA ZC03xx/VC3xx USB Camera Driver
> >
> sharief@sharief-desktop:~$ modinfo -d gspca_main
> >
> GSPCA USB Camera Driver
> >
> sharief@sharief-desktop:~$ modinfo -d videodev
> >
> Device registrar for Video4Linux drivers v2
> >
> sharief@sharief-desktop:~$ modinfo -d v4l1_compat
> >
> v4l(1) compatibility layer for v4l2 drivers.
> >
> sharief@sharief-desktop:~$
> >
> 
> So first two things are showing as camera driver. bur how it is
> possible. kindly help me

Hi,

The driver of a USB device is easily found looking at
	/lib/modules/`uname -r`/modules.usbmap

So, your driver is gspca_zc3xx. Then, this module uses the gspca
framework, i.e it calls functions of the module gspca_main. This last
one calls functions of the common video module videodev. Then again, if
v4l1 compatibility is enabled, videodev calls functions of v4l1_compat.

lsmod shows all that directly:

Module              Size   Used by
gspca_zc3xx        55936   0
gspca_main         29312   1   gspca_zc3xx
videodev           41344   1   gspca_main 
v4l1_compat        22404   1   videodev

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
