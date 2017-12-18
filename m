Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64539 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758870AbdLRMa0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 07:30:26 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v4 10/18] scripts: kernel-doc: change default to ReST format
Date: Mon, 18 Dec 2017 10:30:11 -0200
Message-Id: <c1331cf05eabe43a32b8e2877a88a75f14a0b8ed.1513599193.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, if kernel-doc is called without arguments, it
defaults to man pages. IMO, it makes more sense to
default to ReST, as this is the output that it is most
used nowadays, and it easier to check if everything got
parsed fine on an enriched text mode format.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 11aec7469776..e417d93575b9 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -268,12 +268,12 @@ my $kernelversion;
 my $dohighlight = "";
 
 my $verbose = 0;
-my $output_mode = "man";
+my $output_mode = "rst";
 my $output_preformatted = 0;
 my $no_doc_sections = 0;
 my $enable_lineno = 0;
-my @highlights = @highlights_man;
-my $blankline = $blankline_man;
+my @highlights = @highlights_rst;
+my $blankline = $blankline_rst;
 my $modulename = "Kernel API";
 
 use constant {
-- 
2.14.3
