Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64928 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752044AbdJDL6h (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 07:58:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v3 13/17] scripts: kernel-doc: get rid of $nested parameter
Date: Wed,  4 Oct 2017 08:48:51 -0300
Message-Id: <55fca19c79979bb1392ed245cf19c8fa7696bfd4.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
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
index 1b4a096a409b..8fe62b2dbc2d 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -983,7 +983,6 @@ sub dump_union($$) {
 sub dump_struct($$) {
     my $x = shift;
     my $file = shift;
-    my $nested;
 
     if ($x =~ /(struct|union)\s+(\w+)\s*{(.*)}/) {
 	my $decl_type = $1;
@@ -1041,11 +1040,9 @@ sub dump_struct($$) {
 
 	# Ignore other nested elements, like enums
 	$members =~ s/({[^\{\}]*})//g;
-	$nested = $decl_type;
-	$nested =~ s/\/\*.*?\*\///gos;
 
 	create_parameterlist($members, ';', $file);
-	check_sections($file, $declaration_name, $decl_type, $sectcheck, $struct_actual, $nested);
+	check_sections($file, $declaration_name, $decl_type, $sectcheck, $struct_actual);
 
 	# Adjust declaration for better display
 	$declaration =~ s/([{;])/$1\n/g;
@@ -1350,8 +1347,8 @@ sub push_parameter($$$) {
 	$parametertypes{$param} = $type;
 }
 
-sub check_sections($$$$$$) {
-	my ($file, $decl_name, $decl_type, $sectcheck, $prmscheck, $nested) = @_;
+sub check_sections($$$$$) {
+	my ($file, $decl_name, $decl_type, $sectcheck, $prmscheck) = @_;
 	my @sects = split ' ', $sectcheck;
 	my @prms = split ' ', $prmscheck;
 	my $err;
@@ -1385,14 +1382,6 @@ sub check_sections($$$$$$) {
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
@@ -1503,7 +1492,7 @@ sub dump_function($$) {
     }
 
 	my $prms = join " ", @parameterlist;
-	check_sections($file, $declaration_name, "function", $sectcheck, $prms, "");
+	check_sections($file, $declaration_name, "function", $sectcheck, $prms);
 
         # This check emits a lot of warnings at the moment, because many
         # functions don't have a 'Return' doc section. So until the number
-- 
2.13.6
