Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:33825 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524AbcAHXFx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2016 18:05:53 -0500
Received: by mail-pf0-f181.google.com with SMTP id q63so16228583pfb.1
        for <linux-media@vger.kernel.org>; Fri, 08 Jan 2016 15:05:53 -0800 (PST)
From: Douglas Anderson <dianders@chromium.org>
To: Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pawel Osciak <pawel@osciak.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Douglas Anderson <dianders@chromium.org>, k.debski@samsung.com,
	laurent.pinchart+renesas@ideasonboard.com,
	linux-kernel@vger.kernel.org, corbet@lwn.net,
	mike.looijmans@topic.nl, lorenx4@gmail.com,
	linux-doc@vger.kernel.org, will.deacon@arm.com,
	jtp.park@samsung.com, kyungmin.park@samsung.com, carlo@caione.org,
	akpm@linux-foundation.org, linux-media@vger.kernel.org,
	dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 0/5] dma-mapping: Patches for speeding up allocation
Date: Fri,  8 Jan 2016 15:05:27 -0800
Message-Id: <1452294332-23415-1-git-send-email-dianders@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series of patches will speed up memory allocation in dma-mapping
quite a bit.

The first patch ("ARM: dma-mapping: Optimize allocation") is hopefully
not terribly controversial: it merely doesn't try as hard to allocate
big chunks once it gets the first failure.  Since it's unlikely that
further big chunks will help (they're not likely to be virtually aligned
anyway), this should give a big speedup with no real regression to speak
of.  Yes, things could be made better, but this seems like a sane start.

The second patch ("common: DMA-mapping: add DMA_ATTR_NO_HUGE_PAGE
attribute") models MADV_NOHUGEPAGE as I understand it.  Hopefully folks
are happy with following that lead.  It does nothing by itself.

The third patch ("ARM: dma-mapping: Use DMA_ATTR_NO_HUGE_PAGE hint to
optimize allocation") simply applies the 2nd patch.  Again it's pretty
simple.  ...and again it does nothing by itself.

Thue fourth patch ("[media] videobuf2-dc: Let drivers specify DMA
attrs") comes from the ChromeOS tree (authored by Tomasz Figa) and
allows the fifth patch.

The fifth patch ("[media] s5p-mfc: Set DMA_ATTR_NO_HUGE_PAGE") uses the
new attribute.  For a second user, you can see the out of tree patch for
rk3288 at <https://chromium-review.googlesource.com/#/c/320498/>.

All testing was done on the chromeos kernel-3.8 and kernel-3.14.
Sanity (compile / boot) testing was done on a v4.4-rc6-based kernel on
rk3288, though the video codec isn't there.  I don't have graphics / MFC
working well on exynos, so the MFC change was only compile-tested
upstream.  Hopefully someone upstream whose setup for MFC can give a
Tested-by for these?

Also note that v2 of this series had an extra patch
<https://patchwork.kernel.org/patch/7888861/> that would attempt to sort
the allocation results to opportunistically get some extra alignment.  I
dropped that, but it could be re-introduced if there was interest.  I
found that it did give a little extra alignment sometimes, but maybe not
enough to justify the extra complexity.  It also was a bit half-baked
since it really should have tried harder to ensure alignment.

Changes in v5:
- renamed DMA_ATTR_NOHUGEPAGE to DMA_ATTR_NO_HUGE_PAGE
- s/ping ping/ping pong/
- Let drivers specify DMA attrs new for v5
- s5p-mfc patch new for v5

Changes in v4:
- renamed DMA_ATTR_SEQUENTIAL to DMA_ATTR_NOHUGEPAGE
- added Marek's ack

Changes in v3:
- add DMA_ATTR_SEQUENTIAL attribute new for v3
- Use DMA_ATTR_SEQUENTIAL hint patch new for v3.

Changes in v2:
- No longer just 1 page at a time, but gives up higher order quickly.
- Only tries important higher order allocations that might help us.

Douglas Anderson (4):
  ARM: dma-mapping: Optimize allocation
  common: DMA-mapping: add DMA_ATTR_NO_HUGE_PAGE attribute
  ARM: dma-mapping: Use DMA_ATTR_NO_HUGE_PAGE hint to optimize
    allocation
  [media] s5p-mfc: Set DMA_ATTR_NO_HUGE_PAGE

Tomasz Figa (1):
  [media] videobuf2-dc: Let drivers specify DMA attrs

 Documentation/DMA-attributes.txt               | 23 ++++++++++++++++
 arch/arm/mm/dma-mapping.c                      | 38 ++++++++++++++++----------
 drivers/media/platform/s5p-mfc/s5p_mfc.c       | 13 +++++++--
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 33 ++++++++++++++--------
 include/linux/dma-attrs.h                      |  1 +
 include/media/videobuf2-dma-contig.h           | 11 +++++++-
 6 files changed, 91 insertions(+), 28 deletions(-)

-- 
2.6.0.rc2.230.g3dd15c0

