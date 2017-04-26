Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:34105 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1434906AbdDZJAd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 05:00:33 -0400
Received: by mail-lf0-f49.google.com with SMTP id t144so104221530lff.1
        for <linux-media@vger.kernel.org>; Wed, 26 Apr 2017 02:00:32 -0700 (PDT)
Date: Wed, 26 Apr 2017 11:00:30 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Simon Horman <horms@verge.net.au>
Cc: Kieran Bingham <kbingham@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH] rcar-vin: Use of_nodes as specified by the subdev
Message-ID: <20170426090030.GF4676@bigcity.dyn.berto.se>
References: <1493132100-31901-1-git-send-email-kbingham@kernel.org>
 <20170426072320.GD25517@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170426072320.GD25517@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

Thanks for your feedback.

On 2017-04-26 09:23:20 +0200, Simon Horman wrote:
> Hi Kieran,
> 
> On Tue, Apr 25, 2017 at 03:55:00PM +0100, Kieran Bingham wrote:
> > From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > 
> > The rvin_digital_notify_bound() call dereferences the subdev->dev
> > pointer to obtain the of_node. On some error paths, this dev node can be
> > set as NULL. The of_node is mapped into the subdevice structure on
> > initialisation, so this is a safer source to compare the nodes.
> > 
> > Dereference the of_node from the subdev structure instead of the dev
> > structure.
> > 
> > Fixes: 83fba2c06f19 ("rcar-vin: rework how subdevice is found and
> > 	bound")
> > Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> > index 5861ab281150..a530dc388b95 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > @@ -469,7 +469,7 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
> >  
> >  	v4l2_set_subdev_hostdata(subdev, vin);
> >  
> > -	if (vin->digital.asd.match.of.node == subdev->dev->of_node) {
> > +	if (vin->digital.asd.match.of.node == subdev->of_node) {
> >  		/* Find surce and sink pad of remote subdevice */
> >  
> >  		ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
> 
> I see two different accesses to subdev->dev->of_node in the version of
> rcar-core.c in linux-next. So I'm unsure if the following comment makes
> sense in the context of the version you are working on. It is that
> I wonder if all accesses to subdev->dev->of_node should be updated.

Are you sure you checked linux-next and not renesas-drivers? I checked 
next-20170424.

$ git grep "dev->of_node" -- drivers/media/platform/rcar-vin/
drivers/media/platform/rcar-vin/rcar-core.c:107:        if (vin->digital.asd.match.of.node == subdev->dev->of_node) {
drivers/media/platform/rcar-vin/rcar-core.c:161:        ep = of_graph_get_endpoint_by_regs(vin->dev->of_node, 0, 0);

Here vin->dev->of_node is correct and subdev->dev->of_node should be 
fixed by Kieran patch. I'm only asking to be sure I did not miss 
anything. In renesas-drivers the Gen3 patches are included and more 
references to subdev->dev->of_node exists, but as Kieran sates these 
fixes will be squashed into those patches since they are not yet picked 
up.

-- 
Regards,
Niklas Söderlund
