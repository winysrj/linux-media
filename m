Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4497 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab2E1Kqw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 06:46:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>
Subject: [RFCv2 PATCH 0/5] Add hwseek caps and frequency bands
Date: Mon, 28 May 2012 12:46:39 +0200
Message-Id: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v1:

- Fixed typo in second patch
- Patch 5 now only contains the part about frequency bands
- Patch 6 contains only (I hope) a non-controversial clarification
regarding modulators (and a small change making a line more understandable).

Regards,

	Hans

This patch series adds improved hwseek support as discussed here:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg45957.html

and on irc:

http://linuxtv.org/irc/v4l/index.php?date=2012-05-26

>From the RFC I have implemented/documented items 1-4 and 6a. I decided
not to go with option 6b. This may be added in the future if there is a
clear need.

The addition of the frequency band came out of this discussion:

http://www.spinics.net/lists/linux-media/msg48272.html

Regards,

        Hans

