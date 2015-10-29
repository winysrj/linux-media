Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36357 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbbJ2Rkg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 13:40:36 -0400
Date: Fri, 30 Oct 2015 01:15:39 +0800
From: Wang YanQing <udknight@gmail.com>
To: mchehab@osg.samsung.com
Cc: torvalds@linux-foundation.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC] Documentation: dontdiff: remove media from dontdiff
Message-ID: <20151029171539.GA5086@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media will hide all the changes in drivers/media.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 I don't know whether it is still acceptable to patch dontdiff,
 so I add Linus to CC list.

 Documentation/dontdiff | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/dontdiff b/Documentation/dontdiff
index 9de9813..8ea834f 100644
--- a/Documentation/dontdiff
+++ b/Documentation/dontdiff
@@ -165,7 +165,6 @@ mach-types.h
 machtypes.h
 map
 map_hugetlb
-media
 mconf
 miboot*
 mk_elfconfig
-- 
1.8.5.6.2.g3d8a54e.dirty
