Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51324 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755770AbbDJWlD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 18:41:03 -0400
Date: Sat, 11 Apr 2015 01:40:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v4 1/4] v4l: of: Remove the head field in struct
 v4l2_of_endpoint
Message-ID: <20150410224059.GK20756@valkosipuli.retiisi.org.uk>
References: <1428614706-8367-1-git-send-email-sakari.ailus@iki.fi>
 <1428614706-8367-2-git-send-email-sakari.ailus@iki.fi>
 <55279C28.5080900@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55279C28.5080900@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Fri, Apr 10, 2015 at 11:47:20AM +0200, Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> On 09/04/15 23:25, Sakari Ailus wrote:
> > The field is unused. Remove it.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  include/media/v4l2-of.h |    2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
> > index f831c9c..f66b92c 100644
> > --- a/include/media/v4l2-of.h
> > +++ b/include/media/v4l2-of.h
> > @@ -57,7 +57,6 @@ struct v4l2_of_bus_parallel {
> >   * @base: struct of_endpoint containing port, id, and local of_node
> >   * @bus_type: bus type
> >   * @bus: bus configuration data structure
> > - * @head: list head for this structure
> >   */
> >  struct v4l2_of_endpoint {
> >  	struct of_endpoint base;
> > @@ -66,7 +65,6 @@ struct v4l2_of_endpoint {
> >  		struct v4l2_of_bus_parallel parallel;
> >  		struct v4l2_of_bus_mipi_csi2 mipi_csi2;
> >  	} bus;
> > -	struct list_head head;
> >  };
> 
> I don't remember what this list_head was originally intended for,
> probably for some code in soc_camera on which didn't the works were
> postponed or abandoned. Presumably now such code would likely live
> in drivers/of/base.c anyway.

I thought something like that might have happened. I wasn't involved with
this at the time so I didn't remember... should have been a separate patch
though.

> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Many thanks for the review!

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
