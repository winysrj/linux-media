Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:40350 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753493AbeEWIhv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 04:37:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Simon Horman <horms@verge.net.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Nobuhiro Iwamatsu <iwamatsu@debian.org>
Subject: Re: [PATCH v2] v4l: vsp1: Fix vsp1_regs.h license header
Date: Wed, 23 May 2018 11:37:47 +0300
Message-ID: <1905091.9toDD4m9Wz@avalon>
In-Reply-To: <20180523083324.vvtadkkoz6ti5qi7@verge.net.au>
References: <20180520072437.9686-1-laurent.pinchart+renesas@ideasonboard.com> <CAMuHMdUbjkcWsuocU-ox0y2etTsy7=WhKFKj3HDEoqyif_CtMw@mail.gmail.com> <20180523083324.vvtadkkoz6ti5qi7@verge.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

On Wednesday, 23 May 2018 11:33:26 EEST Simon Horman wrote:
> On Tue, May 22, 2018 at 01:04:56PM +0200, Geert Uytterhoeven wrote:
> > On Tue, May 22, 2018 at 11:05 AM, Simon Horman <horms@verge.net.au> wrote:
> >>> --- a/drivers/media/platform/vsp1/vsp1_regs.h
> >>> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> >>> @@ -1,4 +1,4 @@
> >>> -/* SPDX-License-Identifier: GPL-2.0 */
> >>> +/* SPDX-License-Identifier: GPL-2.0+ */
> >> 
> >> While you are changing this line, I believe the correct format is
> >> to use a '//' comment.
> >> 
> >> i.e.:
> >> 
> >> // SPDX-License-Identifier: GPL-2.0+
> > 
> > Not for C header files, only for C source files.
> 
> Wow!

Yes, it's a mess :-( The rationale is that the assembler doesn't support C++-
style comments, so we need to use C-style comments in header files. We should 
really have standardized usage of C-style comments everywhere, it makes no 
sense to me.

-- 
Regards,

Laurent Pinchart
