Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo09.poczta.onet.pl ([213.180.142.140]:48239 "EHLO
	smtpo09.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab1JRUFn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 16:05:43 -0400
Date: Tue, 18 Oct 2011 22:05:40 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [RESEND PATCH 12/14] staging/media/as102: fix licensing oversight
Message-ID: <20111018220540.1437710e@darkstar>
In-Reply-To: <20111018111340.8686f724.chmooreck@poczta.onet.pl>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
	<20110927213300.6893677a@stein>
	<4E999733.2010802@poczta.onet.pl>
	<4E99F2FC.5030200@poczta.onet.pl>
	<20111016105731.09d66f03@stein>
	<CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
	<4E9ADFAE.8050208@redhat.com>
	<20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
	<20111018111340.8686f724.chmooreck@poczta.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/

Original source and comment:# HG changeset patch
# User Devin Heitmueller <dheitmueller@kernellabs.com>
# Date 1267577404 18000
# Node ID 8557cb6da3e71a350a538e3a0eb41126884289b9
# Parent  84b93826c0a19efa114a6808165f91390cb86daa
as102: fix licensing oversight

From: Pierrick Hascoet <pierrick.hascoet@abilis.com>

Fix a couple of files which were supposed by be relicensed as GPL but were
overlooked.

Priority: normal

Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>

diff --git linux/drivers/staging/media/as102/as10x_cmd_cfg.c linuxb/drivers/staging/media/as102/as10x_cmd_cfg.c
--- linux/drivers/staging/media/as102/as10x_cmd_cfg.c
+++ linuxb/drivers/staging/media/as102/as10x_cmd_cfg.c
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
diff --git linux/drivers/staging/media/as102/as10x_cmd_stream.c linuxb/drivers/staging/media/as102/as10x_cmd_stream.c
--- linux/drivers/staging/media/as102/as10x_cmd_stream.c
+++ linuxb/drivers/staging/media/as102/as10x_cmd_stream.c
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
