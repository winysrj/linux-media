Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56667 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932108AbbCPXWT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 19:22:19 -0400
Date: Tue, 17 Mar 2015 01:21:46 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com
Subject: Re: [RFC 10/18] omap3isp: Move the syscon register out of the ISP
 register maps
Message-ID: <20150316232146.GF11954@valkosipuli.retiisi.org.uk>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
 <1425764475-27691-11-git-send-email-sakari.ailus@iki.fi>
 <5344778.cfsY6SCB4g@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5344778.cfsY6SCB4g@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 16, 2015 at 02:19:04AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Saturday 07 March 2015 23:41:07 Sakari Ailus wrote:
> > The syscon register isn't part of the ISP, use it through the syscom driver
> > regmap instead. The syscom block is considered to be from 343x on ISP
> > revision 2.0 whereas 15.0 is assumed to have 3630 syscon.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  arch/arm/boot/dts/omap3.dtsi                |    2 +-
> >  arch/arm/mach-omap2/devices.c               |   10 ----------
> >  drivers/media/platform/omap3isp/isp.c       |   19 +++++++++++++++----
> >  drivers/media/platform/omap3isp/isp.h       |   19 +++++++++++++++++--
> >  drivers/media/platform/omap3isp/ispcsiphy.c |   20 +++++++++-----------
> 
> I've noticed another issue, you need a "select MFD_SYSCON" in Kconfig.

Thanks, fixed!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
