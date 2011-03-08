Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55383 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab1CHMqP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 07:46:15 -0500
From: David Cohen <dacohen@gmail.com>
To: Hiroshi.DOYU@nokia.com
Cc: linux-omap@vger.kernel.org, fernando.lugo@ti.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com,
	David Cohen <dacohen@gmail.com>
Subject: [PATCH 0/3] omap: iovmm: Fix IOVMM check for fixed 'da'
Date: Tue,  8 Mar 2011 14:46:02 +0200
Message-Id: <1299588365-2749-1-git-send-email-dacohen@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

IOVMM driver checks input 'da == 0' when mapping address to determine whether
user wants fixed 'da' or not. At the same time, it doesn't disallow address
0x0 to be used, what creates an ambiguous situation. This patch set moves
fixed 'da' check to the input flags.
It also fixes da_start value for ISP IOMMU instance.

David Cohen (2):
  omap3: change ISP's IOMMU da_start address
  omap: iovmm: don't check 'da' to set IOVMF_DA_FIXED/IOVMF_DA_ANON
    flags

Michael Jones (1):
  omap: iovmm: disallow mapping NULL address

 arch/arm/mach-omap2/omap-iommu.c |    2 +-
 arch/arm/plat-omap/iovmm.c       |   28 ++++++++++++++++++----------
 2 files changed, 19 insertions(+), 11 deletions(-)

