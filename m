Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([87.118.82.44]:59945 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878AbaD3JEQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Apr 2014 05:04:16 -0400
Date: Wed, 30 Apr 2014 11:04:14 +0200 (CEST)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH] omap3isp: Make isp_register_entities() fail when sensor
 registration fails
In-Reply-To: <20140430083830.GR8753@valkosipuli.retiisi.org.uk>
Message-ID: <alpine.DEB.2.01.1404301052560.3218@pmeerw.net>
References: <1398845671-12989-1-git-send-email-pmeerw@pmeerw.net> <20140430083830.GR8753@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> On Wed, Apr 30, 2014 at 10:14:31AM +0200, Peter Meerwald wrote:
> > isp_register_entities() ignores registration failure of the sensor,
> > /dev/video* devices are created nevertheless
> > 
> > if the sensor fails, all entities should not be created

> Why? In some cases it'd be nice to be able to use the devices that actually
> are available. This certainly isn't something that should cause probe to
> fail IMHO.

I see your point; e.g the ISP resizer could be used without a sensor

anyway, I can figure out later-on from the device topology that no sensor 
is present

thanks, p.

-- 

Peter Meerwald
+43-664-2444418 (mobile)
