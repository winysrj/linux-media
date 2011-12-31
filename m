Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34967 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1LaLPQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 06:15:16 -0500
Received: by eekc4 with SMTP id c4so14232508eek.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 03:15:15 -0800 (PST)
Message-ID: <4EFEEEB7.2020109@gmail.com>
Date: Sat, 31 Dec 2011 12:15:03 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH FOR 3.3] VIDIOC_LOG_STATUS support for sub-devices
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 3220eb73c5647af4c1f18e32c12dccb8adbac59d:

  s5p-fimc: Add support for alpha component configuration (2011-12-20 19:46:55
+0100)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-samsung v4l_mbus

This one patch enables VIDIOC_LOG_STATUS on subdev nodes.

Sylwester Nawrocki (1):
      v4l: Add VIDIOC_LOG_STATUS support for sub-device nodes

 drivers/media/video/v4l2-subdev.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

-- 
Regards,
Sylwester
