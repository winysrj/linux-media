Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33414 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966091AbeBMXMx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 18:12:53 -0500
Received: by mail-lf0-f65.google.com with SMTP id j193so11265568lfe.0
        for <linux-media@vger.kernel.org>; Tue, 13 Feb 2018 15:12:53 -0800 (PST)
Date: Wed, 14 Feb 2018 00:12:50 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v10 10/30] rcar-vin: fix handling of single field frames
 (top, bottom and alternate fields)
Message-ID: <20180213231250.GA23581@bigcity.dyn.berto.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se>
 <1615346.M5jUZRACzr@avalon>
 <20180213164704.GD18618@bigcity.dyn.berto.se>
 <3791727.mLP5MD9T4p@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3791727.mLP5MD9T4p@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 2018-02-14 00:31:21 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> On Tuesday, 13 February 2018 18:47:04 EET Niklas Söderlund wrote:
> > On 2018-02-13 18:26:34 +0200, Laurent Pinchart wrote:
> > > On Monday, 29 January 2018 18:34:15 EET Niklas Söderlund wrote:
> > >> There was never proper support in the VIN driver to deliver ALTERNATING
> > >> field format to user-space, remove this field option. The problem is
> > >> that ALTERNATING filed order requires the sequence numbers of buffers
> > >> returned to userspace to reflect if fields where dropped or not,
> > >> something which is not possible with the VIN drivers capture logic.
> > >> 
> > >> The VIN driver can still capture from a video source which delivers
> > >> frames in ALTERNATING field order, but needs to combine them using the
> > >> VIN hardware into INTERLACED field order. Before this change if a source
> > >> was delivering fields using ALTERNATE the driver would default to
> > >> combining them using this hardware feature. Only if the user explicitly
> > >> requested ALTERNATE filed order would incorrect frames be delivered.
> > >> 
> > >> The height should not be cut in half for the format for TOP or BOTTOM
> > >> fields settings. This was a mistake and it was made visible by the
> > >> scaling refactoring. Correct behavior is that the user should request a
> > >> frame size that fits the half height frame reflected in the field
> > >> setting. If not the VIN will do its best to scale the top or bottom to
> > >> the requested format and cropping and scaling do not work as expected.
> > >> 
> > >> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > >> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> > >> ---
> > >> 
> > >>  drivers/media/platform/rcar-vin/rcar-dma.c  | 15 +-------
> > >>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 53 +++++++++++------------
> > >>  2 files changed, 24 insertions(+), 44 deletions(-)
> 
> [snip]
> 
> > >> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > >> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> > >> 4d5be2d0c79c9c9a..9f7902d29c62e205 100644
> > >> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > >> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > >> @@ -103,6 +103,28 @@ static int rvin_get_source_format(struct rvin_dev
> > >> *vin,
> > >>  	if (ret)
> > >>  		return ret;
> > >> 
> > >> +	switch (fmt.format.field) {
> > >> +	case V4L2_FIELD_TOP:
> > >> +	case V4L2_FIELD_BOTTOM:
> > >> +	case V4L2_FIELD_NONE:
> > >> +	case V4L2_FIELD_INTERLACED_TB:
> > >> +	case V4L2_FIELD_INTERLACED_BT:
> > >> +	case V4L2_FIELD_INTERLACED:
> > >> +		break;
> > >> +	case V4L2_FIELD_ALTERNATE:
> > >> +		/*
> > >> +		 * Driver do not (yet) support outputting ALTERNATE to a
> > >> +		 * userspace. It dose support outputting INTERLACED so use
> > > 
> > > s/dose/does/
> > > 
> > >> +		 * the VIN hardware to combine the two fields.
> > >> +		 */
> > >> +		fmt.format.field = V4L2_FIELD_INTERLACED;
> > >> +		fmt.format.height *= 2;
> > >> +		break;
> > > 
> > > I don't like this much. The rvin_get_source_format() function is supposed
> > > to return the media bus format for the bus between the source and the
> > > VIN. It's the caller that should take the field limitations into account,
> > > otherwise you end up with a mix of source and VIN data in the same
> > > structure.
> > 
> > When I read your comments I understand your argument better. And I
> > understand this function is perhaps poorly named. Maybe it should be
> > renamed to rvin_get_vin_format_from_source().
> 
> If you add a comment above the function I could live with that. Would it make 
> sense to pass a v4l2_pix_format structure instead of a v4l2_mbus_framefmt ?

I now see that the function name is misleading and I will change it as 
per above. I will also add a comment and swap to v4l2_pix_format (which 
was used before v10 but was changed due to your review comments, I'm 
happy you come around :-)

> 
> > The source format is fetched at s_stream() time in order to do format
> > validation. At this time the field is also taken into account once more
> > to validate that the VIN format (calculated here) still is valid. It
> > also handles the question you ask later at s_stream() time, see bellow.
> > 
> > >> +	default:
> > >> +		vin->format.field = V4L2_FIELD_NONE;
> > >> +		break;
> > >> +	}
> > >> +
> > >>  	memcpy(mbus_fmt, &fmt.format, sizeof(*mbus_fmt));
> > >>  	
> > >>  	return 0;
> > >> @@ -139,33 +161,6 @@ static int rvin_reset_format(struct rvin_dev *vin)
> > >> 
> > >>  	v4l2_fill_pix_format(&vin->format, &source_fmt);
> > >> 
> > >> -	/*
> > >> -	 * If the subdevice uses ALTERNATE field mode and G_STD is
> > >> -	 * implemented use the VIN HW to combine the two fields to
> > >> -	 * one INTERLACED frame. The ALTERNATE field mode can still
> > >> -	 * be requested in S_FMT and be respected, this is just the
> > >> -	 * default which is applied at probing or when S_STD is called.
> > >> -	 */
> > >> -	if (vin->format.field == V4L2_FIELD_ALTERNATE &&
> > >> -	    v4l2_subdev_has_op(vin_to_source(vin), video, g_std))
> > >> -		vin->format.field = V4L2_FIELD_INTERLACED;
> > >> -
> > >> -	switch (vin->format.field) {
> > >> -	case V4L2_FIELD_TOP:
> > >> -	case V4L2_FIELD_BOTTOM:
> > >> -	case V4L2_FIELD_ALTERNATE:
> > >> -		vin->format.height /= 2;
> > >> -		break;
> > >> -	case V4L2_FIELD_NONE:
> > >> -	case V4L2_FIELD_INTERLACED_TB:
> > >> -	case V4L2_FIELD_INTERLACED_BT:
> > >> -	case V4L2_FIELD_INTERLACED:
> > >> -		break;
> > >> -	default:
> > >> -		vin->format.field = V4L2_FIELD_NONE;
> > >> -		break;
> > >> -	}
> > >> -
> > >>  	ret = rvin_reset_crop_compose(vin);
> > >>  	if (ret)
> > >>  		return ret;
> > >> @@ -243,12 +238,10 @@ static int __rvin_try_format(struct rvin_dev *vin,
> > >>  	if (ret)
> > >>  		return ret;
> > >> 
> > >> +	/* Reject ALTERNATE  until support is added to the driver */
> > >>  	switch (pix->field) {
> > >>  	case V4L2_FIELD_TOP:
> > >>  	case V4L2_FIELD_BOTTOM:
> > >> -	case V4L2_FIELD_ALTERNATE:
> > >> -		pix->height /= 2;
> > >> -		break;
> > >>  	case V4L2_FIELD_NONE:
> > >>  	case V4L2_FIELD_INTERLACED_TB:
> > >>  	case V4L2_FIELD_INTERLACED_BT:
> > > 
> > > You will then set the field to V4L2_FIELD_NONE, but the source will still
> > > provide V4L2_FIELD_ALTERNATE. What will happen in the VIN, what will it
> > > produce ?
> > 
> > As stated above this is just the format produced from the VIN to
> > user-space. The source field is validated at s_stream() time, if it is
> > V4L2_FIELD_ALTERNATE the driver will handle it and possibly interlace it
> > depending on how the user wants to consume it, which is what is
> > specified here.
> 
> That was clearer when I read the patch that implemented .start_streaming() 
> support for the MC mode. Defaulting to V4L2_FIELD_NONE seems fine to me.
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
