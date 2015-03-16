Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45048 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751027AbbCPA05 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 20:26:57 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
	pali.rohar@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 00/15] omap3isp driver DT support
Date: Mon, 16 Mar 2015 02:25:55 +0200
Message-Id: <1426465570-30295-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

Here's the first non-RFC version of the omap3isp driver DT support patchset.
It's a sub-set of patches in this RFC set:

<URL:http://www.spinics.net/lists/linux-media/msg87263.html>

What has been changed since the RFC set in these patches is roughly:

- The patches have been rebased on Laurent's hist DMA patch:

  <URL:http://www.spinics.net/lists/linux-media/msg87349.html>

- the dts changes have been split off as a separate set "[PATCH 0/4] OMAP 3
  ISP (and N9/N950 primary camera support) dts changes". This includes the
  OMAP 3 ISP DT binding patch. There are no direct dependencies to this set.

- Use unsigned int rather than int in loop over an array in v4l2-of.c.

- Check that there at least as as many lane polarities as there are lanes.

- Fixed syscon handling for non-DT case.

-- 
Kind regards,
Sakari


