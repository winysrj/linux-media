Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50600 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751266AbdEEVMf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 17:12:35 -0400
Date: Sat, 6 May 2017 00:11:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: mchehab@kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: entity: Catch unbalanced media_pipeline_stop calls
Message-ID: <20170505211156.GI7456@valkosipuli.retiisi.org.uk>
References: <1483449131-18075-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <2426604.oXt7iAeI8O@avalon>
 <f2029382-de41-3267-d1f2-6b1366bcae27@ideasonboard.com>
 <20170104085746.GO3958@valkosipuli.retiisi.org.uk>
 <a89c9fa7-37e9-e857-268e-b4105c6c8e77@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a89c9fa7-37e9-e857-268e-b4105c6c8e77@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran / Mauro,

On Fri, May 05, 2017 at 06:33:22PM +0100, Kieran Bingham wrote:
> Hi Sakari,
> 
> On 04/01/17 08:57, Sakari Ailus wrote:
> > Hi Kieran,
> > 
> > Thanks for the patch!
> > 
> > On Tue, Jan 03, 2017 at 05:05:58PM +0000, Kieran Bingham wrote:
> >> On 03/01/17 13:36, Laurent Pinchart wrote:
> >>> Hi Kieran,
> >>>
> >>> Thank you for the patch.
> >>>
> >>> On Tuesday 03 Jan 2017 13:12:11 Kieran Bingham wrote:
> >>>> Drivers must not perform unbalanced calls to stop the entity pipeline,
> >>>> however if they do they will fault in the core media code, as the
> >>>> entity->pipe will be set as NULL. We handle this gracefully in the core
> >>>> with a WARN for the developer.
> >>>>
> >>>> Replace the erroneous check on zero streaming counts, with a check on
> >>>> NULL pipe elements instead, as this is the symptom of unbalanced
> >>>> media_pipeline_stop calls.
> >>>>
> >>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >>>
> >>> This looks good to me,
> >>>
> >>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>>
> >>> I'll let Sakari review and merge the patch.
> >>
> >> Ahh, yes - I forgot to mention, although perhaps it will be obvious for
> >> Sakari - but this patch is based on top of Sakari's pending media
> >> pipeline and graph walk cleanup series :D
> > 
> > I've applied this on top of the other patches.
> > 
> > It's always good to mention dependencies to other patches, that's very
> > relevant for reviewers.
> 
> I've just been going through my old branches doing some clean up - and I can't
> see that this patch [0] made it to integration anywhere.
> 
> Did it get lost?
>  It looks like the cleanup series it was based on made it through...

What I think happened was that I had applied it to the correct branch BUT I
already had sent a pull request on it. My apologies.

> 
> Mauro, perhaps you could pick this one up now ?

The patchwork link is here:

<URL:https://patchwork.linuxtv.org/patch/38883/>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
