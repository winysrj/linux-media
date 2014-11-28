Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38495 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555AbaK1OvA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 09:51:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
	marbugge@cisco.com, dri-devel@lists.freedesktop.org
Subject: [PATCH 0/3] hdmi: add unpack and logging functions
Date: Fri, 28 Nov 2014 15:50:48 +0100
Message-Id: <1417186251-6542-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds new HDMI 2.0/CEA-861-F defines to hdmi.h and
adds unpacking and logging functions to hdmi.c. It also uses those
in the V4L2 adv7842 driver (and they will be used in other HDMI drivers
once this functionality is merged).

Patches 2 and 3 have been posted before by Martin Bugge. It stalled, but
I am taking over from Martin to try and get this is. I want to use this
in a bunch of v4l2 drivers, so I would really like to see this merged.

Please let me know if there are things that need to be addressed in
these patches before they can be merged.

Regards,

	Hans

