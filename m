Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51084 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbcHFVBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Aug 2016 17:01:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/3] doc-rst: remove a bogus comment from Documentation/index.rst
Date: Sat,  6 Aug 2016 09:00:34 -0300
Message-Id: <da20cfbae03372f5786a0c42e59ef98055492f23.1470484077.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1470484077.git.mchehab@s-opensource.com>
References: <cover.1470484077.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1470484077.git.mchehab@s-opensource.com>
References: <cover.1470484077.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a bogus document at the documentation index saying
that there was nothing there, likely a left-over from the
initial Sphinx patches. Get rid of it!

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/index.rst | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/index.rst b/Documentation/index.rst
index 02255c1806f6..bdd9525e05aa 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -6,8 +6,6 @@
 Welcome to The Linux Kernel's documentation!
 ============================================
 
-Nothing for you to see here *yet*. Please move along.
-
 Contents:
 
 .. toctree::
-- 
2.7.4


