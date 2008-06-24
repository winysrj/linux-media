Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5O0JQmj029734
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 20:19:26 -0400
Received: from n0sq.us (mo-65-41-216-18.sta.embarqhsd.net [65.41.216.18])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5O0JFhC024173
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 20:19:16 -0400
Received: from server2.lan (server2 [192.168.1.4])
	by n0sq.us (Postfix) with ESMTP id 50B6D1827FF
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 18:19:04 -0600 (MDT)
From: engage <engage@n0sq.us>
To: video4linux-list@redhat.com
Date: Mon, 23 Jun 2008 18:18:57 -0600
References: <200806061812.30755.engage@n0sq.us>
	<1214216844.2263.36.camel@localhost>
	<200806231750.49518.engage@n0sq.us>
In-Reply-To: <200806231750.49518.engage@n0sq.us>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200806231818.57717.engage@n0sq.us>
Content-Transfer-Encoding: 8bit
Subject: Re: webcams
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

On Monday 23 June 2008 17:50:49 engage wrote:
> On Monday 23 June 2008 04:27:24 Jean-Francois Moine wrote:
> > On Fri, 2008-06-06 at 18:12 -0600, engage wrote:
> > > I don't know if I'm OT but I believe that v4l is used with usb webcams.
> > > I just bought an HP webcam but can't get it to work in Mandriva 2008.1
> > > with amsn or camorama on any PC. lsusb says it's a Pixart Imaging
> > > device.
> > >
> > > lsusb output:
> > >
> > > Bus 003 Device 002: ID 093a:2621 Pixart Imaging, Inc.
> >
> > 	[snip]
> >
> > May you try gspca v2? (get the tarball from my web page)
> >
> > Regards.
>
> I tried to build it but got this error message:
>
> make: depmod: Command not found.
>
> Googling brought up links saying that depmod isn't on my system. But,
> whereis depmod returns depmod: /sbin/depmod.
>
> How do I fix this problem so that I can install gspca v2?
>

My bad. I tried to install with su -c instead of logging in as su.  But, the 
HP webcam still doesn't work. amsn reports that it can't capture from the 
device. 

>From dmesg:

usb 2-1: new full speed USB device using uhci_hcd and address 3
usb 2-1: configuration #1 chosen from 1 choice
gspca: probing 093a:2621
gspca: probe ok
usbcore: registered new interface driver pac7311
pac7311: v0.2.13 registered
uhci_hcd 0000:00:11.3: host system error, PCI problems?
uhci_hcd 0000:00:11.3: host controller halted, very bad!
uhci_hcd 0000:00:11.3: HC died; cleaning up
usb 2-1: USB disconnect, address 3
gspca: usb_submit_urb [0] err -19
gspca: disconnect complete

And I can't adjust hue or color with my other webcam - Logitech Communicate 
STX Plus.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
