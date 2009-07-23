Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:47174 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbZGWN4t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 09:56:49 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n6NDtYqb028040
	for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 08:56:39 -0500
From: tuukka.o.toivonen@nokia.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com,
	tuukka.o.toivonen@nokia.com
Subject: Do not restrict image buffer allocation to multiple of PAGE_SIZE
Date: Thu, 23 Jul 2009 16:56:24 +0300
Message-Id: <1248357387-14720-1-git-send-email-tuukka.o.toivonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset removes the constraint which enforced image buffer
size to be multiple of PAGE_SIZE. It improves efficiency by allowing
storing images directly to Ximage buffers removing the need to copy
image data.

It is tested with mmap and userptr methods, changes to V4L1
compatibility layer are not tested.

The first patch applies directly to the V4L2 framework, rest of the
patches make the necessary modifications also to omap34xxcam and
OMAP3 ISP drivers and require those first to be included.


