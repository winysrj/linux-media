Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45738 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932756AbdLRTKR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 14:10:17 -0500
Date: Mon, 18 Dec 2017 17:10:10 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 14/17] media: v4l2-async: better describe match union
 at async match struct
Message-ID: <20171218171010.30603571@vento.lan>
In-Reply-To: <3225637.LUfJIgpqCe@avalon>
References: <cover.1506548682.git.mchehab@s-opensource.com>
        <d7534d804eedd7bd6bc46b65a810679bda81b3cc.1506548682.git.mchehab@s-opensource.com>
        <3225637.LUfJIgpqCe@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 13 Oct 2017 15:49:25 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Thursday, 28 September 2017 00:46:57 EEST Mauro Carvalho Chehab wrote:
> > Now that kernel-doc handles nested unions, better document the
> > match union at struct v4l2_async_subdev.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  include/media/v4l2-async.h | 35 ++++++++++++++++++++++++++++++++---
> >  1 file changed, 32 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> > index e66a3521596f..62c2d572ec23 100644
> > --- a/include/media/v4l2-async.h
> > +++ b/include/media/v4l2-async.h
> > @@ -46,10 +46,39 @@ enum v4l2_async_match_type {
> >  /**
> >   * struct v4l2_async_subdev - sub-device descriptor, as known to a bridge
> >   *
> > - * @match_type:	type of match that will be used
> > - * @match:	union of per-bus type matching data sets
> > + * @match_type:
> > + *	type of match that will be used
> > + * @match:
> > + *	union of per-bus type matching data sets  
> 
> The lines don't exceed the 80 columnes limit, you can keep them as-is.

OK.

> 
> > + * @match.fwnode:
> > + *		pointer to &struct fwnode_handle to be matched.
> > + *		Used if @match_type is %V4L2_ASYNC_MATCH_FWNODE.
> > + * @match.device_name:
> > + *		string containing the device name to be matched.
> > + *		Used if @match_type is %V4L2_ASYNC_MATCH_DEVNAME.
> > + * @match.i2c:
> > + *		embedded struct with I2C parameters to be matched.
> > + * 		Both @match.i2c.adapter_id and @match.i2c.address
> > + *		should be matched.
> > + *		Used if @match_type is %V4L2_ASYNC_MATCH_I2C.  
> 
> Do you really need to document this ? Isn't it enough to document 
> @match.i2c.adapter_id and @match.i2c.address ?

No. If we don't document a non-anonymous struct, kernel-doc will complain
that a field description is missed. Same applies to the custom field
below.

There's a way to get rid of it: converting it to an anonymous
struct, but I guess that will make the usage of the match rule
harder to understand.

> 
> > + * @match.i2c.adapter_id:
> > + *		I2C adapter ID to be matched.
> > + *		Used if @match_type is %V4L2_ASYNC_MATCH_I2C.
> > + * @match.i2c.address:
> > + *		I2C address to be matched.
> > + *		Used if @match_type is %V4L2_ASYNC_MATCH_I2C.
> > + * @match.custom:
> > + *		Driver-specific match criteria.
> > + *		Used if @match_type is %V4L2_ASYNC_MATCH_CUSTOM.  
> 
> Same here.
> 
> > + * @match.custom.match:
> > + *		Driver-specific match function to be used if
> > + *		%V4L2_ASYNC_MATCH_CUSTOM.
> > + * @match.custom.priv:
> > + *		Driver-specific private struct with match parameters
> > + *		to be used if %V4L2_ASYNC_MATCH_CUSTOM.
> >   * @list:	used to link struct v4l2_async_subdev objects, waiting to be
> > - *		probed, to a notifier->waiting list
> > + *		probed, to a notifier->waiting list.
> > + *		Not to be used by drivers.
> >   */
> >  struct v4l2_async_subdev {
> >  	enum v4l2_async_match_type match_type;  
> 

Thanks,
Mauro
