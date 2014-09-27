Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53599 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaI0NSz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Sep 2014 09:18:55 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Olliver Schinagl <oliver@schinagl.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] Add targets to install the files at the system
Date: Sat, 27 Sep 2014 10:18:32 -0300
Message-Id: <1411823912-28014-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to be easier to package the scan tables, add
some targets to install the files, and add the instructions
about how to use it at the README file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Makefile | 27 +++++++++++++++++++++++++++
 README   | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/Makefile b/Makefile
index 2fb4a8890a37..0e58193bbb43 100644
--- a/Makefile
+++ b/Makefile
@@ -25,6 +25,22 @@ DVBV5OUTPUTDIR = dvbv5
 
 PHONY := clean dvbv3 dvbv5
 
+ifeq ($(PREFIX),)
+PREFIX = /usr/local
+endif
+
+ifeq ($(DATADIR),)
+DATADIR = $(PREFIX)/share
+endif
+
+ifeq ($(DVBV5DIR),)
+DVBV5DIR = dvbv5
+endif
+
+ifeq ($(DVBV3DIR),)
+DVBV3DIR = dvbv3
+endif
+
 dvbv3:
 	@$(foreach var,$(DVBV3DIRS), $(MKDIR) $(DVBV3OUTPUTDIR)/$(var);)
 	@$(foreach var,$(DVBV3CHANNELFILES), $(DVBFORMATCONVERT) $(DVBFORMATCONVERT_CHANNEL_DVBV3) $(var) $(DVBV3OUTPUTDIR)/$(var);)
@@ -34,6 +50,17 @@ dvbv5: $(DVBV3OUTPUTDIR)
 	@$(foreach var,$(DVBV3DIRS), $(MKDIR) $(DVBV5OUTPUTDIR)/$(var);)
 	@$(foreach var,$(DVBV3CHANNELFILES), $(DVBFORMATCONVERT) $(DVBFORMATCONVERT_CHANNEL_DVBV5) $(DVBV3OUTPUTDIR)/$(var) $(DVBV5OUTPUTDIR)/$(var);)
 
+install:
+	@echo -n Installing dvbv5-formatted files at $(DATADIR)/$(DVBV5DIR)...
+	@mkdir -p $(DATADIR)/$(DVBV5DIR)
+	@$(foreach var,$(DVBV3CHANNELFILES), install -D -p -m 644 $(var) $(DATADIR)/$(DVBV5DIR)/$(var);)
+	@echo done.
+
+install_v3:
+	@echo -n Installing dvbv3-formatted files at $(DATADIR)/$(DVBV3DIR)...
+	@mkdir -p $(DATADIR)/$(DVBV3DIR)
+	@$(foreach var,$(DVBV3CHANNELFILES), install -D -p -m 644 $(DVBV3OUTPUTDIR)/$(var) $(DATADIR)/$(DVBV3DIR)/$(var);)
+	@echo done.
 
 clean:
 	rm -rf $(DVBV3OUTPUTDIR)/ $(DVBV5OUTPUTDIR)/
diff --git a/README b/README
index 87561ee599ae..f0ae695aa09b 100644
--- a/README
+++ b/README
@@ -1,6 +1,9 @@
 All tables are now using DVBv5 format. That allows suporting all standards
 available on a standard way.
 
+GENERATING FILES TO THE LEGACY DVBV3 FORMAT
+===========================================
+
 A Makefile target is provided to convert to the legacy channel format.
 For it to work, you need to have v4l-utils installed (specifically,
 the v4l-utils package that contains the dvbv5 utils).
@@ -36,3 +39,37 @@ Plese notice that comments are not preserved when doing the conversions.
 PS.: If you're willing to submit new entries and/or corrections, please
 be sure to send them at the DVBv5 format and sending them via e-mail
 to linux-media@vger.kernel.org.
+
+INSTALL
+=======
+
+In order to install the files, use:
+	$ make install
+
+By default, it will install the files at /usr/local/share/dvbv5.
+
+In order to install the legacy v3 formatted files, use:
+	$ make install_v3
+
+Don't forget to run "make dvbv3" before running the above command,
+in order to convert the files to the legacy format.
+
+By default, it will install the files at /usr/local/share/dvbv3.
+
+There are a few extra parameters that could be used to define where
+the files will be stored:
+
+	PREFIX=<dir>		(default: /usr/local)
+	DATADIR=<dir>		(default: $(PREFIX/share)
+	DVBV5DIR=<subdir>	(default: dvbv3)
+	DVBV3DIR=<subdir>	(default: dvbv5)
+
+So, if it is desired to install both v3 and v5 files at a tmp file,
+under the current dir, the install command would be:
+
+	$ make install install_v3 PREFIX=`pwd`/tmp
+	Installing dvbv5-formatted files at /home/myuser/dtv-scan-tables/tmp/share/dvbv5...done.
+	Installing dvbv3-formatted files at /home/myuser/dtv-scan-tables/tmp/share/dvbv3...done.
+
+Please also note that install takes some time, as there are lots
+of files to be copied.
-- 
1.9.3

