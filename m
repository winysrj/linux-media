Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:48463 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711AbaLAJEP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 04:04:15 -0500
Received: from tschai.cisco.com (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 1782A2A01A8
	for <linux-media@vger.kernel.org>; Mon,  1 Dec 2014 10:03:55 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv3 0/9] Improve colorspace support
Date: Mon,  1 Dec 2014 10:03:44 +0100
Message-Id: <1417424633-15781-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v2:

- Use symbolic constants from linux/hdmi.h in adv7511.
- Renamed V4L2_YCBCR_ENC_BT2020NC to V4L2_YCBCR_ENC_BT2020 and
  V4L2_YCBCR_ENC_BT2020C to V4L2_YCBCR_ENC_BT2020_CONST_LUM to be
  consistent with the proposed hdmi.h changes:

  https://www.mail-archive.com/linux-media@vger.kernel.org/msg82422.html

See the cover letter of v2 for more information:
http://www.spinics.net/lists/linux-media/msg83709.html

I'll make a pull request for this series as well.

Regards,

        Hans


