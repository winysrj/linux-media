Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62387 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab1CIJRm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 04:17:42 -0500
From: David Cohen <dacohen@gmail.com>
To: Hiroshi.DOYU@nokia.com
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, fernando.lugo@ti.com,
	David Cohen <dacohen@gmail.com>
Subject: [PATCH v3 0/2] omap: iovmm: Fix IOVMM check for fixed 'da'
Date: Wed,  9 Mar 2011 11:17:31 +0200
Message-Id: <1299662253-29817-1-git-send-email-dacohen@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Previous patch 2/3 was dropped in this new version. Patch 1 was updated
according to a comment it got.

---
IOVMM driver checks input 'da == 0' when mapping address to determine whether
user wants fixed 'da' or not. At the same time, it doesn't disallow address
0x0 to be used, what creates an ambiguous situation. This patch set moves
fixed 'da' check to the input flags.

Br,

David Cohen
---

David Cohen (1):
  omap: iovmm: don't check 'da' to set IOVMF_DA_FIXED flag

Michael Jones (1):
  omap: iovmm: disallow mapping NULL address when IOVMF_DA_ANON is set

 arch/arm/plat-omap/include/plat/iovmm.h |    2 --
 arch/arm/plat-omap/iovmm.c              |   27 ++++++++++++---------------
 2 files changed, 12 insertions(+), 17 deletions(-)

-- 
1.7.4.1

