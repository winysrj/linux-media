Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46416 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751874AbdHASrF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 14:47:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 11/14] v4l: vsp1: Add support for header display lists in continuous mode
Date: Tue, 01 Aug 2017 21:47:16 +0300
Message-ID: <3464715.HJz2XH12Bc@avalon>
In-Reply-To: <5051664d-1793-2245-28cd-94334f847977@ideasonboard.com>
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com> <20170626181226.29575-12-laurent.pinchart+renesas@ideasonboard.com> <5051664d-1793-2245-28cd-94334f847977@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Tuesday 01 Aug 2017 18:35:48 Kieran Bingham wrote:
> On 26/06/17 19:12, Laurent Pinchart wrote:
> > The VSP supports both header and headerless display lists. The latter is
> > easier to use when the VSP feeds data directly to the DU in continuous
> > mode, and the driver thus uses headerless display lists for DU operation
> > and header display lists otherwise.
> > 
> > Headerless display lists are only available on WPF.0. This has never
> > been an issue so far, as only WPF.0 is connected to the DU. However, on
> > H3 ES2.0, the VSP-DL instance has both WPF.0 and WPF.1 connected to the
> > DU. We thus can't use headerless display lists unconditionally for DU
> > operation.
> 
> Would it be crazy to suggest we drop headerless display lists?
> 
> If we must support header display lists in continuous mode - Rather than
> having 2 cases for continuous modes to support (having to support
> headerless, on WPF.0, and header on WPF.1) if we just use your header loop
> trick - would that simplify our code maintenance?
> 
> (We can always remove headerless support later if you agree, this is more of
> an idea at the moment)

I had the exact same thought, but I believe we should wait a few kernel 
releases to see if the next code is stable before removing the old one. I have 
a debug patch that forces usage of header display lists unconditionally, and 
I'll try to develop a few additional stress-tests for that.

> > Implement support for continuous mode with header display lists, and use
> > it for DU operation on WPF outputs that don't support headerless mode.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> Except for future discussion points, I can't see anything wrong here so:
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> > ---
> > 
> >  drivers/media/platform/vsp1/vsp1_dl.c   | 195 +++++++++++++++++---------
> >  drivers/media/platform/vsp1/vsp1_regs.h |   1 +
> >  2 files changed, 127 insertions(+), 69 deletions(-)

-- 
Regards,

Laurent Pinchart
