Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:33306 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383AbaKXJhh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 04:37:37 -0500
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 2F4FF2A0085
	for <linux-media@vger.kernel.org>; Mon, 24 Nov 2014 10:37:28 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/6] add device_caps support to querycap
Date: Mon, 24 Nov 2014 10:37:20 +0100
Message-Id: <1416821846-7677-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds missing device_caps support to the VIDIOC_QUERYCAP
implementations of drivers that are missing this.

After this series there are still 6 drivers left to do, but those need a
bit more thought.

Regards,

	Hans

