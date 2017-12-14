Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43110 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752045AbdLNUIt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 15:08:49 -0500
Date: Thu, 14 Dec 2017 21:08:51 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dhaval Shah <dhaval23031987@gmail.com>, hyun.kwon@xilinx.com,
        michal.simek@xilinx.com, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: v4l: xilinx: Use SPDX-License-Identifier
Message-ID: <20171214200851.GA27849@kroah.com>
References: <20171208123537.18718-1-dhaval23031987@gmail.com>
 <16301043.Lbu0ahMgBI@avalon>
 <1513277679.27409.83.camel@perches.com>
 <2967655.MWOA0IsQOS@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2967655.MWOA0IsQOS@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 14, 2017 at 09:05:27PM +0200, Laurent Pinchart wrote:
> Hi Joe,
> 
> (CC'ing Greg and adding context for easier understanding)
> 
> On Thursday, 14 December 2017 20:54:39 EET Joe Perches wrote:
> > On Thu, 2017-12-14 at 20:37 +0200, Laurent Pinchart wrote:
> > > On Thursday, 14 December 2017 20:32:20 EET Joe Perches wrote:
> > >> On Thu, 2017-12-14 at 20:28 +0200, Laurent Pinchart wrote:
> > >>> On Thursday, 14 December 2017 19:05:27 EET Mauro Carvalho Chehab wrote:
> > >>>> Em Fri,  8 Dec 2017 18:05:37 +0530 Dhaval Shah escreveu:
> > >>>>> SPDX-License-Identifier is used for the Xilinx Video IP and
> > >>>>> related drivers.
> > >>>>> 
> > >>>>> Signed-off-by: Dhaval Shah <dhaval23031987@gmail.com>
> > >>>> 
> > >>>> Hi Dhaval,
> > >>>> 
> > >>>> You're not listed as one of the Xilinx driver maintainers. I'm afraid
> > >>>> that, without their explicit acks, sent to the ML, I can't accept a
> > >>>> patch touching at the driver's license tags.
> > >>> 
> > >>> The patch doesn't change the license, I don't see why it would cause
> > >>> any issue. Greg isn't listed as the maintainer or copyright holder of
> > >>> any of the 10k+ files to which he added an SPDX license header in the
> > >>> last kernel release.
> > >> Adding a comment line that describes an implicit or
> > >> explicit license is different than removing the license
> > >> text itself.
> > > 
> > > The SPDX license header is meant to be equivalent to the license text.
> > 
> > I understand that.
> > At a minimum, removing BSD license text is undesirable
> > as that license states:
> > 
> >  *    * Redistributions of source code must retain the above copyright
> >  *      notice, this list of conditions and the following disclaimer.
> > etc...
> 
> But this patch only removes the following text:
> 
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> 
> and replaces it by the corresponding SPDX header.
> 
> > > The only reason why the large SPDX patch didn't touch the whole kernel in
> > > one go was that it was easier to split in in multiple chunks.
> > 
> > Not really, it was scripted.
> 
> But still manually reviewed as far as I know.
> 
> > > This is no different than not including the full GPL license in every
> > > header file but only pointing to it through its name and reference, as
> > > every kernel source file does.
> > 
> > Not every kernel source file had a license text
> > or a reference to another license file.
> 
> Correct, but the files touched by this patch do.
> 
> This issue is in no way specific to linux-media and should be decided upon at 
> the top level, not on a per-subsystem basis. Greg, could you comment on this ?

Comment on what exactly?  I don't understand the problem here, care to
summarize it?

thanks,

greg k-h
