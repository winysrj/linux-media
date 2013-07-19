Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44864 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760927Ab3GSRtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 13:49:49 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 6BAF960095
	for <linux-media@vger.kernel.org>; Fri, 19 Jul 2013 20:49:46 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [RFC 0/4] Add MEDIA_PAD_FL_MUST_CONNECT pad flag, check it
Date: Fri, 19 Jul 2013 20:55:05 +0300
Message-Id: <1374256509-7850-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is a small RFC patchset which adds a new pad flag
MEDIA_PAD_FL_MUST_CONNECT. Pads that have this flag are required to be
connected through an enabled link for the entity to be able to stream. Both
sink and source pads may have this flag, compared to my old patch which
required all sink pads to be connected.

One of the additional benefits is that the users will also know which pads
must be connected which is better than the ah-so-informative -EPIPE. More
complex cases are still left for the driver to implement, though.

The omap3isp driver gets these flags to all of its sink pads. Other drivers
would likely need to be changed by the driver authors since I have little
knowledge of their requirements.

Consequently, an additional loop over the media graph can be avoided in the
omap3isp driver (4th patch) since the driver no longer has the
responsibility to check that its pads are connected.

-- 
Kind regards,
Sakari

