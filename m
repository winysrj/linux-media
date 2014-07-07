Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:46518 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751120AbaGGQiE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jul 2014 12:38:04 -0400
From: Ian Molton <ian.molton@codethink.co.uk>
To: linux-media@vger.kernel.org
Cc: linux-kernel@lists.codethink.co.uk, ian.molton@codethink.co.uk,
	g.liakhovetski@gmx.de, m.chehab@samsung.com
Subject: [PATCH 0/4] rcar_vin: fix soc_camera WARN_ON() issues.
Date: Mon,  7 Jul 2014 17:37:45 +0100
Message-Id: <1404751069-5666-1-git-send-email-ian.molton@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series provides fixes that allow the rcar_vin driver to function
without triggering dozens of warnings from the videobuf2 and soc_camera layers.

Patches 2/3 should probably be merged into a single, atomic change, although
patch 2 does not make the existing situation /worse/ in and of itself.

Patch 4 does not change the code logic, but is cleaner and less prone to
breakage caused by furtutre modification. Also, more consistent with the use of
vb pointers elsewhere in the driver.

Comments welcome!

-Ian

