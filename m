Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC2CC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 12:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E1372075A
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 12:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbfBVMcp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:32:45 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60238 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726285AbfBVMcp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 07:32:45 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 83B94634C7B;
        Fri, 22 Feb 2019 14:32:28 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gxA0D-0000gF-8h; Fri, 22 Feb 2019 14:32:29 +0200
Date:   Fri, 22 Feb 2019 14:32:29 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH yavta 6/7] Support setting control from values stored in
 a file
Message-ID: <20190222123229.f233jer227mydzhf@valkosipuli.retiisi.org.uk>
References: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
 <20190220125123.9410-7-laurent.pinchart@ideasonboard.com>
 <20190220212651.dvwwjd4glylhfvtb@valkosipuli.retiisi.org.uk>
 <20190222114739.GS3522@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190222114739.GS3522@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Fri, Feb 22, 2019 at 01:47:39PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Wed, Feb 20, 2019 at 11:26:52PM +0200, Sakari Ailus wrote:
> > On Wed, Feb 20, 2019 at 02:51:22PM +0200, Laurent Pinchart wrote:
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > >  yavta.c | 25 +++++++++++++++++++++++++
> > >  1 file changed, 25 insertions(+)
> > > 
> > > diff --git a/yavta.c b/yavta.c
> > > index 1490878c6f7e..2d49131a4271 100644
> > > --- a/yavta.c
> > > +++ b/yavta.c
> > > @@ -1334,6 +1334,31 @@ static int video_parse_control_array(const struct v4l2_query_ext_ctrl *query,
> > >  	__u32 value;
> > >  
> > >  	for ( ; isspace(*val); ++val) { };
> > > +
> > > +	if (*val == '<') {
> > > +		/* Read the control value from the given file. */
> > > +		ssize_t size;
> > > +		int fd;
> > > +
> > > +		val++;
> > > +		fd = open(val, O_RDONLY);
> > > +		if (fd < 0) {
> > > +			printf("unable to open control file `%s'\n", val);
> > > +			return -EINVAL;
> > > +		}
> > > +
> > > +		size = read(fd, ctrl->ptr, ctrl->size);
> > 
> > Note that a read of count reads *up to* count number of bytes from the file
> > descriptor. In other words, it's perfectly correct for it to read less than
> > requested.
> > 
> > How about using fread(3) instead? Or changing this into a loop?
> 
> Do you expect this to cause issues in practice ? When does read() return
> less data than requested for regular files ?

API-wise there's no guarantee. This could simply fail for someone at some
point when reading a largish compound control.

Also try reading from e.g. /dev/random. :-)

-- 
Sakari Ailus
