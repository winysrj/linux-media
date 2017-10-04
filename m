Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60173 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751948AbdJDL6e (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 07:58:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v3 15/17] scripts: kernel-doc: handle nested struct function arguments
Date: Wed,  4 Oct 2017 08:48:53 -0300
Message-Id: <08859f1abe9432275866a7836db49c1a6d88b698.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
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
index 61e52c2b604e..67e8712aa324 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1019,18 +1019,32 @@ sub dump_struct($$) {
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
@@ -1228,7 +1242,7 @@ sub create_parameterlist($$$$) {
 	} elsif ($arg =~ m/\(.+\)\s*\(/) {
 	    # pointer-to-function
 	    $arg =~ tr/#/,/;
-	    $arg =~ m/[^\(]+\(\*?\s*(\w*)\s*\)/;
+	    $arg =~ m/[^\(]+\(\*?\s*([\w\.]*)\s*\)/;
 	    $param = $1;
 	    $type = $arg;
 	    $type =~ s/([^\(]+\(\*?)\s*$param/$1/;
-- 
2.13.6
