Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:53444 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2JBI5d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 04:57:33 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH 0/3] Three more patches to fix const issues
Date: Tue,  2 Oct 2012 10:57:17 +0200
Message-Id: <1349168240-29269-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several ioctl ops now use const, but there was some fall-out from that
in drivers. Most drivers already have patches pending fixing such issues,
but I didn't see any for these three.

Regards,

	Hans

