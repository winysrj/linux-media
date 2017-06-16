Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41178 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752619AbdFPMAd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 08:00:33 -0400
Date: Fri, 16 Jun 2017 14:59:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pavel Machek <pavel@ucw.cz>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: fix compilation
Message-ID: <20170616115959.GP12407@valkosipuli.retiisi.org.uk>
References: <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
 <20170306072323.GA23509@amd>
 <20170310225418.GJ3220@valkosipuli.retiisi.org.uk>
 <20170613122240.GA2803@amd>
 <20170613124748.GD12407@valkosipuli.retiisi.org.uk>
 <20170613210900.GA31456@amd>
 <20170614110634.GP12407@valkosipuli.retiisi.org.uk>
 <20170615222302.GB20714@amd>
 <a9582fc4-408e-3956-d609-8e7abb28f41b@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9582fc4-408e-3956-d609-8e7abb28f41b@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 16, 2017 at 10:03:41AM +0200, Hans Verkuil wrote:
> On 06/16/2017 12:23 AM, Pavel Machek wrote:
> >
> >Fix compilation of isp.c
> >Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >
> >diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> >index 4ca3fc9..b80debf 100644
> >--- a/drivers/media/platform/omap3isp/isp.c
> >+++ b/drivers/media/platform/omap3isp/isp.c
> >@@ -2026,7 +2026,7 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
> >  	isd->bus = buscfg;
> >-	ret = v4l2_fwnode_endpoint_parse(fwn, vep);
> >+	ret = v4l2_fwnode_endpoint_parse(fwnode, &vep);
> >  	if (ret)
> >  		return ret;
> >
> 
> You're using something old since the media tree master already uses &vep.

Well, yes and no. Pavel is using my ccp2 support branch I recently rebased.
:-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
