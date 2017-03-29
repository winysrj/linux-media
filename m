Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:43762
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751468AbdC2StR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 14:49:17 -0400
Date: Wed, 29 Mar 2017 15:49:09 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH RFC] dwc2: Don't assume URB transfer_buffer are
 dword-aligned
Message-ID: <20170329154909.44d36de2@vento.lan>
In-Reply-To: <20170329095722.GC20830@kroah.com>
References: <5c313be6d2f3c786d1f159a74758263a2ae0ad66.1489709097.git.mchehab@s-opensource.com>
        <20170317012415.GA31588@kroah.com>
        <20170328064802.5ab9208c@vento.lan>
        <20170329095722.GC20830@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 29 Mar 2017 11:57:22 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:

> On Tue, Mar 28, 2017 at 06:48:02AM -0300, Mauro Carvalho Chehab wrote:
> > Em Fri, 17 Mar 2017 10:24:15 +0900
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:
> >   
> > > On Thu, Mar 16, 2017 at 09:08:40PM -0300, Mauro Carvalho Chehab wrote:  
> > > > The dwc2 hardware doesn't like to do DMA transfers without
> > > > aligning data in DWORD. The driver also assumes that, even
> > > > when there's no DMA, at dwc2_read_packet().
> > > > 
> > > > That cause buffer overflows, preventing some drivers to work.    
> > > 
> > > Why aren't the drivers being fixed?  This is a well-known (hopefully)
> > > restriction on USB data buffers, can't the uvc_driver be fixed?  
> > 
> > I talked to Laurent about on IRC. He told that he is willing to consider
> > that option, if the USB API explicitly states that all buffers must be
> > dword-aligned (and/or buffer sizes).
> > 
> > IMHO, he has a point: if this is a restriction of for usb transfer
> > buffers, it should be documented somewhere.
> > 
> > Yet, a quick check with:
> > 	$ git grep -i dword Documentation/usb/
> > 	$ git grep -i align Documentation/usb/
> > 
> > Didn't hit anything related to it.   
> 
> Hm, most of the USB documentation is in the kerneldoc in the USB code
> itself, and is built that way.  I'm pretty sure this is documented
> somewhere, but I can't seem to find it at the moment either :(
> 
> Care to write a patch for that?  :)

Sure. Btw, I noticed that not all USB documents were converted
yet to ReST, so I took the time to convert the core documents to ReST
too.

I kept the driver-specific documentation at Documentation/usb.
The final result is at:
	http://www.infradead.org/~mchehab/kernel_docs/driver-api/usb/index.html

I'll be sending the documentation patches in a few.

Thanks,
Mauro
