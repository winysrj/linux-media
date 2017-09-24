Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:63084 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750947AbdIXKdN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 06:33:13 -0400
Subject: [PATCH 6/6] [media] omap_vout: Delete two unnecessary variable
 initialisations in omap_vout_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Jan Kara <jack@suse.cz>, Lorenzo Stoakes <lstoakes@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Muralidharan Karicheri <mkaricheri@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f9dc652b-4fca-37aa-0b72-8c9e6a828da9@users.sourceforge.net>
Message-ID: <0f538063-3819-5ef8-3311-02676cb1042d@users.sourceforge.net>
Date: Sun, 24 Sep 2017 12:33:01 +0200
MIME-Version: 1.0
In-Reply-To: <f9dc652b-4fca-37aa-0b72-8c9e6a828da9@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 24 Sep 2017 11:33:39 +0200

The variables "dssdev" and "vid_dev" will eventually be set
to appropriate pointers a bit later.
Thus omit the explicit initialisations at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/omap/omap_vout.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index f446a37064f4..0efcea820007 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -2075,9 +2075,9 @@ static int __init omap_vout_probe(struct platform_device *pdev)
 {
 	int ret = 0, i;
 	struct omap_overlay *ovl;
-	struct omap_dss_device *dssdev = NULL;
+	struct omap_dss_device *dssdev;
 	struct omap_dss_device *def_display;
-	struct omap2video_device *vid_dev = NULL;
+	struct omap2video_device *vid_dev;
 
 	if (omapdss_is_initialized() == false)
 		return -EPROBE_DEFER;
-- 
2.14.1
