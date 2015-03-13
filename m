Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:37001 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbbCMQsz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 12:48:55 -0400
Date: Fri, 13 Mar 2015 09:43:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, pali.rohar@gmail.com
Subject: Re: [RFC 18/18] omap3isp: Deprecate platform data support
Message-ID: <20150313164355.GW5140@atomide.com>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
 <1425764475-27691-19-git-send-email-sakari.ailus@iki.fi>
 <20150313094050.GB4980@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150313094050.GB4980@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Sebastian Reichel <sre@kernel.org> [150313 02:41]:
> Hi,
> 
> [+CC Tony]
> 
> On Sat, Mar 07, 2015 at 11:41:15PM +0200, Sakari Ailus wrote:
> > Print a warning when the driver is used with platform data. Existing
> > platform data user should move to DT now.
> 
> I guess this should become a more visible warning on OMAP SoC level,
> since platform data based boot will be deprecated completly.

Yeah. We should need platform data in addition to device tree data in
only very few cases. Basically only when there's some arch specific
callback function that needs to be passed to the driver.

Regards,

Tony
