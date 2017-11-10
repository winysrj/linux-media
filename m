Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:51716 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751133AbdKJQF7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 11:05:59 -0500
Received: by mail-wm0-f41.google.com with SMTP id b9so3741502wmh.0
        for <linux-media@vger.kernel.org>; Fri, 10 Nov 2017 08:05:58 -0800 (PST)
Received: from localhost.localdomain ([62.147.246.169])
        by smtp.gmail.com with ESMTPSA id 56sm5153746wrx.2.2017.11.10.08.05.54
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Nov 2017 08:05:55 -0800 (PST)
From: =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] sdlcam: ignore binary
Date: Fri, 10 Nov 2017 17:05:47 +0100
Message-Id: <20171110160547.32639-2-funman@videolan.org>
In-Reply-To: <20171110160547.32639-1-funman@videolan.org>
References: <20171110160547.32639-1-funman@videolan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
