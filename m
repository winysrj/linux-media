Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56598 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbZFSEi0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 00:38:26 -0400
Subject: Re: Sakar 57379 USB Digital Video Camera...
From: Andy Walls <awalls@radix.net>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.0906182113010.17417@banach.math.auburn.edu>
References: <1245375652.20630.6.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906182113010.17417@banach.math.auburn.edu>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 00:40:16 -0400
Message-Id: <1245386416.20630.31.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-06-18 at 21:43 -0500, Theodore Kilgore wrote:
> 
> On Thu, 18 Jun 2009, Andy Walls wrote:
> >
> >
> >
> 
> Interesting. To answer your question, I have no idea off the top of my 
> head. I do have what seems to be a similar camera. It is
> 
> Bus 005 Device 006: ID 0979:0371 Jeilin Technology Corp., Ltd
> 
> and the rest of the lsusb output looks quite similar. I do not know, 
> though, if it has any chance of working as a webcam. Somehow, the thought 
> never occurred to me back when I got the thing. I would have to hunt some 
> stuff down even to know if it is claimed to work as a webcam.

The packaging that mine came in claims "3-in-1":

digital video camcorder (with microphone)
digital camera
web cam


> You did say that it comes up as a different USB device when it is a 
> webcam? You mean, a different product ID or so?

Yes

Look for this in the original lsusb output I provided
:
> > Webcam mode:
> >
> > Bus 003 Device 005: ID 0979:0280 Jeilin Technology Corp., Ltd
> > Device Descriptor:

Regards,
Andy

