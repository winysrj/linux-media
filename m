Return-path: <linux-media-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:41366 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752260AbZKJRJH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 12:09:07 -0500
Received: from chimera.site ([96.253.169.185]) by xenotime.net for <linux-media@vger.kernel.org>; Tue, 10 Nov 2009 09:09:11 -0800
Date: Tue, 10 Nov 2009 09:09:10 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Michael Trimarchi <michael@panicking.kicks-ass.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: ov538-ov7690
Message-Id: <20091110090910.18f32748.rdunlap@xenotime.net>
In-Reply-To: <4AF99A03.7070303@panicking.kicks-ass.org>
References: <4AF89498.3000103@panicking.kicks-ass.org>
	<4AF93DE5.6060901@panicking.kicks-ass.org>
	<20091110081000.9e7c7717.rdunlap@xenotime.net>
	<4AF99A03.7070303@panicking.kicks-ass.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Nov 2009 17:51:15 +0100 Michael Trimarchi wrote:

> Hi,
> 
> Randy Dunlap wrote:
> > On Tue, 10 Nov 2009 11:18:13 +0100 Michael Trimarchi wrote:
> > 
> >> Hi,
> >>
> >> Michael Trimarchi wrote:
> >>> Hi all
> >>>
> >>> I'm working on the ov538 bridge with the ov7690 camera connected. 
> >>> Somentimes I receive
> >>>
> >>> [ 1268.146705] gspca: ISOC data error: [110] len=1020, status=-71
> >>> [ 1270.946739] gspca: ISOC data error: [114] len=1020, status=-71
> >>> [ 1271.426689] gspca: ISOC data error: [82] len=1020, status=-71
> >>> [ 1273.314640] gspca: ISOC data error: [1] len=1020, status=-71
> >>> [ 1274.114661] gspca: ISOC data error: [17] len=1020, status=-71
> >>> [ 1274.658718] gspca: ISOC data error: [125] len=1020, status=-71
> >>> [ 1274.834666] gspca: ISOC data error: [21] len=1020, status=-71
> >>> [ 1275.666684] gspca: ISOC data error: [94] len=1020, status=-71
> >>> [ 1275.826645] gspca: ISOC data error: [40] len=1020, status=-71
> >>> [ 1276.226721] gspca: ISOC data error: [100] len=1020, status=-71
> >>>
> >>> This error from the usb, how are they related to the camera?
> > 
> > -71 = -EPROTO (from include/asm-generic/errno.h).
> > 
> > -EPROTO in USB drivers means (from Documentation/usb/error-codes.txt):
> > 
> > -EPROTO (*, **)		a) bitstuff error
> > 			b) no response packet received within the
> > 			   prescribed bus turn-around time
> > 			c) unknown USB error
> > 
> > footnotes:
> > (*) Error codes like -EPROTO, -EILSEQ and -EOVERFLOW normally indicate
> > hardware problems such as bad devices (including firmware) or cables.
> > 
> 
> OK, but it's a failure of the ehci transaction on my laptop and seems that is
> not so frequent. I think that can be a cable problem.

Probably could be a cable problem.

If you suspect that it is a USB (ehci) problem, you should raise this issue
on the linux-usb@vger.kernel.org mailing list.

> > (**) This is also one of several codes that different kinds of host
> > controller use to indicate a transfer has failed because of device
> > disconnect.  In the interval before the hub driver starts disconnect
> > processing, devices may receive such fault reports for every request.
> > 
> > 
> >> Ok, this is not a big issue because I can use vlc to test the camera. But anybody
> >> knows why camorama, camstream, cheese crash during test. is it driver depend? or not?
> > 
> > Could be driver.  Easily could be a device problem too.
> 
> I think that it can be a vl2 vl1 problem. Because now I can manage in skype too using
> the v4l1-compat library. Maybe my 2.6.32-rc5 is too new :(

I don't even know what vl2 vl1 means. ;)


---
~Randy
