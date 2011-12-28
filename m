Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:50947 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab1L1KUc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Dec 2011 05:20:32 -0500
Date: Wed, 28 Dec 2011 12:20:28 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 0/2] Support additional DPCM compressed formats
Message-ID: <20111228102028.GR3677@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This small patchset adds support for the other three 10-to-8 bit
DPCM-compressed formats as well as prevent accessing NULL pointers in the
omap3isp driver.

The issue was that there was no corresponding in-memory format for the media
bus formats on the CSI-2 receiver but the CSI-2 receiver driver still
allowed such format on its source pad. Alternatively this could be fixed by
preventing using such formats, but I can't see a reason to do so.

That said, the additional formats on the OMAP 3 ISP driver are untested.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
