Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44812 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751844AbbCPACH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 20:02:07 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, sre@kernel.org, pali.rohar@gmail.com,
	laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: [PATCH 0/4] OMAP 3 ISP (and N9/N950 primary camera support) dts changes
Date: Mon, 16 Mar 2015 02:01:16 +0200
Message-Id: <1426464080-29119-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tony and others,

I had a couple of patches that contained dts changes in my OMAP 3 ISP / N9
camera DT support set. Since it became apparent that at least some of the
changes should go through linux-omap due to potential conflicts with other
patches, I decided to separate the dts changes from the set that could go
through the linux-omap tree. Here they are.

There's also the OMAP 3 ISP DT binding change, including a corresponding
header file that's included for human-readable names for the PHY types.

There are no dependencies between the sets, other than the obvious one that
omap3isp DT support won't work unless both are applied. The original thread
can be found here:

<URL:http://www.spinics.net/lists/linux-media/msg87263.html>

What's changed since the RFC set in the domain of these patches, there are
lots of changes elsewhere as well:

- syscon register range extension as a separate patchset,

- Fixed OMAP 3 ISP DT binding documentation according to Laurent's comments.
  Especially the PHY types have now human-readable names that refer to the
  PHY names in the documentation.

- The isp nodes are called isp rather than omap3_isp.

-- 
Kind regards,
Sakari

