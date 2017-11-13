Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:4347 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753905AbdKMRFa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 12:05:30 -0500
From: Ville Syrjala <ville.syrjala@linux.intel.com>
To: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
        Shashank Sharma <shashank.sharma@intel.com>,
        "Lin, Jia" <lin.a.jia@intel.com>,
        Akashdeep Sharma <akashdeep.sharma@intel.com>,
        Jim Bride <jim.bride@linux.intel.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 08/10] video/hdmi: Reject illegal picture aspect ratios
Date: Mon, 13 Nov 2017 19:04:25 +0200
Message-Id: <20171113170427.4150-9-ville.syrjala@linux.intel.com>
In-Reply-To: <20171113170427.4150-1-ville.syrjala@linux.intel.com>
References: <20171113170427.4150-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

AVI infoframe can only carry none, 4:3, or 16:9 picture aspect
ratios. Return an error if the user asked for something different.

Cc: Shashank Sharma <shashank.sharma@intel.com>
Cc: "Lin, Jia" <lin.a.jia@intel.com>
Cc: Akashdeep Sharma <akashdeep.sharma@intel.com>
Cc: Jim Bride <jim.bride@linux.intel.com>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/video/hdmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
index 111a0ab6280a..38716eb50408 100644
--- a/drivers/video/hdmi.c
+++ b/drivers/video/hdmi.c
@@ -93,6 +93,9 @@ ssize_t hdmi_avi_infoframe_pack(struct hdmi_avi_infoframe *frame, void *buffer,
 	if (size < length)
 		return -ENOSPC;
 
+	if (frame->picture_aspect > HDMI_PICTURE_ASPECT_16_9)
+		return -EINVAL;
+
 	memset(buffer, 0, size);
 
 	ptr[0] = frame->type;
-- 
2.13.6
