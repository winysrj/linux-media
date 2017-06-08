Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59269
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751469AbdFHUKx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 16:10:53 -0400
Date: Thu, 8 Jun 2017 17:10:43 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Kieran Bingham <kbingham@kernel.org>, linux-media@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        linux-renesas-soc@vger.kernel.org, kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v4] v4l: subdev: tolerate null in
 media_entity_to_v4l2_subdev
Message-ID: <20170608171043.73dd28aa@vento.lan>
In-Reply-To: <20170608193210.GJ1019@valkosipuli.retiisi.org.uk>
References: <1496829127-28375-1-git-send-email-kbingham@kernel.org>
        <20170608150022.5f696e58@vento.lan>
        <20170608193210.GJ1019@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 8 Jun 2017 22:32:10 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Thu, Jun 08, 2017 at 03:00:22PM -0300, Mauro Carvalho Chehab wrote:
> > Em Wed,  7 Jun 2017 10:52:07 +0100
> > Kieran Bingham <kbingham@kernel.org> escreveu:
> >   
> > > From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > > 
> > > Return NULL, if a null entity is parsed for it's v4l2_subdev
> > > 
> > > Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>  
> > 
> > Could you please improve this patch description?
> > 
> > I'm unsure if this is a bug fix, or some sort of feature...
> > 
> > On what situations would a null entity be passed to this function?  
> 
> I actually proposed this patch. This change is simply for convenience ---
> the caller doesn't need to make sure the subdev is non-NULL, possibly
> obtained from e.g. media_entity_remote_pad() which returns NULL all links to
> the pad are disabled. This is a recurring pattern, and making this change
> avoids an additional check.
> 
> Having something along these lines in the patch description wouldn't hurt.

Patch added, with a description based on the above.

Thanks!

Mauro
