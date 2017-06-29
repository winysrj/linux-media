Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55336 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751333AbdF2Xxh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 19:53:37 -0400
Date: Fri, 30 Jun 2017 02:53:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 04/19] media: camss: Add CSIPHY files
Message-ID: <20170629235332.m6ru4uxvdt6bmsod@valkosipuli.retiisi.org.uk>
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
 <1497883719-12410-5-git-send-email-todor.tomov@linaro.org>
 <20170628213433.7ehkz62rw75t4yxa@valkosipuli.retiisi.org.uk>
 <4b28ce1a-84af-858b-50d1-79fb3e461387@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b28ce1a-84af-858b-50d1-79fb3e461387@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Thu, Jun 29, 2017 at 07:36:47PM +0300, Todor Tomov wrote:
> >> +/*
> >> + * csiphy_link_setup - Setup CSIPHY connections
> >> + * @entity: Pointer to media entity structure
> >> + * @local: Pointer to local pad
> >> + * @remote: Pointer to remote pad
> >> + * @flags: Link flags
> >> + *
> >> + * Rreturn 0 on success
> >> + */
> >> +static int csiphy_link_setup(struct media_entity *entity,
> >> +			     const struct media_pad *local,
> >> +			     const struct media_pad *remote, u32 flags)
> >> +{
> >> +	if ((local->flags & MEDIA_PAD_FL_SOURCE) &&
> >> +	    (flags & MEDIA_LNK_FL_ENABLED)) {
> >> +		struct v4l2_subdev *sd;
> >> +		struct csiphy_device *csiphy;
> >> +		struct csid_device *csid;
> >> +
> >> +		if (media_entity_remote_pad((struct media_pad *)local))
> > 
> > This is ugly.
> > 
> > What do you intend to find with media_entity_remote_pad()? The pad flags
> > haven't been assigned to the pad yet, so media_entity_remote_pad() could
> > give you something else than remote.
> 
> This is an attempt to check whether the pad is already linked - to refuse
> a second active connection from the same src pad. As far as I can say, it
> was a successful attempt. Do you see any problem with it?

Ah. So you have multiple links here only one of which may be active?

I guess you can well use media_entity_remote_pad(), but then
media_entity_remote_pad() argument needs to be made const. Feel free to
spin a patch. I don't think it'd have further implications elsewhere.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
