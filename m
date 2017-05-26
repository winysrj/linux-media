Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41774 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1948758AbdEZVwN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 17:52:13 -0400
Date: Sat, 27 May 2017 00:52:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2 1/2] media: entity: Add pad_from_fwnode entity
 operation
Message-ID: <20170526215209.GT29527@valkosipuli.retiisi.org.uk>
References: <20170524000907.13061-1-niklas.soderlund@ragnatech.se>
 <20170524000907.13061-2-niklas.soderlund@ragnatech.se>
 <20170524132137.GK29527@valkosipuli.retiisi.org.uk>
 <20170524140736.GB7346@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170524140736.GB7346@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hejssan,

On Wed, May 24, 2017 at 04:07:36PM +0200, Niklas Söderlund wrote:
> Hi Sakari,
> 
> Thanks for your feedback.
> 
> On 2017-05-24 16:21:37 +0300, Sakari Ailus wrote:
> > Hi Niklas,
> > 
> > On Wed, May 24, 2017 at 02:09:06AM +0200, Niklas Söderlund wrote:
> > > From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > 
> > > The optional operation can be used by entities to report how it maps its
> > > fwnode endpoints to media pad numbers. This is useful for devices which
> > > require advanced mappings of pads.
> > > 
> > > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > ---
> > >  include/media/media-entity.h | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > > index c7c254c5bca1761b..2aea22b0409d1070 100644
> > > --- a/include/media/media-entity.h
> > > +++ b/include/media/media-entity.h
> > > @@ -21,6 +21,7 @@
> > >  
> > >  #include <linux/bitmap.h>
> > >  #include <linux/bug.h>
> > > +#include <linux/fwnode.h>
> > >  #include <linux/kernel.h>
> > >  #include <linux/list.h>
> > >  #include <linux/media.h>
> > > @@ -171,6 +172,9 @@ struct media_pad {
> > >  
> > >  /**
> > >   * struct media_entity_operations - Media entity operations
> > > + * @pad_from_fwnode:	Return the pad number based on a fwnode endpoint.
> > > + *			This operation can be used to map a fwnode to a
> > > + *			media pad number. Optional.
> > >   * @link_setup:		Notify the entity of link changes. The operation can
> > >   *			return an error, in which case link setup will be
> > >   *			cancelled. Optional.
> > > @@ -184,6 +188,8 @@ struct media_pad {
> > >   *    mutex held.
> > >   */
> > >  struct media_entity_operations {
> > > +	int (*pad_from_fwnode)(struct fwnode_endpoint *endpoint,
> > > +			       unsigned int *pad);
> > 
> > Hmm. How about calling this get_fwnode_pad for instance? I wonder what
> > others think.
> 
> I'm OK with this name change, will update for next version.
> 
> > 
> > You could just return the pad number still, and a negative value on error. I
> > think we won't have more than INT_MAX pads. :-)
> 
> I did that at first but then I remembered all the review comments I have 
> gotten earlier about using int as the type for pads :-) If you and 
> others agree in this case returning the pad as int or a negative value 
> as error I have no problem chaining this for the next version.

unsigned int was proposed for there was no need for negative values. In this
case there is.

I don't really have a strong opinion either way. I wonder what Hans or
Laurent thinks.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
