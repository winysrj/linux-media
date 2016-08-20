Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43708 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbcHTBlA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 21:41:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        linux-doc@vger.kernel.org
Subject: [PATCH 3/3] cec-ioc-receive.rst: one table here should be longtable.
Date: Fri, 19 Aug 2016 22:40:53 -0300
Message-Id: <45f399e17f098829cc8cbc10c82b87b0f2c2f9fe.1471657229.git.mchehab@s-opensource.com>
In-Reply-To: <abb3c02861cfaf59fbdce94117aade037cb6d32c.1471657229.git.mchehab@s-opensource.com>
References: <abb3c02861cfaf59fbdce94117aade037cb6d32c.1471657229.git.mchehab@s-opensource.com>
In-Reply-To: <abb3c02861cfaf59fbdce94117aade037cb6d32c.1471657229.git.mchehab@s-opensource.com>
References: <abb3c02861cfaf59fbdce94117aade037cb6d32c.1471657229.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The table is too big to fit into a single page on LaTeX format.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-ioc-receive.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 7214b1ede34b..025a3851ab76 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -78,6 +78,8 @@ result.
 
 .. _cec-msg:
 
+.. cssclass:: longtable
+
 .. flat-table:: struct cec_msg
     :header-rows:  0
     :stub-columns: 0
-- 
2.7.4

