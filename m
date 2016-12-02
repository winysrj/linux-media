Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33376 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933938AbcLBOwa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 09:52:30 -0500
Date: Fri, 2 Dec 2016 16:52:12 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, mchehab@osg.samsung.com,
        shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC v4 19/21] omap3isp: Allocate the media device dynamically
Message-ID: <20161202145212.GU16630@valkosipuli.retiisi.org.uk>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
 <1478613330-24691-19-git-send-email-sakari.ailus@linux.intel.com>
 <99e22b20-12fd-1343-e682-c1fa0c79f074@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99e22b20-12fd-1343-e682-c1fa0c79f074@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Nov 22, 2016 at 11:05:49AM +0100, Hans Verkuil wrote:
...
> >@@ -2183,7 +2185,7 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
> > 	if (ret < 0)
> > 		return ret;
> >
> >-	return media_device_register(&isp->media_dev);
> >+	return media_device_register(isp->media_dev);
> 
> I wonder if this is correct. Usually if the register fails, then the
> release/delete function
> has to be called explicitly. That doesn't happen here.

This patch is really about making the media_dev a pointer in struct
omap3isp_device. Currently the cleanup takes place when the device is
unbound. That's perhaps not ideal but on the other hand optimising error
handling is often just not worth it.

Improvements could be done how the async framework handles errors but that
shouldn't be in the scope of this patchset.

> 
> E.g. from adv7604.c:
> 
> static int adv76xx_registered(struct v4l2_subdev *sd)
> {
>         struct adv76xx_state *state = to_state(sd);
>         int err;
> 
>         err = cec_register_adapter(state->cec_adap);
>         if (err)
>                 cec_delete_adapter(state->cec_adap);
>         return err;
> }

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
