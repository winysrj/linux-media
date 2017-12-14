Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53397 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752433AbdLNUoL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 15:44:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dhaval Shah <dhaval23031987@gmail.com>, hyun.kwon@xilinx.com,
        michal.simek@xilinx.com, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: v4l: xilinx: Use SPDX-License-Identifier
Date: Thu, 14 Dec 2017 22:44:16 +0200
Message-ID: <3484237.SQf3uXUed3@avalon>
In-Reply-To: <20171214200851.GA27849@kroah.com>
References: <20171208123537.18718-1-dhaval23031987@gmail.com> <2967655.MWOA0IsQOS@avalon> <20171214200851.GA27849@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

On Thursday, 14 December 2017 22:08:51 EET Greg KH wrote:
> On Thu, Dec 14, 2017 at 09:05:27PM +0200, Laurent Pinchart wrote:
> > On Thursday, 14 December 2017 20:54:39 EET Joe Perches wrote:
> >> On Thu, 2017-12-14 at 20:37 +0200, Laurent Pinchart wrote:
> >>> On Thursday, 14 December 2017 20:32:20 EET Joe Perches wrote:
> >>>> On Thu, 2017-12-14 at 20:28 +0200, Laurent Pinchart wrote:
> >>>>> On Thursday, 14 December 2017 19:05:27 EET Mauro Carvalho Chehab 
wrote:
> >>>>>> Em Fri,  8 Dec 2017 18:05:37 +0530 Dhaval Shah escreveu:
> >>>>>>> SPDX-License-Identifier is used for the Xilinx Video IP and
> >>>>>>> related drivers.
> >>>>>>> 
> >>>>>>> Signed-off-by: Dhaval Shah <dhaval23031987@gmail.com>
> >>>>>> 
> >>>>>> Hi Dhaval,
> >>>>>> 
> >>>>>> You're not listed as one of the Xilinx driver maintainers. I'm
> >>>>>> afraid that, without their explicit acks, sent to the ML, I can't
> >>>>>> accept a patch touching at the driver's license tags.
> >>>>> 
> >>>>> The patch doesn't change the license, I don't see why it would cause
> >>>>> any issue. Greg isn't listed as the maintainer or copyright holder
> >>>>> of any of the 10k+ files to which he added an SPDX license header in
> >>>>> the last kernel release.
> >>>> 
> >>>> Adding a comment line that describes an implicit or
> >>>> explicit license is different than removing the license
> >>>> text itself.
> >>> 
> >>> The SPDX license header is meant to be equivalent to the license text.
> >> 
> >> I understand that.
> >> At a minimum, removing BSD license text is undesirable
> >> 
> >> as that license states:
> >>  *    * Redistributions of source code must retain the above copyright
> >>  *      notice, this list of conditions and the following disclaimer.
> >> 
> >> etc...
> > 
> > But this patch only removes the following text:
> > 
> > - * This program is free software; you can redistribute it and/or modify
> > - * it under the terms of the GNU General Public License version 2 as
> > - * published by the Free Software Foundation.
> > 
> > and replaces it by the corresponding SPDX header.
> > 
> >>> The only reason why the large SPDX patch didn't touch the whole kernel
> >>> in one go was that it was easier to split in in multiple chunks.
> >> 
> >> Not really, it was scripted.
> > 
> > But still manually reviewed as far as I know.
> > 
> >>> This is no different than not including the full GPL license in every
> >>> header file but only pointing to it through its name and reference, as
> >>> every kernel source file does.
> >> 
> >> Not every kernel source file had a license text
> >> or a reference to another license file.
> > 
> > Correct, but the files touched by this patch do.
> > 
> > This issue is in no way specific to linux-media and should be decided upon
> > at the top level, not on a per-subsystem basis. Greg, could you comment
> > on this ?
> 
> Comment on what exactly?  I don't understand the problem here, care to
> summarize it?

In a nutshell (if I understand it correctly), Dhaval Shah submitted https://
patchwork.kernel.org/patch/10102451/ which replaces

+// SPDX-License-Identifier: GPL-2.0
[...]
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.

in all .c and .h files of the Xilinx V4L2 driver (drivers/media/platform/
xilinx). I have reviewed the patch and acked it. Mauro then rejected it, 
stating that he can't accept a change to license text without an explicit ack 
from the official driver's maintainers. My position is that such a change 
doesn't change the license and thus doesn't need to track all copyright 
holders, and can be merged without an explicit ack from the respective 
maintainers.

On a side note, Joe pointed out that some files contains BSD license text 
similar to

 *    * Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.

If we follow the text of the license strictly it can be argued that such text 
can't be replaced by an SPDX license identifier without breaching the license.

-- 
Regards,

Laurent Pinchart
