Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38809 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751286AbbCTQ5N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 12:57:13 -0400
Date: Fri, 20 Mar 2015 18:57:06 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, sre@kernel.org, pali.rohar@gmail.com,
	laurent.pinchart@ideasonboard.com, t-kristo@ti.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 0/3] OMAP 3 ISP (and N9/N950 primary camera support)
 dts changes
Message-ID: <20150320165706.GA16613@valkosipuli.retiisi.org.uk>
References: <1426722625-4132-1-git-send-email-sakari.ailus@iki.fi>
 <20150319172843.GH31346@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150319172843.GH31346@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 19, 2015 at 10:28:44AM -0700, Tony Lindgren wrote:
> * Sakari Ailus <sakari.ailus@iki.fi> [150318 16:51]:
> > Hi folks,
> > 
> > Since v1, I've rebased the set on Tero Kristo's PRCM / SCM cleanup patchset
> > here:
> > 
> > <URL:http://www.spinics.net/lists/linux-omap/msg116949.html>
> > 
> > v1 can be found here:
> > 
> > <URL:http://www.spinics.net/lists/linux-omap/msg116753.html>
> > 
> > Changes since v1:
> > 
> > - Fixed phy reference (number to name) in the example,
> > 
> > - Dropped the first patch. This is already done by Tero's patch "ARM: dts:
> >   omap3: merge control module features under scrm node".
> 
> Applying these into omap-for-v4.1/dt thanks.

Thank you! These patches had been around in some form for way too long
already. It's great to see them going in finally! :-)

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
