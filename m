Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:32991
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751992AbdI0VKe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:10:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 11/13] scripts: kernel-doc: print the declaration name on warnings
Date: Wed, 27 Sep 2017 18:10:22 -0300
Message-Id: <ed5273749b3f54b50b0f5c0bde953d10c622fd04.1506546492.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506546492.git.mchehab@s-opensource.com>
References: <cover.1506546492.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506546492.git.mchehab@s-opensource.com>
References: <cover.1506546492.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic at create_parameterlist()'s ancillary push_parameter()
function has already a way to output the declaration name, with
would help to discover what declaration is missing.

However, currently, the logic is utterly broken, as it uses
the var $type with a wrong meaning. With the current code,
it will never print anything. I suspect that originally
it was using the second argument of output_declaration().

I opted to not rely on a globally defined $declaration_name,
but, instead, to pass it explicitly as a parameter.

While here, I removed a unaligned check for !$anon_struct_union.
This is not needed, as, if $anon_struct_union is not zero,
$parameterdescs{$param} will be defined.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 28c5fe63fb58..713608046d3a 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1037,7 +1037,7 @@ sub dump_struct($$) {
 	# Ignore other nested elements, like enums
 	$members =~ s/({[^\{\}]*})//g;
 
-	create_parameterlist($members, ';', $file);
+	create_parameterlist($members, ';', $file, $declaration_name);
 	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual);
 
 	# Adjust declaration for better display
@@ -1137,7 +1137,7 @@ sub dump_typedef($$) {
 	$declaration_name = $2;
 	my $args = $3;
 
-	create_parameterlist($args, ',', $file);
+	create_parameterlist($args, ',', $file, $declaration_name);
 
 	output_declaration($declaration_name,
 			   'function',
@@ -1186,10 +1186,11 @@ sub save_struct_actual($) {
     $struct_actual = $struct_actual . $actual . " ";
 }
 
-sub create_parameterlist($$$) {
+sub create_parameterlist($$$$) {
     my $args = shift;
     my $splitter = shift;
     my $file = shift;
+    my $declaration_name = shift;
     my $type;
     my $param;
 
@@ -1219,7 +1220,7 @@ sub create_parameterlist($$$) {
 	    $type = $arg;
 	    $type =~ s/([^\(]+\(\*?)\s*$param/$1/;
 	    save_struct_actual($param);
-	    push_parameter($param, $type, $file);
+	    push_parameter($param, $type, $file, $declaration_name);
 	} elsif ($arg) {
 	    $arg =~ s/\s*:\s*/:/g;
 	    $arg =~ s/\s*\[/\[/g;
@@ -1244,27 +1245,28 @@ sub create_parameterlist($$$) {
 	    foreach $param (@args) {
 		if ($param =~ m/^(\*+)\s*(.*)/) {
 		    save_struct_actual($2);
-		    push_parameter($2, "$type $1", $file);
+		    push_parameter($2, "$type $1", $file, $declaration_name);
 		}
 		elsif ($param =~ m/(.*?):(\d+)/) {
 		    if ($type ne "") { # skip unnamed bit-fields
 			save_struct_actual($1);
-			push_parameter($1, "$type:$2", $file)
+			push_parameter($1, "$type:$2", $file, $declaration_name)
 		    }
 		}
 		else {
 		    save_struct_actual($param);
-		    push_parameter($param, $type, $file);
+		    push_parameter($param, $type, $file, $declaration_name);
 		}
 	    }
 	}
     }
 }
 
-sub push_parameter($$$) {
+sub push_parameter($$$$) {
 	my $param = shift;
 	my $type = shift;
 	my $file = shift;
+	my $declaration_name = shift;
 
 	if (($anon_struct_union == 1) && ($type eq "") &&
 	    ($param eq "}")) {
@@ -1301,21 +1303,13 @@ sub push_parameter($$$) {
 	# warn if parameter has no description
 	# (but ignore ones starting with # as these are not parameters
 	# but inline preprocessor statements);
-	# also ignore unnamed structs/unions;
-	if (!$anon_struct_union) {
+	# Note: It will also ignore void params and unnamed structs/unions
 	if (!defined $parameterdescs{$param} && $param !~ /^#/) {
+		$parameterdescs{$param} = $undescribed;
 
-	    $parameterdescs{$param} = $undescribed;
-
-	    if (($type eq 'function') || ($type eq 'enum')) {
-		print STDERR "${file}:$.: warning: Function parameter ".
-		    "or member '$param' not " .
-		    "described in '$declaration_name'\n";
-	    }
-	    print STDERR "${file}:$.: warning:" .
-			 " No description found for parameter '$param'\n";
-	    ++$warnings;
-	}
+		print STDERR
+		      "${file}:$.: warning: Function parameter or member '$param' not described in '$declaration_name'\n";
+		++$warnings;
 	}
 
 	$param = xml_escape($param);
@@ -1472,7 +1466,7 @@ sub dump_function($$) {
 	$declaration_name = $2;
 	my $args = $3;
 
-	create_parameterlist($args, ',', $file);
+	create_parameterlist($args, ',', $file, $declaration_name);
     } else {
 	print STDERR "${file}:$.: warning: cannot understand function prototype: '$prototype'\n";
 	return;
-- 
2.13.5
