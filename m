Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42050 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751345AbdIEOxk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Sep 2017 10:53:40 -0400
Date: Tue, 5 Sep 2017 17:53:37 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [PATCH v7 01/18] v4l: fwnode: Move KernelDoc documentation to
 the header
Message-ID: <20170905145337.h6qy42k3hv6ha73y@valkosipuli.retiisi.org.uk>
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
 <20170903174958.27058-2-sakari.ailus@linux.intel.com>
 <20170904154940.GA19484@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170904154940.GA19484@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 04, 2017 at 05:49:40PM +0200, Pavel Machek wrote:
> On Sun 2017-09-03 20:49:41, Sakari Ailus wrote:
> > In V4L2 the practice is to have the KernelDoc documentation in the header
> > and not in .c source code files. This consequientally makes the V4L2
> 
> consequientally: spelling?
> 
> > fwnode function documentation part of the Media documentation build.
> > 
> > Also correct the link related function and argument naming in
> > documentation.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> Something funny going on with utf-8 here.
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>

Thanks! Will fix for v9.

I had bad commit message encoding in .gitconfig, that's now fixed.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
