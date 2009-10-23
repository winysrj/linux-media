Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:52390 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751695AbZJWWOc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 18:14:32 -0400
Date: Fri, 23 Oct 2009 18:14:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: uvcvideo causes ehci_hcd to halt
In-Reply-To: <4AE158D7.6000900@pardus.org.tr>
Message-ID: <Pine.LNX.4.44L0.0910231809290.31680-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 23 Oct 2009, [UTF-8] Ozan Çağlayan wrote:

> > There's something odd about this.  I'd like to see this file again, 
> > after the patch below has been applied.
> >   
> 
> periodic
> size = 1024
>    1:  qh1024-0001/f6ffe280 (h2 ep2 [1/0] q0 p8) t00000000

On closer study and more careful thought, there's nothing odd here at
all.  This is what would be expected given the bug that you saw.

> After putting a udelay() the problem seems to be resolved. I did a
> rmmod-modprobe-sleep in 50 iterations,  and the host controller was
> still functional along with the web-cam:

Okay, that proves this really is a timing bug in the hardware.  But we
can't go around putting 2-millisecond delays in the kernel!  Maybe you
can test to see if smaller delays will fix the problem.  If 50
microseconds or less doesn't work then it will be necessary to add a
new timer to ehci-hcd.

Alan Stern

