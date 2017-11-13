Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:52958 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750986AbdKMJTS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 04:19:18 -0500
Received: by mail-wr0-f196.google.com with SMTP id j23so13769860wra.9
        for <linux-media@vger.kernel.org>; Mon, 13 Nov 2017 01:19:17 -0800 (PST)
From: =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
Subject: [PATCH 2/2] sdlcam: ignore binary
Date: Mon, 13 Nov 2017 10:19:08 +0100
Message-Id: <20171113091908.23531-2-funman@videolan.org>
In-Reply-To: <20171113091908.23531-1-funman@videolan.org>
References: <20171113091908.23531-1-funman@videolan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Rafaël Carré <funman@videolan.org>
---
 contrib/test/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/contrib/test/.gitignore b/contrib/test/.gitignore
index ad64325b..5bd81d01 100644
--- a/contrib/test/.gitignore
+++ b/contrib/test/.gitignore
@@ -8,3 +8,4 @@ stress-buffer
 v4l2gl
 v4l2grab
 mc_nextgen_test
+sdlcam
-- 
2.14.1
