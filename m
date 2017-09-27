Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:32967
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751960AbdI0VKd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:10:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 12/13] scripts: kernel-doc: handle nested struct function arguments
Date: Wed, 27 Sep 2017 18:10:23 -0300
Message-Id: <8cab7bd29fa6fbf8e54d1478a5be2a709cf35ea4.1506546492.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506546492.git.mchehab@s-opensource.com>
References: <cover.1506546492.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506546492.git.mchehab@s-opensource.com>
References: <cover.1506546492.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Function arguments are different than usual ones. So, an
special logic is needed in order to handle such arguments
on nested structs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 713608046d3a..376365d41718 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1015,18 +1015,32 @@ sub dump_struct($$) {
 			$id =~ s/^\*+//;
 			foreach my $arg (split /;/, $content) {
 				next if ($arg =~ m/^\s*$/);
-				my $type = $arg;
-				my $name = $arg;
-				$type =~ s/\s\S+$//;
-				$name =~ s/.*\s//;
-				$name =~ s/[:\[].*//;
-				$name =~ s/^\*+//;
-				next if (($name =~ m/^\s*$/));
-				if ($id =~ m/^\s*$/) {
-					# anonymous struct/union
-					$newmember .= "$type $name;";
+				if ($arg =~ m/^([^\(]+\(\*?\s*)([\w\.]*)(\s*\).*)/) {
+					# pointer-to-function
+					my $type = $1;
+					my $name = $2;
+					my $extra = $3;
+					next if (!$name);
+					if ($id =~ m/^\s*$/) {
+						# anonymous struct/union
+						$newmember .= "$type$name$extra;";
+					} else {
+						$newmember .= "$type$id.$name$extra;";
+					}
 				} else {
-					$newmember .= "$type $id.$name;";
+					my $type = $arg;
+					my $name = $arg;
+					$type =~ s/\s\S+$//;
+					$name =~ s/.*\s+//;
+					$name =~ s/[:\[].*//;
+					$name =~ s/^\*+//;
+					next if (($name =~ m/^\s*$/));
+					if ($id =~ m/^\s*$/) {
+						# anonymous struct/union
+						$newmember .= "$type $name;";
+					} else {
+						$newmember .= "$type $id.$name;";
+					}
 				}
 			}
 			$members =~ s/(struct|union)([^{};]+){([^{}]*)}([^{}\;]*)\;/$newmember/;
@@ -1215,7 +1229,7 @@ sub create_parameterlist($$$$) {
 	} elsif ($arg =~ m/\(.+\)\s*\(/) {
 	    # pointer-to-function
 	    $arg =~ tr/#/,/;
-	    $arg =~ m/[^\(]+\(\*?\s*(\w*)\s*\)/;
+	    $arg =~ m/[^\(]+\(\*?\s*([\w\.]*)\s*\)/;
 	    $param = $1;
 	    $type = $arg;
 	    $type =~ s/([^\(]+\(\*?)\s*$param/$1/;
-- 
2.13.5
