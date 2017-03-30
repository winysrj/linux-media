Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36194 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934787AbdC3ULp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 16:11:45 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/9] scripts/kernel-doc: fix parser for apostrophes
Date: Thu, 30 Mar 2017 17:11:28 -0300
Message-Id: <8a132848c3a6d0ddbb50d79f4cdfc2b3f0afc942.1490904090.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1490904090.git.mchehab@s-opensource.com>
References: <cover.1490904090.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1490904090.git.mchehab@s-opensource.com>
References: <cover.1490904090.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On ReST, adding a text like ``literal`` is valid. However,
the kernel-doc script won't handle it fine.

We really need this feature, in order to escape things like
%ph, with is found on some C files.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 33c85dfdfce9..a4e5cc3b38e8 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -202,6 +202,7 @@ EOF
 # '&struct_name.member' - name of a structure member
 # '@parameter' - name of a parameter
 # '%CONST' - name of a constant.
+# '``LITERAL``' - literal string without any spaces on it.
 
 ## init lots of data
 
@@ -210,7 +211,8 @@ my $warnings = 0;
 my $anon_struct_union = 0;
 
 # match expressions used to find embedded type information
-my $type_constant = '\%([-_\w]+)';
+my $type_constant = '\b``([^\`]+)``\b';
+my $type_constant2 = '\%([-_\w]+)';
 my $type_func = '(\w+)\(\)';
 my $type_param = '\@(\w+(\.\.\.)?)';
 my $type_fp_param = '\@(\w+)\(\)';  # Special RST handling for func ptr params
@@ -235,6 +237,7 @@ my $type_member_func = $type_member . '\(\)';
 # these work fairly well
 my @highlights_html = (
                        [$type_constant, "<i>\$1</i>"],
+                       [$type_constant2, "<i>\$1</i>"],
                        [$type_func, "<b>\$1</b>"],
                        [$type_enum_xml, "<i>\$1</i>"],
                        [$type_struct_xml, "<i>\$1</i>"],
@@ -252,6 +255,7 @@ my $blankline_html = $local_lt . "p" . $local_gt;	# was "<p>"
 # html version 5
 my @highlights_html5 = (
                         [$type_constant, "<span class=\"const\">\$1</span>"],
+                        [$type_constant2, "<span class=\"const\">\$1</span>"],
                         [$type_func, "<span class=\"func\">\$1</span>"],
                         [$type_enum_xml, "<span class=\"enum\">\$1</span>"],
                         [$type_struct_xml, "<span class=\"struct\">\$1</span>"],
@@ -268,6 +272,7 @@ my $blankline_html5 = $local_lt . "br /" . $local_gt;
 my @highlights_xml = (
                       ["([^=])\\\"([^\\\"<]+)\\\"", "\$1<quote>\$2</quote>"],
                       [$type_constant, "<constant>\$1</constant>"],
+                      [$type_constant2, "<constant>\$1</constant>"],
                       [$type_enum_xml, "<type>\$1</type>"],
                       [$type_struct_xml, "<structname>\$1</structname>"],
                       [$type_typedef_xml, "<type>\$1</type>"],
@@ -283,6 +288,7 @@ my $blankline_xml = $local_lt . "/para" . $local_gt . $local_lt . "para" . $loca
 # gnome, docbook format
 my @highlights_gnome = (
                         [$type_constant, "<replaceable class=\"option\">\$1</replaceable>"],
+                        [$type_constant2, "<replaceable class=\"option\">\$1</replaceable>"],
                         [$type_func, "<function>\$1</function>"],
                         [$type_enum, "<type>\$1</type>"],
                         [$type_struct, "<structname>\$1</structname>"],
@@ -298,6 +304,7 @@ my $blankline_gnome = "</para><para>\n";
 # these are pretty rough
 my @highlights_man = (
                       [$type_constant, "\$1"],
+                      [$type_constant2, "\$1"],
                       [$type_func, "\\\\fB\$1\\\\fP"],
                       [$type_enum, "\\\\fI\$1\\\\fP"],
                       [$type_struct, "\\\\fI\$1\\\\fP"],
@@ -312,6 +319,7 @@ my $blankline_man = "";
 # text-mode
 my @highlights_text = (
                        [$type_constant, "\$1"],
+                       [$type_constant2, "\$1"],
                        [$type_func, "\$1"],
                        [$type_enum, "\$1"],
                        [$type_struct, "\$1"],
@@ -326,6 +334,7 @@ my $blankline_text = "";
 # rst-mode
 my @highlights_rst = (
                        [$type_constant, "``\$1``"],
+                       [$type_constant2, "``\$1``"],
                        # Note: need to escape () to avoid func matching later
                        [$type_member_func, "\\:c\\:type\\:`\$1\$2\$3\\\\(\\\\) <\$1>`"],
                        [$type_member, "\\:c\\:type\\:`\$1\$2\$3 <\$1>`"],
@@ -344,6 +353,7 @@ my $blankline_rst = "\n";
 # list mode
 my @highlights_list = (
                        [$type_constant, "\$1"],
+                       [$type_constant2, "\$1"],
                        [$type_func, "\$1"],
                        [$type_enum, "\$1"],
                        [$type_struct, "\$1"],
-- 
2.9.3
