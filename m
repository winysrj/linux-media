Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:57360 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754471AbeEWJKB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 05:10:01 -0400
Date: Wed, 23 May 2018 11:09:57 +0200
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Nobuhiro Iwamatsu <iwamatsu@debian.org>
Subject: Re: [PATCH v2] v4l: vsp1: Fix vsp1_regs.h license header
Message-ID: <20180523090956.7u5cfvd5wdnxghtj@verge.net.au>
References: <20180520072437.9686-1-laurent.pinchart+renesas@ideasonboard.com>
 <CAMuHMdUbjkcWsuocU-ox0y2etTsy7=WhKFKj3HDEoqyif_CtMw@mail.gmail.com>
 <20180523083324.vvtadkkoz6ti5qi7@verge.net.au>
 <1905091.9toDD4m9Wz@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1905091.9toDD4m9Wz@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 23, 2018 at 11:37:47AM +0300, Laurent Pinchart wrote:
> Hi Simon,
> 
> On Wednesday, 23 May 2018 11:33:26 EEST Simon Horman wrote:
> > On Tue, May 22, 2018 at 01:04:56PM +0200, Geert Uytterhoeven wrote:
> > > On Tue, May 22, 2018 at 11:05 AM, Simon Horman <horms@verge.net.au> wrote:
> > >>> --- a/drivers/media/platform/vsp1/vsp1_regs.h
> > >>> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> > >>> @@ -1,4 +1,4 @@
> > >>> -/* SPDX-License-Identifier: GPL-2.0 */
> > >>> +/* SPDX-License-Identifier: GPL-2.0+ */
> > >> 
> > >> While you are changing this line, I believe the correct format is
> > >> to use a '//' comment.
> > >> 
> > >> i.e.:
> > >> 
> > >> // SPDX-License-Identifier: GPL-2.0+
> > > 
> > > Not for C header files, only for C source files.
> > 
> > Wow!
> 
> Yes, it's a mess :-( The rationale is that the assembler doesn't support C++-
> style comments, so we need to use C-style comments in header files. We should 
> really have standardized usage of C-style comments everywhere, it makes no 
> sense to me.

I'm reading this email while standing on my head
and things make much more sense :)
