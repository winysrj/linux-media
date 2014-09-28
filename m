Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49956 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751312AbaI1WW0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 18:22:26 -0400
Date: Mon, 29 Sep 2014 01:13:41 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: omap3isp Device Tree support status
Message-ID: <20140928221341.GQ2939@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I managed to find some time for debugging my original omap3isp DT support
patchset (which includes smiapp DT support as well), and found a few small
but important bugs.

The status is now that images can be captured using the Nokia N9 camera, in
which the sensor is connected to the CSI-2 interface. Laurent confirmed that
the parallel interface worked for him (Beagleboard, mt9p031 sensor on
Leopard imaging's li-5m03 board).

These patches (on top of the smiapp patches I recently sent for review which
are in much better shape) are still experimental and not ready for review. I
continue to clean them up and post them to the list when that is done. For
now they can be found here:

<URL:http://git.linuxtv.org/cgit.cgi/sailus/media_tree.git/log/?h=rm696-043-dt>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
