Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:32975
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751960AbdI0VKf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:10:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 10/13] scripts: kernel-doc: get rid of $nested parameter
Date: Wed, 27 Sep 2017 18:10:21 -0300
Message-Id: <0b2f37d32a90e88a361034df95ab0f687bc54eac.1506546492.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506546492.git.mchehab@s-opensource.com>
References: <cover.1506546492.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506546492.git.mchehab@s-opensource.com>
References: <cover.1506546492.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The check_sections() function has a $nested parameter, meant
to identify when a nested struct is present. As we now have
a logic that handles it, get rid of such parameter.

Suggested-by: Markus Heiser <markus.heiser@darmarit.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 63aa9f85d635..28c5fe63fb58 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -979,7 +979,6 @@ sub dump_union($$) {
 sub dump_struct($$) {
     my $x = shift;
     my $file = shift;
-    my $nested;
 
     if ($x =~ /(struct|union)\s+(\w+)\s*{(.*)}/) {
 	my $decl_type = $1;
@@ -1037,11 +1036,9 @@ sub dump_struct($$) {
 
 	# Ignore other nested elements, like enums
 	$members =~ s/({[^\{\}]*})//g;
-	$nested = $decl_type;
-	$nested =~ s/\/\*.*?\*\///gos;
 
 	create_parameterlist($members, ';', $file);
-	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual, $nested);
+	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual);
 
 	# Adjust declaration for better display
 	$declaration =~ s/([{;])/$1\n/g;
@@ -1337,8 +1334,8 @@ sub push_parameter($$$) {
 	$parametertypes{$param} = $type;
 }
 
-sub check_sections($$$$$$) {
-	my ($file, $decl_name, $decl_type, $sectcheck, $prmscheck, $nested) = @_;
+sub check_sections($$$$$) {
+	my ($file, $decl_name, $decl_type, $sectcheck, $prmscheck) = @_;
 	my @sects = split ' ', $sectcheck;
 	my @prms = split ' ', $prmscheck;
 	my $err;
@@ -1372,14 +1369,6 @@ sub check_sections($$$$$$) {
 					"'$sects[$sx]' " .
 					"description in '$decl_name'\n";
 				++$warnings;
-			} else {
-				if ($nested !~ m/\Q$sects[$sx]\E/) {
-				    print STDERR "${file}:$.: warning: " .
-					"Excess struct/union/enum/typedef member " .
-					"'$sects[$sx]' " .
-					"description in '$decl_name'\n";
-				    ++$warnings;
-				}
 			}
 		}
 	}
@@ -1490,7 +1479,7 @@ sub dump_function($$) {
     }
 
 	my $prms = join " ", @parameterlist;
-	check_sections($file, $declaration_name, "function", $sectcheck, $prms, "");
+	check_sections($file, $declaration_name, "function", $sectcheck, $prms);
 
         # This check emits a lot of warnings at the moment, because many
         # functions don't have a 'Return' doc section. So until the number
-- 
2.13.5
