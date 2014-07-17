Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4711 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758651AbaGQXkj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 19:40:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	pete@sensoray.com
Subject: [PATCH for v3.17 0/4] Move go7007 and solo6x10 out of staging
Date: Fri, 18 Jul 2014 01:40:19 +0200
Message-Id: <1405640423-1037-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The compound control support was merged and that allowed the motion
detection support to be merged as well. So there is nothing keeping these
two drivers in staging.

This patch series moves them to drivers/media.

One note: the go7007 supports an saa7134+go7007 based board as well and
a patch for saa7134 was available in the README file. However, after
the recent vb2 conversion of saa7134 that no longer applies (no surprise
there).

I plan on fixing that, but that's just a single board so that doesn't
stand in the way of getting the driver out of staging.

Regards,

	Hans

