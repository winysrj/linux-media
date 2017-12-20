Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:41182 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756058AbdLTTVg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 14:21:36 -0500
Received: by mail-lf0-f65.google.com with SMTP id f18so25257095lfg.8
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 11:21:36 -0800 (PST)
Date: Wed, 20 Dec 2017 20:21:33 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] v4l: rcar-csi2: Don't bail out from probe on no ep
Message-ID: <20171220192133.GA15701@bigcity.dyn.berto.se>
References: <1512506508-17418-1-git-send-email-jacopo+renesas@jmondi.org>
 <d022e2a8-2343-42ef-4075-d81375a490e6@xs4all.nl>
 <20171215142310.GA1281@bigcity.dyn.berto.se>
 <4936185.ZshrHvUZzS@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4936185.ZshrHvUZzS@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 2017-12-20 20:06:13 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> On Friday, 15 December 2017 16:23:10 EET Niklas Söderlund wrote:
> > On 2017-12-15 15:06:44 +0100, Hans Verkuil wrote:
> > > Niklas,
> > > 
> > > Did you look at this? If I should take it, can you Ack it? If you are
> > > going to squash or add it to our of your own patch series, then let me
> > > know and I can remove it from my todo queue.
> > 
> > I did look at it and talked to Jacobo about it. I think I have a better
> > solution to his problem which I hope to try out in the near future. If
> > my workaround turns out to not solve his problem I will squash this in
> > when I resend the rcar-csi2 patch-set so in any case I think you can
> > drop it from your todo queue.
> > 
> > The reason I'm a bit reluctant to ack this straight away is that I think
> > it's kind of good that rcar-csi2 fails to probe if it finds no endpoints
> > to work with, there is little use for the driver instance then. The
> > problem Jacobo is trying to fix is related to how the rcar-vin Gen3
> > group parses DT and I made a small mistake there which was discovered by
> > Jacobo. And since the original fault is in the rcar-vin driver I think
> > the issue should be fixed in that driver.
> 
> How do you plan to handle the case where only one CSI-2 receiver has a 
> connected input ?

I'm sorry, I don't understand this question I think. If there only is 
one CSI-2 receiver with connected endpoints, should that not be the only 
hardware the driver handles? What would be the reason to enable a CSI-2 
device in DT and not connect endpoints to it?

> 
> > > On 05/12/17 21:41, Jacopo Mondi wrote:
> > >> When rcar-csi interface is not connected to any endpoint, it fails and
> > >> bails out from probe before registering its own video subdevice.
> > >> This prevents rcar-vin registered notifier from completing and no
> > >> subdevice is ever registered, also for other properly connected csi
> > >> interfaces.
> > >> 
> > >> Fix this not returning an error when no endpoint is connected to a csi
> > >> interface and let the driver complete its probe function and register
> > >> its own video subdevice.
> > >> 
> > >> ---
> > >> Niklas,
> > >> 
> > >>    please squash this patch in your next rcar-csi2 series (if you like
> > >>    it ;)
> > >> 
> > >> As we have discussed this is particularly useful for gmsl setup, where
> > >> adv748x is connected to CSI20 and max9286 to CSI40/CSI41. If we disable
> > >> adv748x from DTS we need CSI20 probe to complete anyhow otherwise no
> > >> subdevice gets registered for the two deserializers.
> > >> 
> > >> Please note we cannot disable CSI20 entirely otherwise VIN's graph
> > >> parsing breaks.
> > >> 
> > >> Thanks
> > >> 
> > >>    j
> > >> 
> > >> ---
> > >> 
> > >>  drivers/media/platform/rcar-vin/rcar-csi2.c | 4 ++--
> > >>  1 file changed, 2 insertions(+), 2 deletions(-)
> > >> 
> > >> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > >> b/drivers/media/platform/rcar-vin/rcar-csi2.c index 2793efb..90c4062
> > >> 100644
> > >> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > >> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > >> @@ -928,8 +928,8 @@ static int rcar_csi2_parse_dt(struct rcar_csi2
> > >> *priv)
> > >> 
> > >>  	ep = of_graph_get_endpoint_by_regs(priv->dev->of_node, 0, 0);
> > >>  	if (!ep) {
> > >> -		dev_err(priv->dev, "Not connected to subdevice\n");
> > >> -		return -EINVAL;
> > >> +		dev_dbg(priv->dev, "Not connected to subdevice\n");
> > >> +		return 0;
> > >>  	}
> > >>  	
> > >>  	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
