Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:51659 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab0HCBA0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Aug 2010 21:00:26 -0400
Date: Mon, 2 Aug 2010 18:00:20 -0700
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 1/2] staging/lirc: port lirc_streamzap to ir-core
Message-ID: <20100803010020.GA3677@kroah.com>
References: <20100802212922.GA17746@redhat.com>
 <20100802223510.GB2478@kroah.com>
 <4C5761AE.9050701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5761AE.9050701@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 02, 2010 at 09:24:14PM -0300, Mauro Carvalho Chehab wrote:
> Em 02-08-2010 19:35, Greg KH escreveu:
> > On Mon, Aug 02, 2010 at 05:29:22PM -0400, Jarod Wilson wrote:
> >>  drivers/media/IR/keymaps/Makefile           |    1 +
> > 
> > Uppercase "IR"?  Any reason why you all picked that?
> 
> Infra Red. Well, it were not probably a good idea ;)
> 
> Anyway, I intend to rename it to "rc" (for Remote Controller), change lots of 
> internal structures and eventually move it to drivers/ or drivers/input, as the
> idea is to use the subsystem also to other kinds of remote controllers.
> 
> I'll likely do it after finishing the merge of the pending patches, and send
> upstream during this merge window. It seems better to rename during the merge
> window.

Renames are usually good for after -rc1 is out to help everyone sync up
better.

thanks,

greg k-h


> > 
> > Just curious.
> > 
> > greg k-h
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Cheers,
> Mauro
