Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5NNpK4R019056
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 19:51:20 -0400
Received: from n0sq.us (mo-65-41-216-18.sta.embarqhsd.net [65.41.216.18])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5NNp70W011165
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 19:51:10 -0400
Received: from server2.lan (server2 [192.168.1.4])
	by n0sq.us (Postfix) with ESMTP id 45DF21827FF
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 17:50:56 -0600 (MDT)
From: engage <engage@n0sq.us>
To: video4linux-list@redhat.com
Date: Mon, 23 Jun 2008 17:50:49 -0600
References: <200806061812.30755.engage@n0sq.us>
	<1214216844.2263.36.camel@localhost>
In-Reply-To: <1214216844.2263.36.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231750.49518.engage@n0sq.us>
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

On Monday 23 June 2008 04:27:24 Jean-Francois Moine wrote:
> On Fri, 2008-06-06 at 18:12 -0600, engage wrote:
> > I don't know if I'm OT but I believe that v4l is used with usb webcams. I
> > just bought an HP webcam but can't get it to work in Mandriva 2008.1 with
> > amsn or camorama on any PC. lsusb says it's a Pixart Imaging device.
> >
> > lsusb output:
> >
> > Bus 003 Device 002: ID 093a:2621 Pixart Imaging, Inc.
>
> 	[snip]
>
> May you try gspca v2? (get the tarball from my web page)
>
> Regards.

I tried to build it but got this error message:

make: depmod: Command not found.

Googling brought up links saying that depmod isn't on my system. But, whereis 
depmod returns depmod: /sbin/depmod.

How do I fix this problem so that I can install gspca v2?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
