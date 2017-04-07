Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59844 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751764AbdDGWIe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Apr 2017 18:08:34 -0400
Date: Sat, 8 Apr 2017 01:08:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/8] v4l: async: Add fwnode match support
Message-ID: <20170407220830.GK4192@valkosipuli.retiisi.org.uk>
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com>
 <2374089.j4OXu9zDtc@avalon>
 <20170407104508.GF4192@valkosipuli.retiisi.org.uk>
 <3116679.V91IAuC66O@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3116679.V91IAuC66O@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 07, 2017 at 01:47:11PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Friday 07 Apr 2017 13:45:09 Sakari Ailus wrote:
> > On Fri, Apr 07, 2017 at 01:04:47PM +0300, Laurent Pinchart wrote:
> > > > @@ -58,6 +60,9 @@ struct v4l2_async_subdev {
> > > >  			const struct device_node *node;
> > > >  		} of;
> > > >  		struct {
> > > > +			struct fwnode_handle *fwn;
> > > 
> > > Shouldn't this be const ?
> > 
> > I thought the same, but a lot of functions that operate on fwnode_handle
> > take a non-const argument. I attempted changing that, but it starts a
> > cascade of unavoidable changes elsewhere. That's not very well suitable for
> > this patchset.
> 
> fwnode is young, we should try to fix it instead of propagating issues :-)

I'm not arguing this would be how I'd prefer things to be. Adding a
dependency to another kernel framework would mean postponing the set. This
can well be fixed later on as well.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
