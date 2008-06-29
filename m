Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5T29jjv011061
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 22:09:45 -0400
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net
	[151.189.21.49])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5T28o82006577
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 22:08:50 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080628214335.40185450@gaivota>
References: <20080626231551.GA20012@kroah.com>
	<20080628083154.33d3a93d@gaivota>
	<1214690914.7722.10.camel@pc10.localdom.local>
	<20080628214335.40185450@gaivota>
Content-Type: text/plain
Date: Sun, 29 Jun 2008 04:05:30 +0200
Message-Id: <1214705130.2639.3.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Greg KH <greg@kroah.com>,
	linux-usb@vger.kernel.org, dean@sensoray.com,
	linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] add Sensoray 2255 v4l driver
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


Am Samstag, den 28.06.2008, 21:43 -0300 schrieb Mauro Carvalho Chehab:
> Hi Hermann,
> 
> On Sun, 29 Jun 2008 00:08:34 +0200
> hermann pitton <hermann-pitton@arcor.de> wrote:
> 
> 
> > On an attempt to get recent drivers on a FC8 x86_64 machine to watch
> > Glastonbury music festival on BBC HD DVB-S with the saa714 driver on an
> > recently updated 2.6.25 FC kernel it also fails to compile on some
> > strlcpy attempt. Same with a 2.6.24 on the mail machine here.
> > 
> >   CC [M]  /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/quickcam_messenger.o
> >   CC [M]  /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.o
> > /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.c: In function 'vidioc_querycap':
> > /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.c:809: error: implicit declaration of function 'dev_name'
> > /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/s2255drv.c:809: warning: passing argument 2 of 'strlcpy' makes pointer from integer without a cast
> 
> The code is not backward compatible. It works only with 2.6.27-rc.
> 
> I'll add the macro ballow at compat.h to allow its out of tree compilation:
> 
> #define dev_name(dev)  ((dev)->bus_id)
> 
> This simple macro worked fine with 2.6.25.6.
> 
> Cheers,
> Mauro

Seems we had some crossed and delayed mails all over it.

I'll continue to cry, whenever it hurts.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
