Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:56045 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841Ab3HHNrt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 09:47:49 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-90.cisco.com [10.54.92.90])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r78Dlk9l032678
	for <linux-media@vger.kernel.org>; Thu, 8 Aug 2013 13:47:46 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] qv4l2: fix input parameters and missing status tips
Date: Thu,  8 Aug 2013 15:47:36 +0200
Message-Id: <1375969658-20415-1-git-send-email-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Fixes some of the missing status tips in the general tab.
- Fixes the frequency hint, now displaying correct value hints.
- Fixes the program parameters.

