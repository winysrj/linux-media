Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44660 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755228AbaJ1XdP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 19:33:15 -0400
Date: Wed, 29 Oct 2014 01:33:12 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/1] media: Print information on failed link validation
Message-ID: <20141028233311.GD3136@valkosipuli.retiisi.org.uk>
References: <1412372439-4184-1-git-send-email-sakari.ailus@iki.fi>
 <1414537804-25303-1-git-send-email-sakari.ailus@iki.fi>
 <3033119.78jigqieeC@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3033119.78jigqieeC@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Oct 29, 2014 at 01:20:06AM +0200, Laurent Pinchart wrote:
> >  			ret = -EPIPE;
> > +			dev_dbg(entity->parent->dev,
> > +				"\"%s\":%u must be connected by an enabled link, error %d\n",
> > +				entity->name,
> > +				find_first_zero_bit(active, entity->num_pads),
> > +				ret);
> 
> Given that ret is always set to -EPIPE, I wouldn't print ", error %d".
> 
> Apart from that,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks for the ack. Good point as well, I'll fix that for v3.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
