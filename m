Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33302 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751884AbbCGVmP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2015 16:42:15 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, pali.rohar@gmail.com
Subject: [RFC 00/18] Device tree support for omap3isp, N9[50] primary camera
Date: Sat,  7 Mar 2015 23:40:57 +0200
Message-Id: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

I've had this patchset hanging around for a long, long time, and now it's
time to send it out to linux-media.

For OMAP 3, first there are a few patches for random and tiny bugfixes and
then preparation for DT support (including compile tested rework of cm-t35
board code).

The lane-polarity DT binding is added to video-interfaces.txt for this, I
believe, is hardly specific to the OMAP 3 ISP. The same property is read by
the V4L2 OF parser as well.

ISP DT support is added for both OMAP 34xx and 36xx, but it remains tested
on 3630 only. The primary camera support is added for both N950 and N9, the
latter of which is tested. The differences are quite small between the two
in both of the cases, but still testing definitely wouldn't hurt.

The secondary camera support is still lacking primarily due to the I2C
address conflict: both of the cameras have the same I2C address. It'd also
require CCP2 bus support, which is relatively trivial to add.

Effects of Philipp Zabel's patch "of: Decrement refcount of previous
endpoint in of_graph_get_next_endpoint" aren't yet taken into account in
this series. I'll address this in the next set if changes (small I presume)
are needed.

-- 
Kind regards,
Sakari

