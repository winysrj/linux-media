Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48292 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753743AbdLNShs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 13:37:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dhaval Shah <dhaval23031987@gmail.com>, hyun.kwon@xilinx.com,
        michal.simek@xilinx.com, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: v4l: xilinx: Use SPDX-License-Identifier
Date: Thu, 14 Dec 2017 20:37:54 +0200
Message-ID: <16301043.Lbu0ahMgBI@avalon>
In-Reply-To: <1513276340.27409.77.camel@perches.com>
References: <20171208123537.18718-1-dhaval23031987@gmail.com> <7339763.I7jApfYMM6@avalon> <1513276340.27409.77.camel@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Joe,

On Thursday, 14 December 2017 20:32:20 EET Joe Perches wrote:
> On Thu, 2017-12-14 at 20:28 +0200, Laurent Pinchart wrote:
> > On Thursday, 14 December 2017 19:05:27 EET Mauro Carvalho Chehab wrote:
> >> Em Fri,  8 Dec 2017 18:05:37 +0530 Dhaval Shah escreveu:
> >>> SPDX-License-Identifier is used for the Xilinx Video IP and
> >>> related drivers.
> >>> 
> >>> Signed-off-by: Dhaval Shah <dhaval23031987@gmail.com>
> >> 
> >> Hi Dhaval,
> >> 
> >> You're not listed as one of the Xilinx driver maintainers. I'm afraid
> >> that, without their explicit acks, sent to the ML, I can't accept a patch
> >> touching at the driver's license tags.
> > 
> > The patch doesn't change the license, I don't see why it would cause any
> > issue. Greg isn't listed as the maintainer or copyright holder of any of
> > the 10k+ files to which he added an SPDX license header in the last
> > kernel release.
> 
> Adding a comment line that describes an implicit or
> explicit license is different than removing the license
> text itself.

The SPDX license header is meant to be equivalent to the license text. The 
only reason why the large SPDX patch didn't touch the whole kernel in one go 
was that it was easier to split in in multiple chunks. This is no different 
than not including the full GPL license in every header file but only pointing 
to it through its name and reference, as every kernel source file does.

-- 
Regards,

Laurent Pinchart
