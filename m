Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:5824 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab2GSMAw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 08:00:52 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [RFC PATCH 0/6] mem2mem_testdev: fix v4l2-compliance errors
Date: Thu, 19 Jul 2012 14:00:18 +0200
Message-Id: <1342699224-12642-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch series updates mem2mem_testdev so all the modern features
are supported (mainly converting to the control framework and various
smaller odds 'n ends).

The last patch is actually in the V4L2 core, fixing an incorrect test.

Comments?

Regards,

	Hans

