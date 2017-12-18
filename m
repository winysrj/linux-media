Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40483 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759094AbdLRMah (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 07:30:37 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v4 17/18] scripts: kernel-doc: apply filtering rules to warnings
Date: Mon, 18 Dec 2017 10:30:18 -0200
Message-Id: <00917bd6bbb0250c893433f27df956ea5c7e07a2.1513599193.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When kernel-doc is called with output selection filters,
it will be called lots of time for a single file. If
there is a warning present there, it means that it may
print hundreds of identical warnings.

Worse than that, the -function NAME actually filters only
functions. So, it makes no sense at all to print warnings
for structs or enums.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 0bda21d9d3f2..1e2b35ce1c9d 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1160,16 +1160,26 @@ sub dump_enum($$) {
 	    push @parameterlist, $arg;
 	    if (!$parameterdescs{$arg}) {
 		$parameterdescs{$arg} = $undescribed;
-		print STDERR "${file}:$.: warning: Enum value '$arg' ".
-		    "not described in enum '$declaration_name'\n";
+	        if (($output_selection == OUTPUT_ALL) ||
+		    ($output_selection == OUTPUT_INCLUDE &&
+		     defined($function_table{$declaration_name})) ||
+		    ($output_selection == OUTPUT_EXCLUDE &&
+		     !defined($function_table{$declaration_name}))) {
+			print STDERR "${file}:$.: warning: Enum value '$arg' not described in enum '$declaration_name'\n";
+		}
 	    }
 	    $_members{$arg} = 1;
 	}
 
 	while (my ($k, $v) = each %parameterdescs) {
 	    if (!exists($_members{$k})) {
-	     print STDERR "${file}:$.: warning: Excess enum value " .
-	                  "'$k' description in '$declaration_name'\n";
+	        if (($output_selection == OUTPUT_ALL) ||
+		    ($output_selection == OUTPUT_INCLUDE &&
+		     defined($function_table{$declaration_name})) ||
+		    ($output_selection == OUTPUT_EXCLUDE &&
+		     !defined($function_table{$declaration_name}))) {
+		     print STDERR "${file}:$.: warning: Excess enum value '$k' description in '$declaration_name'\n";
+		}
 	    }
         }
 
@@ -1375,9 +1385,15 @@ sub push_parameter($$$$) {
 	if (!defined $parameterdescs{$param} && $param !~ /^#/) {
 		$parameterdescs{$param} = $undescribed;
 
-		print STDERR
-		      "${file}:$.: warning: Function parameter or member '$param' not described in '$declaration_name'\n";
-		++$warnings;
+	        if (($output_selection == OUTPUT_ALL) ||
+		    ($output_selection == OUTPUT_INCLUDE &&
+		     defined($function_table{$declaration_name})) ||
+		    ($output_selection == OUTPUT_EXCLUDE &&
+		     !defined($function_table{$declaration_name}))) {
+			print STDERR
+			      "${file}:$.: warning: Function parameter or member '$param' not described in '$declaration_name'\n";
+			++$warnings;
+		}
 	}
 
 	$param = xml_escape($param);
-- 
2.14.3
