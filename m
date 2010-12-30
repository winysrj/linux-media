Return-path: <mchehab@gaivota>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4322 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab0L3OmO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 09:42:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Can VIDIOC_INT_RESET be removed?
Date: Thu, 30 Dec 2010 15:42:08 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012301542.08706.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Andy,

Is there still a reason to keep the VIDIOC_INT_RESET ioctl in cx18 and ivtv?
I seem to remember that you told me that they are no longer needed.

If so, then I'll make a patch removing this ioctl in the drivers and in v4l-utils.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
