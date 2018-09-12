Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:19773 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbeIMBxJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 21:53:09 -0400
Date: Wed, 12 Sep 2018 23:46:50 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        slongerbeam@gmail.com, niklas.soderlund@ragnatech.se
Subject: Re: [PATCH v2 07/23] v4l: fwnode: Let the caller provide V4L2 fwnode
 endpoint
Message-ID: <20180912204650.6trvsboictmkw3ee@kekkonen.localdomain>
References: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
 <20180827093000.29165-8-sakari.ailus@linux.intel.com>
 <20180912145107.GA11509@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180912145107.GA11509@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Wed, Sep 12, 2018 at 04:51:07PM +0200, jacopo mondi wrote:
> Hi Sakari,
> 
> On Mon, Aug 27, 2018 at 12:29:44PM +0300, Sakari Ailus wrote:
> > Instead of allocating the V4L2 fwnode endpoint in
> > v4l2_fwnode_endpoint_alloc_parse, let the caller to do this. This allows
> > setting default parameters for the endpoint which is a very common need
> > for drivers.
> >
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/i2c/ov2659.c             | 14 +++++-----
> >  drivers/media/i2c/smiapp/smiapp-core.c | 26 +++++++++---------
> >  drivers/media/i2c/tc358743.c           | 26 +++++++++---------
> >  drivers/media/v4l2-core/v4l2-fwnode.c  | 49 +++++++++++++---------------------
> >  include/media/v4l2-fwnode.h            | 10 ++++---
> >  5 files changed, 60 insertions(+), 65 deletions(-)
> >
> 
> [snip]
> 
> > -struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
> > -	struct fwnode_handle *fwnode)
> > +int v4l2_fwnode_endpoint_alloc_parse(
> > +	struct fwnode_handle *fwnode, struct v4l2_fwnode_endpoint *vep)
> 
> Looking at the resulting implementation of
> "v4l2_fwnode_endpoint_alloc_parse" and "v4l2_fwnode_endpoint_parse" I
> wonder if there's still value in keeping them separate... Now that in
> both cases the caller has to provide an v4l2_fwnode_endpoint, isn't it
> worth making a single function out of them, that behaves like
> "alloc_parse" is doing nowadays (allocates vep->link_frequencies
> conditionally on the presence of the "link-frequencies" property) ?

The problem with that would be that the caller would have to know if there
are variable length properties, i.e. the caller would always have to call
v4l2_fwnode_endpoint_free() once it no longer needs them. For quite a few
drivers this means immediately after calling the function which parsed
them.

I prefer to keep this simple for the drivers that need no such properties.

> 
> Or is the size of the allocated vep relevant in the async subdevice
> matching or registration process? I guess not, but I might be missing
> something...

It's not. The link frequencies are a pointer anyway.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
