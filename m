Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAFCgPU0027334
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 07:42:25 -0500
Received: from mail4.aster.pl (mail4.aster.pl [212.76.33.58])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAFCg5bP013670
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 07:42:05 -0500
From: "daniel.perzynski" <daniel.perzynski@aster.pl>
To: video4linux-list@redhat.com
Cc: 
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Message-Id: <EACE05E33CF814870362B58660E45DEF122675291943CCA4B3DE2097B955@webmail.aster.pl>
Date: Sat, 15 Nov 2008 13:42:04 +0100 (CET)
Subject: Re: [Bulk] [linux-dvb] Avermedia A312
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


> > > Hi,
> > > I would like to help identify and develop (I can do a testing
> and
> > > debug) driver for Avermedia A312 mini pci card. Link to the
> > product
> > > page:
> > >
> http://www.avermedia.com/AVerTV/Product/ProductDetail.aspx?Id=378.
> > >
> > > Please find attached lsusb output for that card and windows x64
> > inf
> > > driver file.
> > >
> > > If you have any questions please let me know.
> > >
> >
> > As developers are in short supply, you may have to do a lot more
> > then
> > debugging if you want to get this to work under Linux (i.e. you
> > might
> > have to do the development yourself).  Anyway, a good start would
> be
> > if
> > you could identify the component chips being used on the device --
> > and
> > if you can take a high res picture and submit it to the wiki(
> >
>
http://www.linuxtv.org/wiki/index.php?title=AVerMedia_A312_(ATSC)&action=edit
> >
> > )
> >
> > This thing (mini pci card) has an usb interface?  Strange.
> >
> >
> >
Thanks for the info. I'm in the process of gathering those hi res
pictures but not only for A312 but also for A301 and A321 models.
Then I will update the wiki for them. A301 is very similar to A312
from
windows driver inf file point of view and is supported under Linux
by Avermedia A828 driver. Unfortunately adding A312 device id to the
source code of A828 driver didn't help.

What is concerning mini pci having usb interface I can say only that
on Avermedia webpage that card is in Mini PCI & Mini Card category.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
