Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:33553 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755291AbdD1L5z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 07:57:55 -0400
Received: by mail-lf0-f47.google.com with SMTP id 88so32639842lfr.0
        for <linux-media@vger.kernel.org>; Fri, 28 Apr 2017 04:57:54 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 28 Apr 2017 13:57:52 +0200
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/2] media: entity: Add pad_from_dt_regs entity operation
Message-ID: <20170428115752.GD1532@bigcity.dyn.berto.se>
References: <20170427223323.13861-1-niklas.soderlund+renesas@ragnatech.se>
 <20170427223323.13861-2-niklas.soderlund+renesas@ragnatech.se>
 <20170428103256.GG7456@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170428103256.GG7456@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for your feedback.

On 2017-04-28 13:32:57 +0300, Sakari Ailus wrote:
> Hi Niklas,
> 
> On Fri, Apr 28, 2017 at 12:33:22AM +0200, Niklas Söderlund wrote:
> > The optional operation can be used by entities to report how it maps its
> > DT node ports and endpoints to media pad numbers. This is useful for
> > devices which require more advanced mappings of pads then DT port
> > number is equivalent with media port number.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  include/media/media-entity.h | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index c7c254c5bca1761b..47efaf4d825e671b 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -171,6 +171,9 @@ struct media_pad {
> >  
> >  /**
> >   * struct media_entity_operations - Media entity operations
> > + * @pad_from_dt_regs:	Return the pad number based on DT port and reg
> > + *			properties. This operation can be used to map a
> > + *			DT port and reg to a media pad number. Optional.
> 
> Don't you need to provide entity as an argument as well? The driver will be
> a little bit loss due to lack of context. :-)

I'm not sure I understand you, this is a entity operation so the driver 
will know for which entity the request is mad on. Or am I missing 
something?

> 
> How about using the endpoint's device node (or fwnode; you can get it using
> of_fwnode_handle() soon) instead? You can always obtain the port node by
> just getting the parent.

I did think about that but opted for port_reg and reg since it seemed 
more simple.

But it might be better to base this work on top of your fwnode work,
s/from_dt_regs/from_fwnode/ and use the of_fwnode_handle() as you 
suggest here. Do you think this would be valuable and make this new 
operation more useful?

> 
> >   * @link_setup:		Notify the entity of link changes. The operation can
> >   *			return an error, in which case link setup will be
> >   *			cancelled. Optional.
> > @@ -184,6 +187,7 @@ struct media_pad {
> >   *    mutex held.
> >   */
> >  struct media_entity_operations {
> > +	int (*pad_from_dt_regs)(int port_reg, int reg, unsigned int *pad);
> >  	int (*link_setup)(struct media_entity *entity,
> >  			  const struct media_pad *local,
> >  			  const struct media_pad *remote, u32 flags);
> 
> -- 
> Kind regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

-- 
Regards,
Niklas Söderlund
