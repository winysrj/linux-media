Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:56362 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab1F2Oav (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 10:30:51 -0400
Message-ID: <4E0B3718.1030202@matrix-vision.de>
Date: Wed, 29 Jun 2011 16:30:48 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: auto-loading omap3-isp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I am trying to get omap3-isp.ko to be loaded upon bootup.  The problem
is that iommu2.ko needs to be loaded first, which can't just be compiled
into the kernel.  Udev will see '/sys/devices/platform/omap3isp' and
load omap3-isp.ko, which fails because iommu2.ko hasn't been loaded yet.
 iommu2 doesn't have a counterpart in /sys/devices/, so I don't know how
to get udev to load it first.

I can think of a few ways to accomplish this, but they all amount to
hacking the init sequence (e.g. the udev init script).  I'm looking for
a better way.

How are others doing this?

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
