Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47060 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935717AbdADI5u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jan 2017 03:57:50 -0500
Date: Wed, 4 Jan 2017 10:57:47 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: entity: Catch unbalanced media_pipeline_stop calls
Message-ID: <20170104085746.GO3958@valkosipuli.retiisi.org.uk>
References: <1483449131-18075-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <2426604.oXt7iAeI8O@avalon>
 <f2029382-de41-3267-d1f2-6b1366bcae27@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2029382-de41-3267-d1f2-6b1366bcae27@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thanks for the patch!

On Tue, Jan 03, 2017 at 05:05:58PM +0000, Kieran Bingham wrote:
> On 03/01/17 13:36, Laurent Pinchart wrote:
> > Hi Kieran,
> > 
> > Thank you for the patch.
> > 
> > On Tuesday 03 Jan 2017 13:12:11 Kieran Bingham wrote:
> >> Drivers must not perform unbalanced calls to stop the entity pipeline,
> >> however if they do they will fault in the core media code, as the
> >> entity->pipe will be set as NULL. We handle this gracefully in the core
> >> with a WARN for the developer.
> >>
> >> Replace the erroneous check on zero streaming counts, with a check on
> >> NULL pipe elements instead, as this is the symptom of unbalanced
> >> media_pipeline_stop calls.
> >>
> >> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > 
> > This looks good to me,
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > I'll let Sakari review and merge the patch.
> 
> Ahh, yes - I forgot to mention, although perhaps it will be obvious for
> Sakari - but this patch is based on top of Sakari's pending media
> pipeline and graph walk cleanup series :D

I've applied this on top of the other patches.

It's always good to mention dependencies to other patches, that's very
relevant for reviewers.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
