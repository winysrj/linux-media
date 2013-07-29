Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:21513 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3G2Mrj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 08:47:39 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r6TClZLj009651
	for <linux-media@vger.kernel.org>; Mon, 29 Jul 2013 12:47:35 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/1] qv4l2: Fixed a bug in the v4l2-api
Date: Mon, 29 Jul 2013 14:47:32 +0200
Message-Id: <1375102053-3603-1-git-send-email-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed a bug where the get_interval in v4l2-api where it would test for
a compatibility flag irrelevant to the feature support and resulting
return false.

