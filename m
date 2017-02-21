Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51814 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751266AbdBULLm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 06:11:42 -0500
Date: Tue, 21 Feb 2017 13:11:04 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [PATCH 1/4] v4l2: device_register_subdev_nodes: allow calling
 multiple times
Message-ID: <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
 <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170221110721.GD5021@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 21, 2017 at 12:07:21PM +0100, Pavel Machek wrote:
> On Mon 2017-02-20 15:56:36, Sakari Ailus wrote:
> > On Mon, Feb 20, 2017 at 03:09:13PM +0200, Sakari Ailus wrote:
> > > I've tested ACPI, will test DT soon...
> > 
> > DT case works, too (Nokia N9).
> 
> Hmm. Good to know. Now to figure out how to get N900 case to work...
> 
> AFAICT N9 has CSI2, not CSI1 support, right? Some of the core changes
> seem to be in, so I'll need to figure out which, and will still need
> omap3isp modifications...

Indeed, I've only tested for CSI-2 as I have no functional CSI-1 devices.

It's essentially the functionality in the four patches. The data-lane and
clock-name properties have been renamed as data-lanes and clock-lanes (i.e.
plural) to match the property documentation.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
