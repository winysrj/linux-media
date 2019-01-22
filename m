Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 194CBC282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E72A320879
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbfAVPPK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:15:10 -0500
Received: from mga04.intel.com ([192.55.52.120]:63507 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728744AbfAVPPK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 10:15:10 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 07:15:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,506,1539673200"; 
   d="scan'208";a="116505759"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga007.fm.intel.com with ESMTP; 22 Jan 2019 07:15:07 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id BECD9205C8; Tue, 22 Jan 2019 17:15:06 +0200 (EET)
Date:   Tue, 22 Jan 2019 17:15:06 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 09/30] media: entity: Swap pads if route is checked
 from source to sink
Message-ID: <20190122151506.fnlfvwtoq7qunz45@paasikivi.fi.intel.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-10-niklas.soderlund+renesas@ragnatech.se>
 <20190115225743.GH28397@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190115225743.GH28397@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Wed, Jan 16, 2019 at 12:57:43AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Fri, Nov 02, 2018 at 12:31:23AM +0100, Niklas Söderlund wrote:
> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > This way the pads are always passed to the has_route() op sink pad first.
> > Makes sense.
> 
> Is there anything in the API that mandates one pad to be a sink and the
> other pad to the a source ? I had designed the operation to allow
> sink-sink and source-source connections to be checked too.

Do you have a use case in mind for sink--sink or source--source routes? The
routes are about flows of data, so I'd presume only source--sink or
sink--source routes are meaningful.

If you did, then the driver would have to handle that by itself. This still
simplifies the implementation for drivers that do not.

> 
> If your goal is to simplify the implementation of the .has_route()
> operation in drivers, I would instead sort pad0 and pad1 by value.

That'd be another option to make the order deterministic for the driver.
I'm fine with that as well.

> 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/media-entity.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index 3c0e7425c8983b45..33f00e35ccd92c6f 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -249,6 +249,10 @@ bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
> >  	if (!entity->ops || !entity->ops->has_route)
> >  		return true;
> >  
> > +	if (entity->pads[pad0].flags & MEDIA_PAD_FL_SOURCE
> > +	    && entity->pads[pad1].flags & MEDIA_PAD_FL_SINK)
> > +		swap(pad0, pad1);
> > +
> >  	return entity->ops->has_route(entity, pad0, pad1);
> >  }
> >  EXPORT_SYMBOL_GPL(media_entity_has_route);
> 
> -- 
> Regards,
> 
> Laurent Pinchart

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
