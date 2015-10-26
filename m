Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44994 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751751AbbJZXDu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 19:03:50 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [PATCH 00/19] Unrestricted media entity ID range support
Date: Tue, 27 Oct 2015 01:01:31 +0200
Message-Id: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is an update to my previous RFC patchset here:

<URL:http://www.spinics.net/lists/linux-media/msg93481.html>

In addition to the problems the patchset previously resolved and features
it implemented:

- unrestricted media entity ID support and
- API to manage entity enumerations

this set now solves one additional problem:

- unrestricted number of media entities.

The set also paves way to dynamic media entity registration but does not
implement it yet. In a completely dynamic system there's a lot more
mandatory error handling and difficult corner cases that one has to deal
with. There are cases where entity enumeration or graph walk may not fail
such as stopping streaming or power count calculation in link
enabling/disabling. This can be resolved by allocating entity enumerations
at a safe time and keeping them around until when they're needed and
releasing when they're no longer needed.

Keeping around entity enumerations together with dynamic entity
enumeration allocation brings up another problem: how do you ensure an
entity enumeration is large enough for all the entities that can be
encountered?

These additional problems are left for the future. This set does not
intend to address them.

The set has been tested with the omap3isp driver while the exynos4-is,
xilinx, vsp1 and omap4iss driver have been compile tested only. I'd
appreciate if others who have access to the hardware tested them.

What's changed is that the media entity enumerations are now dynamically
allocated if the number of entities in an enumeration exceeds a certain
constant value (which is now 64). The implication is that now error
handling is mandatory in entity enum initialisation (and thus graph walk
as well) as memory allocation may fail. Enumerations are allocated and
re-used in a few occasions in file handle open/close and pipeline
start/stop in order to guarantee successful graph walk, for instance.

The set also contains a fix for the omap4iss power management code. I kept
it in the set since another omap4iss driver patch depends on it.

Reviews would be very welcome.

-- 
Kind regards,
Sakari
