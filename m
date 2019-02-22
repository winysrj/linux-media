Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB72C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98EFF206BB
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:47:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="gmjMvnBb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfBVLrp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:47:45 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:34034 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfBVLrp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 06:47:45 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9302D2D2;
        Fri, 22 Feb 2019 12:47:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550836063;
        bh=k/i7H9cyR+PiUyFg+XaPN52kRzG2YQixaq/wpVnnstw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gmjMvnBbZi4R7xV9IK8vz+Ac0AfQVTj2XmWBBHKohrXv6/dv3bKO7T9nlGOH7LI85
         p+iaelRMwFw3DSrrMHiyKqX9FRv6pSvzlZLNeiKnVoeDpYwEMJIDpEZEHFz6ClLvwm
         bT2FRUcrY7cQBLTlLo/JN3kqu3RNL3PYHeJG9Jpw=
Date:   Fri, 22 Feb 2019 13:47:39 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH yavta 6/7] Support setting control from values stored in
 a file
Message-ID: <20190222114739.GS3522@pendragon.ideasonboard.com>
References: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
 <20190220125123.9410-7-laurent.pinchart@ideasonboard.com>
 <20190220212651.dvwwjd4glylhfvtb@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190220212651.dvwwjd4glylhfvtb@valkosipuli.retiisi.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On Wed, Feb 20, 2019 at 11:26:52PM +0200, Sakari Ailus wrote:
> On Wed, Feb 20, 2019 at 02:51:22PM +0200, Laurent Pinchart wrote:
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  yavta.c | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> > 
> > diff --git a/yavta.c b/yavta.c
> > index 1490878c6f7e..2d49131a4271 100644
> > --- a/yavta.c
> > +++ b/yavta.c
> > @@ -1334,6 +1334,31 @@ static int video_parse_control_array(const struct v4l2_query_ext_ctrl *query,
> >  	__u32 value;
> >  
> >  	for ( ; isspace(*val); ++val) { };
> > +
> > +	if (*val == '<') {
> > +		/* Read the control value from the given file. */
> > +		ssize_t size;
> > +		int fd;
> > +
> > +		val++;
> > +		fd = open(val, O_RDONLY);
> > +		if (fd < 0) {
> > +			printf("unable to open control file `%s'\n", val);
> > +			return -EINVAL;
> > +		}
> > +
> > +		size = read(fd, ctrl->ptr, ctrl->size);
> 
> Note that a read of count reads *up to* count number of bytes from the file
> descriptor. In other words, it's perfectly correct for it to read less than
> requested.
> 
> How about using fread(3) instead? Or changing this into a loop?

Do you expect this to cause issues in practice ? When does read() return
less data than requested for regular files ?

> > +		if (size != (ssize_t)ctrl->size) {
> > +			printf("error reading control file `%s' (%s)\n", val,
> > +			       strerror(errno));
> > +			close(fd);
> > +			return -EINVAL;
> > +		}
> > +
> > +		close(fd);
> > +		return 0;
> > +	}
> > +
> >  	if (*val++ != '{')
> >  		return -EINVAL;
> >  

-- 
Regards,

Laurent Pinchart
