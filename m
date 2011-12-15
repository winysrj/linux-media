Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:39333 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758373Ab1LOJuY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 04:50:24 -0500
Date: Thu, 15 Dec 2011 11:50:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [RFC 0/4] OMAP 3 ISP driver improvements
Message-ID: <20111215095015.GC3677@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patchset removes two of the three callbacks in the OMAP 3 ISP driver's
board code.

It is dependent on first and third patch in the "[RFC] On controlling
sensors" patchset:

<URL:http://www.spinics.net/lists/linux-media/msg40861.html>

What will be left is the external clock, which should be moved to use the
generic clock framework in the future. The dependency indeed is the generic
clock framework --- on OMAP 3 the clock is provided by the ISP, so accessing
it through the clock framework isn't possible at the moment. Once we have
that, the ISP should register the xclk to the clock framework and the sensor
driver would use if from there. Then I see no issues in moving to the device
tree.

Also, controlling the CSI-2 receiver in the OMAP 3630 properly is now
possible with this patchset.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
