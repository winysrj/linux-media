Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4674 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaBJKCT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 05:02:19 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id s1AA2FWD002424
	for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 11:02:17 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.cisco.com (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C75A92A00A8
	for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 11:01:50 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH for 3.14 0/2] 3.14 Fixes
Date: Mon, 10 Feb 2014 11:01:47 +0100
Message-Id: <1392026509-48039-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One fixing si4713 Kconfig dependencies, one fixing a nasty vb2 regression.
The last patch was part of my vb2 patch series I posted earlier, but this
one really should go to 3.14.

Regards,

	Hans

