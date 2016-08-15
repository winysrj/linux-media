Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbcHOQXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 12:23:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH RFC 3/5] [media] docs-rst: get rid of extra less or equal symbols
Date: Mon, 15 Aug 2016 13:23:42 -0300
Message-Id: <d7aee61a32bbcfdf252e52d847c483210d6b8e52.1471277426.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471277426.git.mchehab@s-opensource.com>
References: <cover.1471277426.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1471277426.git.mchehab@s-opensource.com>
References: <cover.1471277426.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The LaTeX output format doesn't support less or equal UTF-8
symbols. So, we need to get rid of them or to convert to
math expressions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst | 2 +-
 Documentation/media/uapi/v4l/dev-overlay.rst              | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 04ee90099676..a7315a8d219a 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -114,7 +114,7 @@ logical address types are already defined will return with error ``EBUSY``.
 
        -  ``num_log_addrs``
 
-       -  Number of logical addresses to set up. Must be ≤
+       -  Number of logical addresses to set up. Must be less or equal to
 	  ``available_log_addrs`` as returned by
 	  :ref:`CEC_ADAP_G_CAPS`. All arrays in
 	  this structure are only filled up to index
diff --git a/Documentation/media/uapi/v4l/dev-overlay.rst b/Documentation/media/uapi/v4l/dev-overlay.rst
index 92b4471b0c6e..13359134b468 100644
--- a/Documentation/media/uapi/v4l/dev-overlay.rst
+++ b/Documentation/media/uapi/v4l/dev-overlay.rst
@@ -216,7 +216,12 @@ bits like:
 
     ((__u8 *) bitmap)[w.width * y + x / 8] & (1 << (x & 7))
 
-where ``0`` ≤ x < ``w.width`` and ``0`` ≤ y <``w.height``. [#f2]_
+where [#f2]_:
+
+.. math::
+
+    0 \le x < w.width \text{, and }
+    0 \le y < w.height
 
 When a clipping bit mask is not supported the driver ignores this field,
 its contents after calling :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` are
-- 
2.7.4


