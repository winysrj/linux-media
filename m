Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3412 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab1FNHOv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 03:14:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>
Subject: [RFCv6 PATCH 00/10] tuner-core: fix g_freq/s_std and g/s_tuner
Date: Tue, 14 Jun 2011 09:14:32 +0200
Message-Id: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Changes from RFCv5:

- The first patch didn't set set_freq after set_mode in the case of TV.
- Added a new patch that checks the tuner type for S_HW_FREQ_SEEK.
- Moved the feature-removal patch to the front so the first 6 patches
  are all for v3.0.

I will do some more testing today and if there are no more more issues
I'll make a pull request.

Regards,

	Hans

