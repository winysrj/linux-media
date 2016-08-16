Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49455 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbcHPQZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:25:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 6/9] docs-rst: better adjust margins and font size
Date: Tue, 16 Aug 2016 13:25:40 -0300
Message-Id: <f1f0073c853e4ff6232b04617da705487ef03b99.1471364025.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we have big tables, reduce the left/right margins and decrease
the point size to 8pt. Visually, it is still good enough, and
now less tables are too big to be displayed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index e254198b1dbf..ac5230fcda4d 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -249,7 +249,7 @@ latex_elements = {
 'papersize': 'a4paper',
 
 # The font size ('10pt', '11pt' or '12pt').
-'pointsize': '10pt',
+'pointsize': '8pt',
 
 # Latex figure (float) alignment
 #'figure_align': 'htbp',
@@ -260,6 +260,9 @@ latex_elements = {
 
 # Additional stuff for the LaTeX preamble.
     'preamble': '''
+	% Adjust margins
+	\\usepackage[margin=0.5in, top=1in, bottom=1in]{geometry}
+
         % Allow generate some pages in landscape
         \\usepackage{lscape}
 
-- 
2.7.4


