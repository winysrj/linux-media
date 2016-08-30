Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54877 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbcH3XVF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Aug 2016 19:21:05 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 2/3] docs-rst: kernel-doc: fix typedef output in RST format
Date: Tue, 30 Aug 2016 20:20:58 -0300
Message-Id: <9fd5454e49cb08751279198c57413948863ccadb.1472598859.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1472598859.git.mchehab@s-opensource.com>
References: <cover.1472598859.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1472598859.git.mchehab@s-opensource.com>
References: <cover.1472598859.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When using a typedef function like this one:
	typedef bool v4l2_check_dv_timings_fnc (const struct v4l2_dv_timings * t, void * handle);

The Sphinx C domain expects it to create a c:type: reference,
as that's the way it creates the type references when parsing
a c:function:: declaration.

So, a declaration like:

	.. c:function:: bool v4l2_valid_dv_timings (const struct v4l2_dv_timings * t, const struct v4l2_dv_timings_cap * cap, v4l2_check_dv_timings_fnc fnc, void * fnc_handle)

Will create a cross reference for :c:type:`v4l2_check_dv_timings_fnc`.

So, when outputting such typedefs in RST format, we need to handle
this special case, as otherwise it will produce those warnings:

	./include/media/v4l2-dv-timings.h:43: WARNING: c:type reference target not found: v4l2_check_dv_timings_fnc
	./include/media/v4l2-dv-timings.h:60: WARNING: c:type reference target not found: v4l2_check_dv_timings_fnc
	./include/media/v4l2-dv-timings.h:81: WARNING: c:type reference target not found: v4l2_check_dv_timings_fnc

So, change the kernel-doc script to produce a RST output for the
above typedef as:
	.. c:type:: v4l2_check_dv_timings_fnc

	   **Typedef**: timings check callback

	**Syntax**

	  ``bool v4l2_check_dv_timings_fnc (const struct v4l2_dv_timings * t, void * handle);``

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index d94870270d8e..091e49167b44 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1831,13 +1831,22 @@ sub output_function_rst(%) {
     my %args = %{$_[0]};
     my ($parameter, $section);
     my $oldprefix = $lineprefix;
-    my $start;
+    my $start = "";
 
-    print ".. c:function:: ";
+    if ($args{'typedef'}) {
+	print ".. c:type:: ". $args{'function'} . "\n\n";
+	print_lineno($declaration_start_line);
+	print "   **Typedef**: ";
+	$lineprefix = "";
+	output_highlight_rst($args{'purpose'});
+	$start = "\n\n**Syntax**\n\n  ``";
+    } else {
+	print ".. c:function:: ";
+    }
     if ($args{'functiontype'} ne "") {
-	$start = $args{'functiontype'} . " " . $args{'function'} . " (";
+	$start .= $args{'functiontype'} . " " . $args{'function'} . " (";
     } else {
-	$start = $args{'function'} . " (";
+	$start .= $args{'function'} . " (";
     }
     print $start;
 
@@ -1857,11 +1866,15 @@ sub output_function_rst(%) {
 	    $count++;
 	}
     }
-    print ")\n\n";
-    print_lineno($declaration_start_line);
-    $lineprefix = "   ";
-    output_highlight_rst($args{'purpose'});
-    print "\n";
+    if ($args{'typedef'}) {
+	print ");``\n\n";
+    } else {
+	print ")\n\n";
+	print_lineno($declaration_start_line);
+	$lineprefix = "   ";
+	output_highlight_rst($args{'purpose'});
+	print "\n";
+    }
 
     print "**Parameters**\n\n";
     $lineprefix = "  ";
@@ -2204,6 +2217,7 @@ sub dump_typedef($$) {
 	output_declaration($declaration_name,
 			   'function',
 			   {'function' => $declaration_name,
+			    'typedef' => 1,
 			    'module' => $modulename,
 			    'functiontype' => $return_type,
 			    'parameterlist' => \@parameterlist,
-- 
2.7.4


