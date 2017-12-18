Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35253 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759122AbdLRMah (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 07:30:37 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v4 15/18] scripts: kernel-doc: handle nested struct function arguments
Date: Mon, 18 Dec 2017 10:30:16 -0200
Message-Id: <041ba233cae59ed1140b72ffbaa1d512e173863a.1513599193.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
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
index c97b89f47795..5d03c9086323 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1041,18 +1041,32 @@ sub dump_struct($$) {
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
@@ -1250,7 +1264,7 @@ sub create_parameterlist($$$$) {
 	} elsif ($arg =~ m/\(.+\)\s*\(/) {
 	    # pointer-to-function
 	    $arg =~ tr/#/,/;
-	    $arg =~ m/[^\(]+\(\*?\s*(\w*)\s*\)/;
+	    $arg =~ m/[^\(]+\(\*?\s*([\w\.]*)\s*\)/;
 	    $param = $1;
 	    $type = $arg;
 	    $type =~ s/([^\(]+\(\*?)\s*$param/$1/;
-- 
2.14.3
