Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39242 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbbJJNgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:20 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk>,
	Johannes Berg <johannes.berg@intel.com>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Bobbio?= <lunar@debian.org>,
	Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 20/26] kernel-doc: better format typedef function output
Date: Sat, 10 Oct 2015 10:36:03 -0300
Message-Id: <837664528e17380cfacfb766de37df31572f07a0.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A typedef function looks more likely a function and not a
normal typedef. Change the code to use the output_function_*,
in order to properly parse the function prototype parameters.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 55ce47ffa02d..0276d2b5eefe 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1869,6 +1869,31 @@ sub dump_typedef($$) {
     my $file = shift;
 
     $x =~ s@/\*.*?\*/@@gos;	# strip comments.
+
+    # Parse function prototypes
+    if ($x =~ /typedef\s+(\w+)\s*\(\*\s*(\w\S+)\s*\)\s*\((.*)\);/) {
+	# Function typedefs
+	$return_type = $1;
+	$declaration_name = $2;
+	my $args = $3;
+
+	create_parameterlist($args, ',', $file);
+
+	output_declaration($declaration_name,
+			   'function',
+			   {'function' => $declaration_name,
+			    'module' => $modulename,
+			    'functiontype' => $return_type,
+			    'parameterlist' => \@parameterlist,
+			    'parameterdescs' => \%parameterdescs,
+			    'parametertypes' => \%parametertypes,
+			    'sectionlist' => \@sectionlist,
+			    'sections' => \%sections,
+			    'purpose' => $declaration_purpose
+			   });
+	return;
+    }
+
     while (($x =~ /\(*.\)\s*;$/) || ($x =~ /\[*.\]\s*;$/)) {
 	$x =~ s/\(*.\)\s*;$/;/;
 	$x =~ s/\[*.\]\s*;$/;/;
@@ -1886,18 +1911,6 @@ sub dump_typedef($$) {
 			    'purpose' => $declaration_purpose
 			   });
     }
-    elsif ($x =~ /typedef\s+\w+\s*\(\*\s*(\w\S+)\s*\)\s*\(/) { # functions
-	$declaration_name = $1;
-
-	output_declaration($declaration_name,
-			   'typedef',
-			   {'typedef' => $declaration_name,
-			    'module' => $modulename,
-			    'sectionlist' => \@sectionlist,
-			    'sections' => \%sections,
-			    'purpose' => $declaration_purpose
-			   });
-    }
     else {
 	print STDERR "${file}:$.: error: Cannot parse typedef!\n";
 	++$errors;
-- 
2.4.3


