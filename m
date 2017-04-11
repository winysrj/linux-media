Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57412 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752224AbdDKSlu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 14:41:50 -0400
Date: Tue, 11 Apr 2017 20:41:40 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 00/21] Convert USB documentation to ReST format
Message-ID: <20170411184140.GA26792@kroah.com>
References: <cover.1491398120.git.mchehab@s-opensource.com>
 <20170408112328.7cc07f53@lwn.net>
 <20170408200433.GA28427@kroah.com>
 <20170411145840.GA10692@kroah.com>
 <20170411153639.65e52a6c@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170411153639.65e52a6c@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 11, 2017 at 03:36:39PM -0300, Mauro Carvalho Chehab wrote:
> Em Tue, 11 Apr 2017 16:58:40 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:
> 
> > On Sat, Apr 08, 2017 at 10:04:33PM +0200, Greg Kroah-Hartman wrote:
> > > On Sat, Apr 08, 2017 at 11:23:28AM -0600, Jonathan Corbet wrote:  
> > > > On Wed,  5 Apr 2017 10:22:54 -0300
> > > > Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> > > >   
> > > > > Currently, there are several USB core documents that are at either
> > > > > written in plain text or in DocBook format. Convert them to ReST
> > > > > and add to the driver-api book.  
> > > > 
> > > > Greg, do you see any reason not to apply these for 4.12?  A few of them
> > > > touch comments outside of Documentation/; I'm happy to carry those or
> > > > leave them to you, as you prefer.  
> > > 
> > > I'll queue them up in the next few days, thanks!  
> > 
> > Nope, they don't apply to my tree, it was probably based on yours.  And
> > the first two are ones I shouldn't be taking.
> 
> Yeah, I based it at the docs-next tree. If you prefer, I can rebase
> on your tree, but I guess that the docbook conversion patches
> would likely conflict with some patches at docs-next, because of
> the Makefile changes.

Doesn't bother me, it can go through the Documentation tree as-is.

thanks,

greg k-h
