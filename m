Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48252 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751116Ab2IZVuF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 17:50:05 -0400
Date: Thu, 27 Sep 2012 00:50:01 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: paul@pwsan.com, laurent.pinchart@ideasonboard.com,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH v2 0/2] OMAP 3 CSI-2 configuration
Message-ID: <20120926215001.GA14107@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paul and Laurent,

This is an update to an old patchset for CSI-2 configuration for OMAP 3430
and 3630, and the corresponding patch to the ISP driver. Both have been
tested on the 3630 only so far.

Additional patches for the N9(50) camera support that mostly aren't yet
upstreamable, are available in rm696-016/002-devel branch here:

<URL:https://git.gitorious.org/omap3camera/mainline.git>

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
