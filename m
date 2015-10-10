Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39240 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbbJJNgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:20 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	Johannes Berg <johannes.berg@intel.com>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Bobbio?= <lunar@debian.org>,
	Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk>,
	Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 19/26] kernel-doc: Add a parser for function typedefs
Date: Sat, 10 Oct 2015 10:36:02 -0300
Message-Id: <3a80a766328fe73df5951639b5c9013ddba6efec.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current typedef parser only works for non-function typedefs.

As we need to also document some function typedefs, add a
parser for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 9a08fb5c1af6..55ce47ffa02d 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1886,6 +1886,18 @@ sub dump_typedef($$) {
 			    'purpose' => $declaration_purpose
 			   });
     }
+    elsif ($x =~ /typedef\s+\w+\s*\(\*\s*(\w\S+)\s*\)\s*\(/) { # functions
+	$declaration_name = $1;
+
+	output_declaration($declaration_name,
+			   'typedef',
+			   {'typedef' => $declaration_name,
+			    'module' => $modulename,
+			    'sectionlist' => \@sectionlist,
+			    'sections' => \%sections,
+			    'purpose' => $declaration_purpose
+			   });
+    }
     else {
 	print STDERR "${file}:$.: error: Cannot parse typedef!\n";
 	++$errors;
-- 
2.4.3


