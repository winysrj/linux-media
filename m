Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:51048 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758870AbdLRMaa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 07:30:30 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v4 13/18] scripts: kernel-doc: get rid of $nested parameter
Date: Mon, 18 Dec 2017 10:30:14 -0200
Message-Id: <a59e922c8ec608fb8401249b35b20603d0090155.1513599193.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
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
index b0eb1cd6afbe..fadb832733d9 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1003,7 +1003,6 @@ sub dump_union($$) {
 sub dump_struct($$) {
     my $x = shift;
     my $file = shift;
-    my $nested;
 
     if ($x =~ /(struct|union)\s+(\w+)\s*{(.*)}/) {
 	my $decl_type = $1;
@@ -1063,11 +1062,9 @@ sub dump_struct($$) {
 
 	# Ignore other nested elements, like enums
 	$members =~ s/({[^\{\}]*})//g;
-	$nested = $decl_type;
-	$nested =~ s/\/\*.*?\*\///gos;
 
 	create_parameterlist($members, ';', $file);
-	check_sections($file, $declaration_name, $decl_type, $sectcheck, $struct_actual, $nested);
+	check_sections($file, $declaration_name, $decl_type, $sectcheck, $struct_actual);
 
 	# Adjust declaration for better display
 	$declaration =~ s/([{;])/$1\n/g;
@@ -1372,8 +1369,8 @@ sub push_parameter($$$) {
 	$parametertypes{$param} = $type;
 }
 
-sub check_sections($$$$$$) {
-	my ($file, $decl_name, $decl_type, $sectcheck, $prmscheck, $nested) = @_;
+sub check_sections($$$$$) {
+	my ($file, $decl_name, $decl_type, $sectcheck, $prmscheck) = @_;
 	my @sects = split ' ', $sectcheck;
 	my @prms = split ' ', $prmscheck;
 	my $err;
@@ -1407,14 +1404,6 @@ sub check_sections($$$$$$) {
 					"'$sects[$sx]' " .
 					"description in '$decl_name'\n";
 				++$warnings;
-			} else {
-				if ($nested !~ m/\Q$sects[$sx]\E/) {
-				    print STDERR "${file}:$.: warning: " .
-					"Excess $decl_type member " .
-					"'$sects[$sx]' " .
-					"description in '$decl_name'\n";
-				    ++$warnings;
-				}
 			}
 		}
 	}
@@ -1525,7 +1514,7 @@ sub dump_function($$) {
     }
 
 	my $prms = join " ", @parameterlist;
-	check_sections($file, $declaration_name, "function", $sectcheck, $prms, "");
+	check_sections($file, $declaration_name, "function", $sectcheck, $prms);
 
         # This check emits a lot of warnings at the moment, because many
         # functions don't have a 'Return' doc section. So until the number
-- 
2.14.3
