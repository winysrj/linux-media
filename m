Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35318 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753367AbcHUSve (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Aug 2016 14:51:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 2/2] [media] index.rst: Fix LaTeX error in interactive mode on Sphinx 1.4.x
Date: Sun, 21 Aug 2016 15:51:28 -0300
Message-Id: <7073f7b96816ee892937ac8da1ad1e9b4cd7be9c.1471805458.git.mchehab@s-opensource.com>
In-Reply-To: <d3a26c93496a56d76db52297bbead041c3a4a23a.1471805458.git.mchehab@s-opensource.com>
References: <d3a26c93496a56d76db52297bbead041c3a4a23a.1471805458.git.mchehab@s-opensource.com>
In-Reply-To: <d3a26c93496a56d76db52297bbead041c3a4a23a.1471805458.git.mchehab@s-opensource.com>
References: <d3a26c93496a56d76db52297bbead041c3a4a23a.1471805458.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Sphinx 1.4.x definition for \DUrole is:

\providecommand*{\DUrole}[2]{%
  \ifcsname DUrole#1\endcsname%
    \csname DUrole#1\endcsname{#2}%
  \else% backwards compatibility: try \docutilsrole#1{#2}
    \ifcsname docutilsrole#1\endcsname%
      \csname docutilsrole#1\endcsname{#2}%
    \else%
      #2%
    \fi%
  \fi%
}

This is broken when it is used inside a \begin{alltt} block.
So, replace it by just "#2", as this won't cause troubles, and
it is one of the fallback methods for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/index.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/media/index.rst b/Documentation/media/index.rst
index 7f8f0af620ce..e347a3e7bdef 100644
--- a/Documentation/media/index.rst
+++ b/Documentation/media/index.rst
@@ -1,6 +1,11 @@
 Linux Media Subsystem Documentation
 ===================================
 
+.. Sphinx 1.4.x has a definition for DUrole that doesn't work on alltt blocks
+.. raw:: latex
+
+	\renewcommand*{\DUrole}[2]{ #2 }
+
 Contents:
 
 .. toctree::
-- 
2.7.4

