Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54280 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752181Ab2JNKb1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Oct 2012 06:31:27 -0400
Date: Sun, 14 Oct 2012 13:31:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, tony@atomide.com,
	khilman@deeprootsystems.com
Subject: [PATCH v5 0/3] OMAP 3 CSI-2 configuration
Message-ID: <20121014103122.GA21261@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is an update to an old patchset for CSI-2 configuration for OMAP 3430
and 3630. The patches have been tested on the 3630 only so far, and I don't
plan to test them on 3430 in the near future.

I've made changes according to Laurent's suggestions to the patches, with
the exception of alignment of a certain line. I think it's exactly as it
should be. :-)

I'm not quite certain about the comment regarding the control register state
dependency to the CORE power domain, and why exactly this isn't an issue. We
know the MPU must stay powered since the ISP can't wake up MPU, but how is
this related to CORE? In the end it seems to work.

If you think this should be changed and you also know how, please provide me
the text. :-)

	/*
	 * The PHY configuration is lost in off mode, that's not an
	 * issue since the MPU power domain is forced on whilst the
	 * ISP is in use.
	 */

Comments, questions and other kind of feedback is very welcome.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
