Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58562 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab1JaQZx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:25:53 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so5444327eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 09:25:52 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: [PATCH 11/17] staging: as102: Fix licensing oversight
Date: Mon, 31 Oct 2011 17:24:49 +0100
Message-Id: <1320078295-3379-12-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
References: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pierrick Hascoet <pierrick.hascoet@abilis.com>

Fix a couple of files which were supposed by be relicensed as GPL
but were overlooked.

Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as10x_cmd_cfg.c    |   35 +++++++++++-----------
 drivers/staging/media/as102/as10x_cmd_stream.c |   37 +++++++++++------------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/media/as102/as10x_cmd_cfg.c b/drivers/staging/media/as102/as10x_cmd_cfg.c
index 7b22e19..0635797 100644
--- a/drivers/staging/media/as102/as10x_cmd_cfg.c
+++ b/drivers/staging/media/as102/as10x_cmd_cfg.c
@@ -1,20 +1,21 @@
-/**
-
- \file   as10x_cmd_cfg.c
-
- \author: S. Martinelli
-
- ----------------------------------------------------------------------------\n
-   (c) Copyright Abilis Systems SARL 2005-2009 All rigths reserved \n
-   www.abilis.com                                                  \n
- ----------------------------------------------------------------------------\n
-
- \brief AS10x API, configuration services
-
-	AS10x cmd management: build command buffer, send command through
-	selected port and wait for the response when required.
-
-*/
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
 
 #if defined(LINUX) && defined(__KERNEL__) /* linux kernel implementation */
 #include <linux/kernel.h>
diff --git a/drivers/staging/media/as102/as10x_cmd_stream.c b/drivers/staging/media/as102/as10x_cmd_stream.c
index 8705894..b5e6254 100644
--- a/drivers/staging/media/as102/as10x_cmd_stream.c
+++ b/drivers/staging/media/as102/as10x_cmd_stream.c
@@ -1,22 +1,21 @@
-/**
-
- \file   as10x_cmd_stream.c
-
- \author: S. Martinelli
-
- ----------------------------------------------------------------------------\n
-   (c) Copyright Abilis Systems SARL 2005-2009 All rigths reserved \n
-   www.abilis.com                                                  \n
- ----------------------------------------------------------------------------\n
-
- \brief AS10x CMD, stream services
-
-	AS10x CMD management: build command buffer, send command through
-	selected port and wait for the response when required.
-
-*/
-
-
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
 #if defined(LINUX) && defined(__KERNEL__) /* linux kernel implementation */
 #include <linux/kernel.h>
 #include "as102_drv.h"
-- 
1.7.4.1

