Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53614 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751317AbbCLWZF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 18:25:05 -0400
Date: Fri, 13 Mar 2015 00:25:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com
Subject: Re: [RFC 13/18] v4l: of: Read lane-polarity endpoint property
Message-ID: <20150312222503.GN11954@valkosipuli.retiisi.org.uk>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
 <1425764475-27691-14-git-send-email-sakari.ailus@iki.fi>
 <5943571.XgR4Bv1QGx@avalon>
 <20150312222327.GM11954@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150312222327.GM11954@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 13, 2015 at 12:23:27AM +0200, Sakari Ailus wrote:
...
> > > +
> > > +		for (i = 0; i < ARRAY_SIZE(bus->lane_polarity); i++) {
> > > +			polarity = of_prop_next_u32(prop, polarity, &v);
> > > +			if (!polarity)
> > > +				break;
> > > +			bus->lane_polarity[i] = v;
> > > +		}
> > 
> > Should we check that i == num_data_lines + 1 ?
> 
> Good question. I think I'd just replace this with
> of_property_read_u32_array() instead, how about that? Then there would have
> to be at least as many lane polarities defined as there are lanes (data and
> clock). Defining more wouldn't be an error.

Oh, I missed the variable in the struct is bool. I'll just add the check.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
