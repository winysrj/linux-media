Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33249 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbcDUJlc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2016 05:41:32 -0400
Received: by mail-lf0-f48.google.com with SMTP id e190so57134929lfe.0
        for <linux-media@vger.kernel.org>; Thu, 21 Apr 2016 02:41:31 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Thu, 21 Apr 2016 11:41:28 +0200
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	ulrich.hecht@gmail.com, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCHv4] [media] rcar-vin: add Renesas R-Car VIN driver
Message-ID: <20160421094128.GK19650@bigcity.dyn.berto.se>
References: <1460471585-11225-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
 <57187972.9020904@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <57187972.9020904@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-04-21 08:55:46 +0200, Hans Verkuil wrote:
> On 04/12/2016 04:33 PM, Niklas Söderlund wrote:
> > +static void rect_set_min_size(struct v4l2_rect *r,
> > +			      const struct v4l2_rect *min_size)
> > +{
> > +	if (r->width < min_size->width)
> > +		r->width = min_size->width;
> > +	if (r->height < min_size->height)
> > +		r->height = min_size->height;
> > +}
> > +
> > +static void rect_set_max_size(struct v4l2_rect *r,
> > +			      const struct v4l2_rect *max_size)
> > +{
> > +	if (r->width > max_size->width)
> > +		r->width = max_size->width;
> > +	if (r->height > max_size->height)
> > +		r->height = max_size->height;
> > +}
> > +
> > +static void rect_map_inside(struct v4l2_rect *r,
> > +			    const struct v4l2_rect *boundary)
> > +{
> > +	rect_set_max_size(r, boundary);
> > +
> > +	if (r->left < boundary->left)
> > +		r->left = boundary->left;
> > +	if (r->top < boundary->top)
> > +		r->top = boundary->top;
> > +	if (r->left + r->width > boundary->width)
> > +		r->left = boundary->width - r->width;
> > +	if (r->top + r->height > boundary->height)
> > +		r->top = boundary->height - r->height;
> > +}
> > +
> 
> The v4l2-rect.h helpers have been merged, so you should be able to use
> those for v5 and drop these functions here.

Thanks I'm about to send out a v5 so this was good timing. I did just 
discover one odd behavior in the driver I would like to look in to 
today. But will include the v4l2-rect.h helpers in v5.

-- 
Regards,
Niklas Söderlund
