Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:45551 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809AbaLANLC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 08:11:02 -0500
Received: from tschai.cisco.com (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 09D9D2A008F
	for <linux-media@vger.kernel.org>; Mon,  1 Dec 2014 14:10:46 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/4] Media cleanups
Date: Mon,  1 Dec 2014 14:10:41 +0100
Message-Id: <1417439445-34862-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series:

- Removes all the emacs editor variables in sources.
- Stops drivers from using the debug field in struct video_device.
  This field is internal to the v4l2 core and drivers shouldn't
  set it.
- Improve debug flag handling.
- Document the debug attribute.

Regards,

	Hans

