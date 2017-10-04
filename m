Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37362 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751922AbdJDL6c (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 07:58:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v3 14/17] scripts: kernel-doc: print the declaration name on warnings
Date: Wed,  4 Oct 2017 08:48:52 -0300
Message-Id: <ee45418aca8983027ff93b0432acd2ea783e24d6.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
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
index 8fe62b2dbc2d..61e52c2b604e 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1041,7 +1041,7 @@ sub dump_struct($$) {
 	# Ignore other nested elements, like enums
 	$members =~ s/({[^\{\}]*})//g;
 
-	create_parameterlist($members, ';', $file);
+	create_parameterlist($members, ';', $file, $declaration_name);
 	check_sections($file, $declaration_name, $decl_type, $sectcheck, $struct_actual);
 
 	# Adjust declaration for better display
@@ -1150,7 +1150,7 @@ sub dump_typedef($$) {
 	$declaration_name = $2;
 	my $args = $3;
 
-	create_parameterlist($args, ',', $file);
+	create_parameterlist($args, ',', $file, $declaration_name);
 
 	output_declaration($declaration_name,
 			   'function',
@@ -1199,10 +1199,11 @@ sub save_struct_actual($) {
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
 
@@ -1232,7 +1233,7 @@ sub create_parameterlist($$$) {
 	    $type = $arg;
 	    $type =~ s/([^\(]+\(\*?)\s*$param/$1/;
 	    save_struct_actual($param);
-	    push_parameter($param, $type, $file);
+	    push_parameter($param, $type, $file, $declaration_name);
 	} elsif ($arg) {
 	    $arg =~ s/\s*:\s*/:/g;
 	    $arg =~ s/\s*\[/\[/g;
@@ -1257,27 +1258,28 @@ sub create_parameterlist($$$) {
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
@@ -1314,21 +1316,13 @@ sub push_parameter($$$) {
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
@@ -1485,7 +1479,7 @@ sub dump_function($$) {
 	$declaration_name = $2;
 	my $args = $3;
 
-	create_parameterlist($args, ',', $file);
+	create_parameterlist($args, ',', $file, $declaration_name);
     } else {
 	print STDERR "${file}:$.: warning: cannot understand function prototype: '$prototype'\n";
 	return;
-- 
2.13.6
