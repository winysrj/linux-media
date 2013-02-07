Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3618 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab3BGMiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 07:38:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFC PATCHv2 18/18] tlg2300: update MAINTAINERS file.
Date: Thu, 7 Feb 2013 13:38:11 +0100
Cc: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302071338.12025.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove two maintainers: telegent.com no longer exists, so those email
addresses are invalid as well.

Added myself as co-maintainer and change the status to 'Odd Fixes'.

Changes since v1: Added myself as co-maintainer and change the status to
'Odd Fixes'.

Huang: can you Ack this? Once patches 01/18 and 18/18 are Acked I will post
a pull request for this whole series (patches 02-17 are unchanged so I'm
not reposting them).

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5334229..9a83a1c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6794,9 +6794,8 @@ F:	drivers/clocksource
 
 TLG2300 VIDEO4LINUX-2 DRIVER
 M:	Huang Shijie <shijie8@gmail.com>
-M:	Kang Yong <kangyong@telegent.com>
-M:	Zhang Xiaobing <xbzhang@telegent.com>
-S:	Supported
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+S:	Odd Fixes
 F:	drivers/media/usb/tlg2300
 
 SC1200 WDT DRIVER
-- 
1.7.10.4

