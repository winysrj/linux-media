Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43548 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752320AbdI2WF2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 18:05:28 -0400
Date: Sat, 30 Sep 2017 01:05:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 13/17] media: v4l2-async: simplify v4l2_async_subdev
 structure
Message-ID: <20170929220524.gsx3tmirdni2mhpx@valkosipuli.retiisi.org.uk>
References: <cover.1506548682.git.mchehab@s-opensource.com>
 <cd089c6dac22c8ea2194c47c48386e52bb6e561f.1506548682.git.mchehab@s-opensource.com>
 <20170928120920.ywgbtikkrts25qlj@valkosipuli.retiisi.org.uk>
 <20170929062119.192e4fd1@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170929062119.192e4fd1@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

(Removing the non-list recipients.)

On Fri, Sep 29, 2017 at 06:27:13AM -0300, Mauro Carvalho Chehab wrote:
> Em Thu, 28 Sep 2017 15:09:21 +0300
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > On Wed, Sep 27, 2017 at 06:46:56PM -0300, Mauro Carvalho Chehab wrote:
> > > The V4L2_ASYNC_MATCH_FWNODE match criteria requires just one
> > > struct to be filled (struct fwnode_handle). The V4L2_ASYNC_MATCH_DEVNAME
> > > match criteria requires just a device name.
> > > 
> > > So, it doesn't make sense to enclose those into structs,
> > > as the criteria can go directly into the union.
> > > 
> > > That makes easier to document it, as we don't need to document
> > > weird senseless structs.  
> > 
> > The idea is that in the union, there's a struct which is specific to the
> > match_type field. I wouldn't call it senseless.
> 
> Why a struct for each specific match_type is **needed**? It it is not
> needed, then it is senseless per definition :-) 
> 
> In the specific case of fwnode, there's already a named struct
> for fwnode_handle. The only thing is that it is declared outside
> enum v4l2_async_match_type. So, I don't see any reason to do things
> like:
> 
> 		struct {
> 			struct fwnode_handle *fwnode;
> 		} fwnode;
> 
> If you're in doubt about that, think on how would you document
> both fwnode structs. Both fwnode structs specify the match
> criteria if %V4L2_ASYNC_MATCH_FWNODE.
> 
> The same applies to this:
> 
> 		struct {
> 			const char *name;
> 		} device_name;
> 
> Both device_name and name specifies the match criteria if
> %V4L2_ASYNC_MATCH_DEVNAME.
> 
> > 
> > In the two cases there's just a single field in the containing struct. You
> > could remove the struct in that case as you do in this patch, and just use
> > the field. But I think the result is less clean and so I wouldn't make this
> > change.
> 
> It is actually cleaner without the stucts.
> 
> Without the useless struct, if one wants to match a firmware node, it
> should be doing:
> 
>  		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_FWNODE;
> 		pdata->asd[i]->match.fwnode = of_fwnode_handle(rem);

This code should be and will be moved out of drivers. See:

<URL:http://www.spinics.net/lists/linux-media/msg122688.html>

So there are going to be quite a bit fewer instances of it, and none should
remain in drivers. I frankly don't have a strong opinion on this; there are
arguments for and against. I just don't see a reason to change it.

It'd be nice to have Hans's and Laurent's opinion though.

> 
> And that' it. For anyone that reads the above code, even not knowing
> all details of "match", is clear that the match criteria is whatever
> of_fwnode_handle() returns.
> 
> Now, on this:
> 
>  		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_FWNODE;
> 		pdata->asd[i]->match.fwnode.fwnode = of_fwnode_handle(rem);
> 
> It sounds that something is missing, as only one field of match.fwnode
> was specified. Anyone not familiar with that non-conventional usage of
> a struct with just one struct field inside would need to seek for the
> header file declaring the struct. That would consume a lot of time for
> code reviewers for no good reason.
> 
> The same apply for devname search:
> 
> In this case:
> 		asd->match_type = V4L2_ASYNC_MATCH_DEVNAME;
> 		asd->match.device_name.name = imxsd->devname;
> 
> I would be expecting something else to be filled at device_name's
> struct, for example to specify a case sensitive or case insensitive
> match criteria, to allow seeking for a device's substring, or to
> allow using other struct device fields to narrow the seek.
> 
> With this:
> 
> 		asd->match_type = V4L2_ASYNC_MATCH_DEVNAME;
> 		asd->match.device_name = imxsd->devname;
> 
> It is clear that the match criteria is fully specified.
> 
> > The confusion comes possibly from the fact that the struct is named the
> > same as the field in the struct. These used to be called of and node, but
> > with the fwnode property framework the references to the fwnode are, well,
> > typically similarly called "fwnode". There's no underlying firmware
> > interface with that name, fwnode property API is just an API.
> 
> The duplicated "fwnode" name only made it more evident that we don't
> need to enclose a single match criteria field inside a struct.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
