Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:52154 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751124AbdKTNle (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Nov 2017 08:41:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 0/2] video/hdmi: two fixes
Date: Mon, 20 Nov 2017 14:41:27 +0100
Message-Id: <20171120134129.26161-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Ville, can you add these two to your "drm/edid: Infoframe cleanups and fixes"
patch series? These two have been in our queue for some time now and were
never upstreamed, so this is a good opportunity to finally kick them out.

Once all this is merged I really should sit down and add full HDMI 2.0
and CTA-861-G support as well.

Regards,

	Hans

Hans Verkuil (1):
  drivers/video/hdmi: allow for larger-than-needed vendor IF

Martin Bugge (1):
  hdmi: audio infoframe log: corrected channel count

 drivers/video/hdmi.c | 5 ++---
 include/linux/hdmi.h | 1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.14.1
