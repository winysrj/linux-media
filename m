Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:33606 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbZDWOvZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2009 10:51:25 -0400
Date: Wed, 22 Apr 2009 16:39:40 -0700
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: gregkh@suse.de, mfuzzey@gmail.com, linux-media@vger.kernel.org
Subject: Re: patch
	usb-pwc-do-not-pass-stack-allocated-buffers-to-usb-core.patch added
	to gregkh-2.6 tree
Message-ID: <20090422233940.GA17320@kroah.com>
References: <20090421194808.8272.8437.stgit@mfuzzey-laptop> <12404340242540@kroah.org> <20090422202050.6526c406@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422202050.6526c406@pedra.chehab.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 22, 2009 at 08:20:50PM -0300, Mauro Carvalho Chehab wrote:
> On Wed, 22 Apr 2009 14:00:24 -0700
> <gregkh@suse.de> wrote:
> 
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     Subject: USB: pwc : do not pass stack allocated buffers to USB core.
> > 
> > to my gregkh-2.6 tree.  Its filename is
> > 
> >     usb-pwc-do-not-pass-stack-allocated-buffers-to-usb-core.patch
> > 
> > This tree can be found at 
> >     http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/
> > 
> > 
> > From mfuzzey@gmail.com  Wed Apr 22 13:31:46 2009
> > From: Martin Fuzzey <mfuzzey@gmail.com>
> > Date: Tue, 21 Apr 2009 21:48:09 +0200
> > Subject: USB: pwc : do not pass stack allocated buffers to USB core.
> > To: Greg KH <greg@kroah.com>, <linux-media@vger.kernel.org>
> > Message-ID: <20090421194808.8272.8437.stgit@mfuzzey-laptop>
> > 
> > 
> > This is causes problems on platforms that have alignment requirements
> > for DMA transfers.
> > 
> > Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Thanks, I've added it to the patch and will send it off in my next round
of updates.

greg k-h
