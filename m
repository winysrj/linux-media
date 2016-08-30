Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54874 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754256AbcH3XVF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Aug 2016 19:21:05 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 1/3] docs-rst: improve typedef parser
Date: Tue, 30 Aug 2016 20:20:57 -0300
Message-Id: <edc7244d9cbf9fce0a01e431df9dce17bf05620e.1472598859.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1472598859.git.mchehab@s-opensource.com>
References: <cover.1472598859.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1472598859.git.mchehab@s-opensource.com>
References: <cover.1472598859.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improve the parser to handle typedefs like:

	typedef bool v4l2_check_dv_timings_fnc(const struct v4l2_dv_timings *t, void *handle);

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index bac0af4fc659..d94870270d8e 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -2191,7 +2191,9 @@ sub dump_typedef($$) {
     $x =~ s@/\*.*?\*/@@gos;	# strip comments.
 
     # Parse function prototypes
-    if ($x =~ /typedef\s+(\w+)\s*\(\*\s*(\w\S+)\s*\)\s*\((.*)\);/) {
+    if ($x =~ /typedef\s+(\w+)\s*\(\*\s*(\w\S+)\s*\)\s*\((.*)\);/ ||
+	$x =~ /typedef\s+(\w+)\s*(\w\S+)\s*\s*\((.*)\);/) {
+
 	# Function typedefs
 	$return_type = $1;
 	$declaration_name = $2;
-- 
2.7.4


