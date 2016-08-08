Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:52544 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbcHHNPZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Aug 2016 09:15:25 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/3] doc-rst: more generic way to build only sphinx sub-folders
Date: Mon,  8 Aug 2016 15:14:57 +0200
Message-Id: <1470662100-6927-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Hi Mauro,

this is my approach for a more generic way to build only sphinx sub-folders, we
discussed in [1]. The last patch adds a minimal conf.py to the gpu folder, if
you don't want to patch the gpu folder drop it.

[1] http://marc.info/?t=147051523900002

Markus Heiser (3):
  doc-rst: generic way to build only sphinx sub-folders
  doc-rst: add stand-alone conf.py to media folder
  doc-rst: add stand-alone conf.py to gpu folder

 Documentation/DocBook/Makefile      |   2 +-
 Documentation/Makefile.sphinx       |  52 +++++++++----
 Documentation/gpu/conf.py           |   3 +
 Documentation/media/conf.py         |   3 +
 Documentation/media/conf_nitpick.py | 150 +++++++++++++++++++-----------------
 Documentation/sphinx/load_config.py |  20 +++--
 Makefile                            |   6 --
 7 files changed, 137 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/gpu/conf.py
 create mode 100644 Documentation/media/conf.py

-- 
2.7.4

