Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60558 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750848AbaEAJML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 1 May 2014 05:12:11 -0400
Date: Thu, 1 May 2014 10:11:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrzej Hajda <andrzej.hajda@wp.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	open list <linux-kernel@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	David Airlie <airlied@linux.ie>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Figa <t.figa@samsung.com>,
	Tomasz Stansislawski <t.stanislaws@samsung.com>,
	"moderated list:ARM/S5P EXYNOS AR..."
	<linux-samsung-soc@vger.kernel.org>,
	"moderated list:ARM/S5P EXYNOS AR..."
	<linux-arm-kernel@lists.infradead.org>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH 0/4] drivers/base: Generic framework for tracking
	internal interfaces
Message-ID: <20140501091102.GF26756@n2100.arm.linux.org.uk>
References: <1398866574-27001-1-git-send-email-a.hajda@samsung.com> <20140430154914.GA898@kroah.com> <53616E31.3050404@wp.pl> <20140430222839.GE26756@n2100.arm.linux.org.uk> <5361F1F3.7070005@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5361F1F3.7070005@wp.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 01, 2014 at 09:04:19AM +0200, Andrzej Hajda wrote:
> 2. You replace calls of component_add and component_del with calls
> to interface_tracker_ifup(dev, INTERFACE_TRACKER_TYPE_COMPONENT,  
> &specific_component_ops),
> or interface_tracker_ifdown.
> Thats all for components.

How does the master get to decide which components are for it?  As
I see it, all masters see all components of a particular "type".
What if you have a system with two masters each of which are bound
to a set of unique components but some of the components are of a
the same type?

How does the master know what "type" to use?

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
