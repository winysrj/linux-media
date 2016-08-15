Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:33566 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbcHOOIv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 10:08:51 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 4/5] doc-rst: Revert "kernel-doc: fix handling of address_space tags"
Date: Mon, 15 Aug 2016 16:08:27 +0200
Message-Id: <1471270108-29314-5-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1471270108-29314-1-git-send-email-markus.heiser@darmarit.de>
References: <1471270108-29314-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

This reverts commit a88b1672d4ddf9895eb53e6980926d5e960dea8e.

>From the origin comit log::

  The RST cpp:function handler is very pedantic: it doesn't allow any
  macros like __user on it

Since the kernel-doc parser does NOT make use of the cpp:domain, there
is no need to change the kernel-doc parser eleminating the address_space
tags.

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 scripts/kernel-doc | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 4f2e904..ba081c7 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1849,9 +1849,6 @@ sub output_function_rst(%) {
 	$count++;
 	$type = $args{'parametertypes'}{$parameter};
 
-	# RST doesn't like address_space tags at function prototypes
-	$type =~ s/__(user|kernel|iomem|percpu|pmem|rcu)\s*//;
-
 	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
 	    # pointer-to-function
 	    print $1 . $parameter . ") (" . $2;
-- 
2.7.4

