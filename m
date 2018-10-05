Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:14251 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbeJERYF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 13:24:05 -0400
Date: Fri, 5 Oct 2018 13:22:38 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sebastian Reichel <sre@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH 1/3] media: v4l2-core: cleanup coding style at V4L2
 async/fwnode
Message-ID: <20181005102238.nr7mml3dis4pch25@paasikivi.fi.intel.com>
References: <cover.1538690587.git.mchehab+samsung@kernel.org>
 <cde4a0f967c695aa56fcb28f1b70cffcd4b55666.1538690587.git.mchehab+samsung@kernel.org>
 <20181005075557.oks67snwclvnrw4r@paasikivi.fi.intel.com>
 <20181005071202.65fb5203@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005071202.65fb5203@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Oct 05, 2018 at 07:12:02AM -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 5 Oct 2018 10:55:58 +0300
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
...
> > > @@ -436,8 +437,7 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
> > >  		if (mbus_type != V4L2_MBUS_UNKNOWN &&
> > >  		    vep->bus_type != mbus_type) {
> > >  			pr_debug("expecting bus type %s\n",
> > > -				 v4l2_fwnode_mbus_type_to_string(
> > > -					 vep->bus_type));
> > > +				 v4l2_fwnode_mbus_type_to_string(vep->bus_type));  
> > 
> > This one's over 80. I preferred what it was. But I have no strong
> > preference here.
> > 
> > >  			return -ENXIO;
> > >  		}
> > >  	} else {
> > > @@ -452,8 +452,8 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
> > >  			return rval;
> > >  
> > >  		if (vep->bus_type == V4L2_MBUS_UNKNOWN)
> > > -			v4l2_fwnode_endpoint_parse_parallel_bus(
> > > -				fwnode, vep, V4L2_MBUS_UNKNOWN);  
> > 
> > This is not uncommon way of aligning function arguments when short of
> > space. It is also not exceeding 80 characters, as the replacement below.
> 
> Well, Lindent used to align like that. That's why we see it on lots of
> code inside media: in the past, people tend to use it to get rid of
> some checkpatch warnings. Lindent script has long gone (still people
> sometimes call indent), and now checkpatch evolved, and has a
> --fix-inplace, with is usually enough to pinpoint where to change
> (although it does a crap job for more multi-line function args).
> 
> As a reviewer, this hurts my eyes. It took me more time to review
> something like
> 			v4l2_fwnode_endpoint_parse_parallel_bus(
> 				fwnode, vep, V4L2_MBUS_UNKNOWN); 
> 
> than something like:
> 			v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep,
> 								V4L2_MBUS_UNKNOWN);

I think this is somewhat a matter of taste and I prefer it different. :-)

> 
> The parenthesis alignment really helps to identify that the second
> line are arguments.
> 
> Btw, if you use checkpatch with --strict, you'll see that this is 
> not the right Kernel coding style. It will complain for both ending a
> line with an open parenthesis and that the second line is not aligned.

Right; V4L2 has a lot of that pattern (also elsewhere) but you'd get told
to fix that if it were in another tree (non-media). I think we agree on
renaming the very long function names; it'll get rid of probably much of
that pattern. I'll submit patches for that later on, possibly including
other improvements to the API. But that'll be after 4.20.

> 
> > 
> > > +			v4l2_fwnode_endpoint_parse_parallel_bus(fwnode, vep,
> > > +								V4L2_MBUS_UNKNOWN);
> > >  
> > >  		pr_debug("assuming media bus type %s (%u)\n",
> > >  			 v4l2_fwnode_mbus_type_to_string(vep->bus_type),
> > > @@ -511,8 +511,8 @@ void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep)
> > >  }
> > >  EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_free);
> > >  
> > > -int v4l2_fwnode_endpoint_alloc_parse(
> > > -	struct fwnode_handle *fwnode, struct v4l2_fwnode_endpoint *vep)
> > > +int v4l2_fwnode_endpoint_alloc_parse(struct fwnode_handle *fwnode,
> > > +				     struct v4l2_fwnode_endpoint *vep)
> > >  {
> > >  	int rval;
> > >  
> > > @@ -533,9 +533,10 @@ int v4l2_fwnode_endpoint_alloc_parse(
> > >  
> > >  		vep->nr_of_link_frequencies = rval;
> > >  
> > > -		rval = fwnode_property_read_u64_array(
> > > -			fwnode, "link-frequencies", vep->link_frequencies,
> > > -			vep->nr_of_link_frequencies);
> > > +		rval = fwnode_property_read_u64_array(fwnode,
> > > +						      "link-frequencies",
> > > +						      vep->link_frequencies,
> > > +						      vep->nr_of_link_frequencies);  
> > 
> > Over 80 characters.
> 
> True, but it is better to violate 80-cols (those days, I guess everybody
> uses a graphical environment), than to not align the arguments.
> 
> The 80-cols is there nowadays mostly to warn about code complexity, where
> multiple indentations are present.

I also review the patches using Mutt and my terminal window width is set at
80 characters. That's not uncommon I believe.

> 
> For a reviewer, the parenthesis alignment is a way more relevant, as
> it allows to immediately notice that the two following lines are
> arguments of the function, and not a new indentation level.

That's a valid point, yet more important is that it's not at the same level
than the first line of the statement (function call). So I think we're
discussing matters of somewhat secondary importance.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
