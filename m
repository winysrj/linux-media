Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41842 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934771AbdC3ULp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 16:11:45 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/9] scripts/kernel-doc: fix handling of parameters with parenthesis
Date: Thu, 30 Mar 2017 17:11:29 -0300
Message-Id: <e185d44c7bce578d70a22cd6b44d246743a2c122.1490904090.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1490904090.git.mchehab@s-opensource.com>
References: <cover.1490904090.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1490904090.git.mchehab@s-opensource.com>
References: <cover.1490904090.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lib/crc32c defines one parameter as:
	const u32 (*tab)[256]

Better handle parenthesis, to avoid those warnings:

./lib/crc32.c:149: warning: No description found for parameter 'tab)[256]'
./lib/crc32.c:149: warning: Excess function parameter 'tab' description in 'crc32_le_generic'
./lib/crc32.c:294: warning: No description found for parameter 'tab)[256]'
./lib/crc32.c:294: warning: Excess function parameter 'tab' description in 'crc32_be_generic'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index a4e5cc3b38e8..a26a5f2dce39 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -2402,8 +2402,7 @@ sub push_parameter($$$) {
 	}
 
 	$anon_struct_union = 0;
-	my $param_name = $param;
-	$param_name =~ s/\[.*//;
+	$param =~ s/[\[\)].*//;
 
 	if ($type eq "" && $param =~ /\.\.\.$/)
 	{
@@ -2434,9 +2433,9 @@ sub push_parameter($$$) {
 	# but inline preprocessor statements);
 	# also ignore unnamed structs/unions;
 	if (!$anon_struct_union) {
-	if (!defined $parameterdescs{$param_name} && $param_name !~ /^#/) {
+	if (!defined $parameterdescs{$param} && $param !~ /^#/) {
 
-	    $parameterdescs{$param_name} = $undescribed;
+	    $parameterdescs{$param} = $undescribed;
 
 	    if (($type eq 'function') || ($type eq 'enum')) {
 		print STDERR "${file}:$.: warning: Function parameter ".
-- 
2.9.3
