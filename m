Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:60785
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752291AbdDKSgq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 14:36:46 -0400
Date: Tue, 11 Apr 2017 15:36:39 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 00/21] Convert USB documentation to ReST format
Message-ID: <20170411153639.65e52a6c@vento.lan>
In-Reply-To: <20170411145840.GA10692@kroah.com>
References: <cover.1491398120.git.mchehab@s-opensource.com>
        <20170408112328.7cc07f53@lwn.net>
        <20170408200433.GA28427@kroah.com>
        <20170411145840.GA10692@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Apr 2017 16:58:40 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:

> On Sat, Apr 08, 2017 at 10:04:33PM +0200, Greg Kroah-Hartman wrote:
> > On Sat, Apr 08, 2017 at 11:23:28AM -0600, Jonathan Corbet wrote:  
> > > On Wed,  5 Apr 2017 10:22:54 -0300
> > > Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> > >   
> > > > Currently, there are several USB core documents that are at either
> > > > written in plain text or in DocBook format. Convert them to ReST
> > > > and add to the driver-api book.  
> > > 
> > > Greg, do you see any reason not to apply these for 4.12?  A few of them
> > > touch comments outside of Documentation/; I'm happy to carry those or
> > > leave them to you, as you prefer.  
> > 
> > I'll queue them up in the next few days, thanks!  
> 
> Nope, they don't apply to my tree, it was probably based on yours.  And
> the first two are ones I shouldn't be taking.

Yeah, I based it at the docs-next tree. If you prefer, I can rebase
on your tree, but I guess that the docbook conversion patches
would likely conflict with some patches at docs-next, because of
the Makefile changes.

> So, feel free to take all of these with a:
> 	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> for the USB-related patches (2-21).
> 
> thanks,
> 
> greg k-h



Thanks,
Mauro
