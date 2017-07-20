Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37560
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934586AbdGTNvr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 09:51:47 -0400
Date: Thu, 20 Jul 2017 10:51:38 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 02/14] v4l: vsp1: Don't recycle active list at
 display start
Message-ID: <20170720105138.395541e4@vento.lan>
In-Reply-To: <b020fe7c-78fe-0f40-88bd-58165b22c496@ideasonboard.com>
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
        <20170626181226.29575-3-laurent.pinchart+renesas@ideasonboard.com>
        <b020fe7c-78fe-0f40-88bd-58165b22c496@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 13 Jul 2017 18:02:20 +0100
Kieran Bingham <kieran.bingham@ideasonboard.com> escreveu:

> Hi Laurent,
> 
> On 26/06/17 19:12, Laurent Pinchart wrote:
> > When the display start interrupt occurs, we know that the hardware has
> > finished loading the active display list. The driver then proceeds to
> > recycle the list, assuming it won't be needed anymore.
> > 
> > This assumption holds true for headerless display lists, as the VSP
> > doesn't reload the list for the next frame if it hasn't changed.
> > However, this isn't true anymore for header display lists, as they are
> > loaded at every frame start regardless of whether they have been
> > updated.
> > 
> > To prepare for header display lists usage in display pipelines, we need
> > to postpone recycling the list until it gets replaced by a new one
> > through a page flip. The driver already does so in the frame end
> > interrupt handler, so all we need is to skip list recycling in the
> > display start interrupt handler.
> > 
> > While the active list can be recycled at display start for headerless
> > display lists, there's no real harm in postponing that to the frame end
> > interrupt handler in all cases. This simplifies interrupt handling as we
> > don't need to process the display start interrupt anymore.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>  
> 
> Ok, I had skipped this one as I was concerned about its effects in relation to
> 11/14 but I see how that's working now.
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks,
Mauro
