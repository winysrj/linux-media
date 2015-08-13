Return-path: <linux-media-owner@vger.kernel.org>
Received: from tux25.hoststar.at ([85.10.203.25]:45037 "EHLO tux25.hoststar.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbbHMUWN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 16:22:13 -0400
Received: from Dagon (chello084114214250.5.15.vie.surfer.at [84.114.214.250])
	(authenticated bits=0)
	by tux25.hoststar.at (8.13.8/8.12.11) with ESMTP id t7DJlEAP010691
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 13 Aug 2015 21:47:15 +0200
Date: Thu, 13 Aug 2015 21:47:12 +0200
From: "Robert 'Bobby' Zenz" <Robert.Zenz@bonsaimind.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] Fixed syntax errors in v4.1_pat_enabled.patch.
Message-ID: <20150813214712.7e5c2814@Dagon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Robert Zenz <Robert.Zenz@bonsaimind.org>
---
 backports/v4.1_pat_enabled.patch | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/backports/v4.1_pat_enabled.patch b/backports/v4.1_pat_enabled.patch
index b266d9d..66a8671 100644
--- a/backports/v4.1_pat_enabled.patch
+++ b/backports/v4.1_pat_enabled.patch
@@ -10,9 +10,8 @@ index 8b95eef..020955d 100644
 -		pr_warn("ivtvfb needs PAT disabled, boot with nopat kernel parameter\n");
 +#ifdef CONFIG_X86_PAT
 +	if (WARN(pat_enabled,
-+		"ivtvfb needs PAT disabled, boot with nopat kernel parameter\n");
++		"ivtvfb needs PAT disabled, boot with nopat kernel parameter\n"))
  		return -ENODEV;
- 	}
  #endif
 +#endif
  
-- 
1.9.1
