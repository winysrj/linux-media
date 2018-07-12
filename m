Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:34639 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726686AbeGLNax (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jul 2018 09:30:53 -0400
Date: Thu, 12 Jul 2018 14:21:18 +0100
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: "Michael Kerrisk (man-opages)" <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org, linux-media@vger.kernel.org,
        Alec Leamas <leamas.alec@gmail.com>
Subject: Re: [PATCH] lirc.4: remove ioctls and feature bits which were never
 implemented
Message-ID: <20180712132118.t5umg7z7qchpok7j@gofer.mess.org>
References: <20180423102637.xtcjidetxo6iaslx@gofer.mess.org>
 <6b531be3-56ea-b534-3493-d64c98b3f6c5@gmail.com>
 <20180518152529.eunu6e6735z62bug@gofer.mess.org>
 <20180712093332.682fa518@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180712093332.682fa518@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 12, 2018 at 09:33:32AM -0300, Mauro Carvalho Chehab wrote:
> Hi Michael/Alec,
> 
> Em Fri, 18 May 2018 16:25:29 +0100
> Sean Young <sean@mess.org> escreveu:
> 
> > On Sun, May 06, 2018 at 12:34:53PM +0200, Michael Kerrisk (man-opages) wrote:
> > > [CCing original author of this page]
> > > 
> > > 
> > > On 04/23/2018 12:26 PM, Sean Young wrote:  
> > > > The lirc header file included ioctls and feature bits which were never
> > > > implemented by any driver. They were removed in commit:
> > > > 
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d55f09abe24b4dfadab246b6f217da547361cdb6  
> > > 
> > > Alec, does this patch look okay to you? 
> 
> Sean is the sub-maintainer responsible for the LIRC code at the
> media subsystem. He knows more about the current implementation
> than anyone else, as he's working hard to improve it, and got
> rid of all legacy LIRC drivers from staging (either fixing them
> or removing the few ones nobody uses anymore).
> 
> As part of his work, some ioctls got removed, in order to make
> the LIRC interface to match the real implementation.
>  
> > Mauro, as Alec is not responding, would you be able to sign this off?
> 
> Most of the patch looks ok on my eyes. I noticed that some flags
> still exists at include/uapi/linux/lirc.h:
> 
> 	LIRC_CAN_REC_RAW, LIRC_CAN_REC_PULSE, LIRC_CAN_SET_REC_FILTER
> 	and LIRC_CAN_SEND_MODE2
> 
> Maybe instead of just removing, you would need to add some
> explanation about them (or at the patch itself, explaining
> why you're removing the descriptions for them).

Those flags do still exist in the header file, we decided to keep them
so that code does not suddenly fail to build. These flags either never
had implementations or only had out-of-tree implementations. So, I do
not think they belong in the man page.

> > Alternatively, what can be done to progress this?
> > 
> > There is some new functionality in lirc which should be added to this man
> > page too, so I have more to come (when I get round to writing it).
> 
> Yeah, making it reflect upstream sounds the right thing to do.

Absolutely, when kernel v4.18 is released there is more to add.


Sean
