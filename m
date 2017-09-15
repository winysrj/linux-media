Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48719 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751316AbdIOSUR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 14:20:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v1 2/3] drm: rcar-du: Add suspend resume helpers
Date: Fri, 15 Sep 2017 21:20:18 +0300
Message-ID: <41822401.KNpIGo2cP1@avalon>
In-Reply-To: <3416c30a-620c-0238-2569-02de80a53ba2@ideasonboard.com>
References: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com> <1607973.DTifMlLdNl@avalon> <3416c30a-620c-0238-2569-02de80a53ba2@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Friday, 15 September 2017 20:49:15 EEST Kieran Bingham wrote:
> On 15/09/17 18:02, Laurent Pinchart wrote:
> > On Friday, 15 September 2017 19:42:06 EEST Kieran Bingham wrote:
> >> The pipeline needs to ensure that the hardware is idle for suspend and
> >> resume operations.
> > 
> > I'm not sure to really understand this sentence.
> 
> It makes sense to me ... :) - But I'm not the (only) target audience.
> 
> How about re-wording it in a similar way to your suggestion in [1/3]
> 
> """
> To support system suspend operations we must ensure the hardware is stopped,
> and resumed explicitly from the suspend and resume handlers.
> 
> Implement suspend and resume functions using the DRM atomic helper
> functions.
> """

Sounds good to me. I'll update the commit message in my tree, and update the 
subject line to "drm: rcar-du: Implement system suspend/resume support".

> >> Implement suspend and resume functions using the DRM atomic helper
> >> functions.
> >> 
> >> CC: dri-devel@lists.freedesktop.org
> >> 
> >> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > 
> > The rest of the patch looks good to me. With the commit message clarified,
> > 
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> >> ---
> >> 
> >>  drivers/gpu/drm/rcar-du/rcar_du_drv.c | 18 +++++++++++++++---
> >>  drivers/gpu/drm/rcar-du/rcar_du_drv.h |  1 +
> >>  2 files changed, 16 insertions(+), 3 deletions(-)

[snip]

-- 
Regards,

Laurent Pinchart
