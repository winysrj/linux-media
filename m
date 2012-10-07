Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51751 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752870Ab2JGUHf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Oct 2012 16:07:35 -0400
Date: Sun, 7 Oct 2012 23:07:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, tony@atomide.com
Subject: [PATCH v3 0/3] OMAP 3 CSI-2 configuration
Message-ID: <20121007200730.GD14107@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is an update to an old patchset for CSI-2 configuration for OMAP 3430
and 3630r. The patches have been tested on the 3630 only so far, and I don't
plan to test them on 3430 in the near future.

I changed quite a few things after a discussion with Tony a few days ago.
The ISP driver now maps the relevant register from the control block and
uses it directly. Which register is required is determined by the ISP
revision: this is theoretically wrong, but since we only support OMAP 3430
and 3630 which have different ISPs it should be all right. If we need to
support more OMAPs in the future we could revisit how that's being
determined.

Comments, questions and other kind of feedback is very welcome.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
