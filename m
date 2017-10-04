Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39468 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752040AbdJDL6h (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 07:58:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v3 10/17] scripts: kernel-doc: change default to ReST format
Date: Wed,  4 Oct 2017 08:48:48 -0300
Message-Id: <47eb83dcc7d744ba761739352b58894e0ae05013.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
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
index f5901989971f..2d3d5e9bf7de 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -267,12 +267,12 @@ my $kernelversion;
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
2.13.6
