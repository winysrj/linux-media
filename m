Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E23FC282C5
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F0BA217F4
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbfAVPij (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:38:39 -0500
Received: from mga04.intel.com ([192.55.52.120]:1087 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728628AbfAVPij (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 10:38:39 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 07:38:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,506,1539673200"; 
   d="scan'208";a="110129653"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga006.jf.intel.com with ESMTP; 22 Jan 2019 07:38:36 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 50B69205C8; Tue, 22 Jan 2019 17:38:36 +0200 (EET)
Date:   Tue, 22 Jan 2019 17:38:36 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 14/30] media: entity: Add debug information in graph
 walk route check
Message-ID: <20190122153835.76552madyz7dbz6l@paasikivi.fi.intel.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-15-niklas.soderlund+renesas@ragnatech.se>
 <20190115233514.GD31088@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190115233514.GD31088@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 16, 2019 at 01:35:14AM +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Fri, Nov 02, 2018 at 12:31:28AM +0100, Niklas Söderlund wrote:
> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/media-entity.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index a5bb257d5a68f755..42977634d7102852 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -360,6 +360,9 @@ static void media_graph_walk_iter(struct media_graph *graph)
> >  	 */
> >  	if (!media_entity_has_route(pad->entity, pad->index, local->index)) {
> >  		link_top(graph) = link_top(graph)->next;
> > +		dev_dbg(pad->graph_obj.mdev->dev,
> > +			"walk: skipping \"%s\":%u -> %u (no route)\n",
> > +			pad->entity->name, pad->index, local->index);
> 
> Maybe "%s: skipping...", __func__, ?

We already have a similar format elsewhere for messages alike. I'd add the
function name to all of them rather than just this one. The message is also
informative and unique enough to be easily found.

> 
> Apart from that,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> >  		return;
> >  	}
> >  
> 
> -- 
> Regards,
> 
> Laurent Pinchart

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
