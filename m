Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51694 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1759968AbcLPNdb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 08:33:31 -0500
Date: Fri, 16 Dec 2016 15:32:55 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, shuahkh@osg.samsung.com
Subject: Re: [RFC v3 21/21] omap3isp: Don't rely on devm for memory resource
 management
Message-ID: <20161216133254.GJ16630@valkosipuli.retiisi.org.uk>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
 <1472255009-28719-22-git-send-email-sakari.ailus@linux.intel.com>
 <1551037.Hfmqsgr3In@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551037.Hfmqsgr3In@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Dec 15, 2016 at 01:23:50PM +0200, Laurent Pinchart wrote:
> > @@ -1596,7 +1604,6 @@ static void isp_unregister_entities(struct isp_device
> > *isp) omap3isp_stat_unregister_entities(&isp->isp_af);
> >  	omap3isp_stat_unregister_entities(&isp->isp_hist);
> > 
> > -	v4l2_device_unregister(&isp->v4l2_dev);
> 
> This isn't correct. The v4l2_device instance should be unregistered here, to 
> make sure that the subdev nodes are unregistered too. And even if moving the 
> function call was correct, it should be done in a separate patch as it's 
> unrelated to $SUBJECT.

I think I tried to fix another problem here we haven't considered before,
which is that v4l2_device_unregister() also unregisters the entities through
media_device_unregister_entity(). This will set the media device of the
graph objects NULL.

I'll see whether something could be done to that.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
