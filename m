Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60500 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750874AbbDAWmR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2015 18:42:17 -0400
Date: Thu, 2 Apr 2015 01:41:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, pali.rohar@gmail.com,
	tony@atomide.com
Subject: Re: [PATCH 1/1] omap3isp: Don't pass uninitialised arguments to
 of_graph_get_next_endpoint()
Message-ID: <20150401224138.GE20756@valkosipuli.retiisi.org.uk>
References: <20150330174123.GA2658@earth>
 <1427757208-1938-1-git-send-email-sakari.ailus@iki.fi>
 <20150331013719.GA1096@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150331013719.GA1096@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

On Tue, Mar 31, 2015 at 03:37:20AM +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Tue, Mar 31, 2015 at 02:13:28AM +0300, Sakari Ailus wrote:
> > isp_of_parse_nodes() passed an uninitialised prev argument to
> > of_graph_get_next_endpoint(). This is bad, fix it by assigning NULL to it in
> > the initialisation.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > Reported-by: Sebastian Reichel <sre@kernel.org>
> > ---
> >  drivers/media/platform/omap3isp/isp.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> > index ff8f633..ff51c4f 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -2338,7 +2338,7 @@ static int isp_of_parse_node(struct device *dev, struct device_node *node,
> >  static int isp_of_parse_nodes(struct device *dev,
> >  			      struct v4l2_async_notifier *notifier)
> >  {
> > -	struct device_node *node;
> > +	struct device_node *node = NULL;
> >  
> >  	notifier->subdevs = devm_kcalloc(
> >  		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
> 
> Acked-By: Sebastian Reichel <sre@kernel.org>
> 
> Note, that this actually triggered the following stacktrace for me,
> so you may want to add a Fixes: <commitid> and the stacktrace to the
> commit message if its not merged with the original commit (relevant
> for people doing git bisect).

Thanks.

Laurent merged the patch with the original one, and will send a new pull
request.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
