Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:8838 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab3HINGc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 09:06:32 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-90.cisco.com [10.54.92.90])
	by ams-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id r79D6TlP013742
	for <linux-media@vger.kernel.org>; Fri, 9 Aug 2013 13:06:29 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] qv4l2: fix GeneralTab layout
Date: Fri,  9 Aug 2013 15:03:21 +0200
Message-Id: <1376053402-28300-1-git-send-email-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleans up the layout of GeneralTab.
Also removes a single debug printout from original ALSA source.
The debug was in a corner case and will most likely not be noticed
there anyway, but is now removed.

