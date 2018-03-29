Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40797 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbeC2Gvy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 02:51:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 02/15] v4l: vsp1: Remove outdated comment
Date: Thu, 29 Mar 2018 09:51:55 +0300
Message-ID: <253721395.BpiYOE76Q7@avalon>
In-Reply-To: <0829c7b9-e05b-fe27-b632-005074c86de3@ideasonboard.com>
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com> <0a055333-78b0-a64b-ef97-c1706b7b56b9@ideasonboard.com> <0829c7b9-e05b-fe27-b632-005074c86de3@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wednesday, 28 March 2018 22:04:49 EEST Kieran Bingham wrote:
> On 28/03/18 13:27, Kieran Bingham wrote:
> > On 26/02/18 21:45, Laurent Pinchart wrote:
> >> The entities in the pipeline are all started when the LIF is setup.
> >> Remove the outdated comment that state otherwise.
> >> 
> >> Signed-off-by: Laurent Pinchart
> >> <laurent.pinchart+renesas@ideasonboard.com>
> > 
> > I'll start with the easy ones :-)
> 
> In fact, couldn't this patch be squashed into [PATCH 01/15] in this series ?

I suppose it could, I'll do so.

> > Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > 
> >> ---
> >> 
> >>  drivers/media/platform/vsp1/vsp1_drm.c | 6 +-----
> >>  1 file changed, 1 insertion(+), 5 deletions(-)
> >> 
> >> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> >> b/drivers/media/platform/vsp1/vsp1_drm.c index
> >> e31fb371eaf9..a1f2ba044092 100644
> >> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> >> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> >> @@ -221,11 +221,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned
> >> int pipe_index,>> 
> >>  		return -EPIPE;
> >>  	
> >>  	}
> >> 
> >> -	/*
> >> -	 * Enable the VSP1. We don't start the entities themselves right at
> >> this
> >> -	 * point as there's no plane configured yet, so we can't start
> >> -	 * processing buffers.
> >> -	 */
> >> +	/* Enable the VSP1. */
> >> 
> >>  	ret = vsp1_device_get(vsp1);
> >>  	if (ret < 0)
> >>  	
> >>  		return ret;


-- 
Regards,

Laurent Pinchart
