Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48781 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbcGIMuU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 08:50:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 2/3] doc-rst: parse-headers: remove trailing spaces
Date: Sat,  9 Jul 2016 09:50:03 -0300
Message-Id: <fb6fc6c9ac66fe5d4a50905fd7f2dd14cd9e7ab9.1468068561.git.mchehab@s-opensource.com>
In-Reply-To: <2dd4f70985558b1f9cf2a203dd23e3b9d5c4e597.1468068561.git.mchehab@s-opensource.com>
References: <2dd4f70985558b1f9cf2a203dd23e3b9d5c4e597.1468068561.git.mchehab@s-opensource.com>
In-Reply-To: <2dd4f70985558b1f9cf2a203dd23e3b9d5c4e597.1468068561.git.mchehab@s-opensource.com>
References: <2dd4f70985558b1f9cf2a203dd23e3b9d5c4e597.1468068561.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function that replace references add a "\ " at the end of
references, to avoid the ReST markup parser to not identify
them as references. That works fine except for the end of lines,
as a sequence of { '\', ' ', '\n' } characters makes Sphinx
to ignore the end of line. So, strip those escape/spaces at the
end of lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/sphinx/parse-headers.pl | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index 0a3703bef5eb..34bd9e2630b0 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -303,6 +303,8 @@ foreach my $r (keys %typedefs) {
 	$data =~ s/($start_delim)($r)$end_delim/$1$s$3/g;
 }
 
+$data =~ s/\\ \n/\n/g;
+
 #
 # Generate output file
 #
-- 
2.7.4

