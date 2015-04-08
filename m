Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57773 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754010AbbDHWLm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2015 18:11:42 -0400
Date: Thu, 9 Apr 2015 01:11:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	s.nawrocki@samsung.com
Subject: Re: [PATCH v3 3/4] v4l: of: Parse variable length properties ---
 link-frequencies
Message-ID: <20150408221109.GY20756@valkosipuli.retiisi.org.uk>
References: <1428361053-20411-1-git-send-email-sakari.ailus@iki.fi>
 <1428361053-20411-4-git-send-email-sakari.ailus@iki.fi>
 <1770891.VD9MOjdNhM@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1770891.VD9MOjdNhM@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Apr 07, 2015 at 01:02:31PM +0300, Laurent Pinchart wrote:
> Hello Sakari,
> 
> Thank you for the patch.

Thanks for the review!

> On Tuesday 07 April 2015 01:57:31 Sakari Ailus wrote:
> > +/*
> > + * v4l2_of_free_endpoint() - release resources acquired by
> > + * v4l2_of_alloc_parse_endpoint()
> 
> I would say "free the endpoint allocated by v4l2_of_alloc_parse_endpoint()".
> 
> > + * @endpoint - the endpoint the resources of which are to be released
> > + *
> > + * It is safe to call this function with NULL argument or on and
> 
> s/and/an/

Fixed both.

> > + * endpoint the parsing of which failed.
> > + */
> > +void v4l2_of_free_endpoint(struct v4l2_of_endpoint *endpoint)
> > +{
> > +	if (IS_ERR_OR_NULL(endpoint))
> > +		return;
> > +
> > +	kfree(endpoint->link_frequencies);
> > +	kfree(endpoint);
> > +}
> > +EXPORT_SYMBOL(v4l2_of_free_endpoint);
> > +
> > +/**
> > + * v4l2_of_alloc_parse_endpoint() - parse all endpoint node properties
> > + * @node: pointer to endpoint device_node
> > + *
> > + * All properties are optional. If none are found, we don't set any flags.
> > + * This means the port has a static configuration and no properties have
> > + * to be specified explicitly.
> > + * If any properties that identify the bus as parallel are found and
> > + * slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarly, if we
> > recognise
> > + * the bus as serial CSI-2 and clock-noncontinuous isn't set, we set the
> > + * V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag.
> > + * The caller should hold a reference to @node.
> > + *
> > + * v4l2_of_alloc_parse_endpoint() has two important differences to
> > + * v4l2_of_parse_endpoint():
> > + *
> > + * 1. It also parses variable size data and
> > + *
> > + * 2. The memory resources it has acquired to store the variable size
> > + *    data must be released using v4l2_of_free_endpoint() when no longer
> > + *    needed.
> 
> I would s/resources it has acquired/it has allocated/ and s/released/freed/.

Fixed.

> Apart from that,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
