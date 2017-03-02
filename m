Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50876 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754083AbdCBSQ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Mar 2017 13:16:57 -0500
Date: Thu, 2 Mar 2017 17:13:21 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: subdevice config into pointer (was Re: [PATCH 1/4] v4l2:
 device_register_subdev_nodes: allow calling multiple times)
Message-ID: <20170302151321.GH3220@valkosipuli.retiisi.org.uk>
References: <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225000918.GB23662@amd>
 <20170225134444.6qzumpvasaow5qoj@ihha.localdomain>
 <20170302090727.GC27818@amd>
 <20170302141617.GG3220@valkosipuli.retiisi.org.uk>
 <20170302145808.GA3315@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170302145808.GA3315@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Thu, Mar 02, 2017 at 03:58:08PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > Making the sub-device bus configuration a pointer should be in a separate
> > > > patch. It makes sense since the entire configuration is not valid for all
> > > > sub-devices attached to the ISP anymore. I think it originally was a
> > > > separate patch, but they probably have been merged at some point. I can't
> > > > find it right now anyway.
> > > 
> > > Something like this?
> > > 
> > > commit df9141c66678b549fac9d143bd55ed0b242cf36e
> > > Author: Pavel <pavel@ucw.cz>
> > > Date:   Wed Mar 1 13:27:56 2017 +0100
> > > 
> > >     Turn bus in struct isp_async_subdev into pointer; some of our subdevs
> > >     (flash, focus) will not need bus configuration.
> > > 
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > I applied this to the ccp2 branch with an improved patch
> > description.
> 
> Thanks!
> 
> [But the important part is to get subdevices to work on ccp2 based
> branch, and it still fails to work at all if I attempt to enable
> them. I'd like to understand why...]

Did you add the flash / lens to the async list? The patches currently in the
ccp branch do not include that --- it should be in parsing the flash /
lens-focus properties in omap3isp device's node.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
