Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36136 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab2JENWg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Oct 2012 09:22:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TK7rS-0007BY-Rr
	for linux-media@vger.kernel.org; Fri, 05 Oct 2012 15:22:38 +0200
Received: from 217-67-201-162.itsa.net.pl ([217.67.201.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 05 Oct 2012 15:22:38 +0200
Received: from t.stanislaws by 217-67-201-162.itsa.net.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 05 Oct 2012 15:22:38 +0200
To: linux-media@vger.kernel.org
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [GIT PULL FOR v3.7] media: s5p-hdmi: add HPD GPIO to platform data
Date: Fri, 05 Oct 2012 15:22:19 +0200
Message-ID: <506EDF0B.4010401@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
This patch is a part of "[PATCH v1 00/14] drm: exynos: hdmi: add dt based support for exynos5 hdmi"
patchset. The patchset refers to DRM tree (exynos-drm-next to be more exact).
However the patch 'media: s5p-hdmi: add HPD GPIO to platform data' belong to the media tree.

Regards,
Tomasz Stanislawski

The following changes since commit 2425bb3d4016ed95ce83a90b53bd92c7f31091e4:

  em28xx: regression fix: use DRX-K sync firmware requests on em28xx (2012-10-02 17:15:22 -0300)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l-s5p-tv-for3.7

for you to fetch changes up to b26bab928dd6f6e1d5613b68fa6fea1d29c9005e:

  media: s5p-hdmi: add HPD GPIO to platform data (2012-10-05 14:53:05 +0200)

----------------------------------------------------------------
Tomasz Stanislawski (1):
      media: s5p-hdmi: add HPD GPIO to platform data

 include/media/s5p_hdmi.h |    2 ++
 1 file changed, 2 insertions(+)

