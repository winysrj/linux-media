Return-path: <linux-media-owner@vger.kernel.org>
Received: from ven69-h01-31-33-9-98.dsl.sta.abo.bbox.fr ([31.33.9.98]:54259
	"EHLO laptop-kevin.kbaradon.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757221Ab3BXUqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Feb 2013 15:46:39 -0500
From: Kevin Baradon <kevin.baradon@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kevin Baradon <kevin.baradon@gmail.com>
Subject: [PATCH 0/2] Improve imon LCD/VFD driver to better support 15c2:0036
Date: Sun, 24 Feb 2013 21:19:28 +0100
Message-Id: <1361737170-4687-1-git-send-email-kevin.baradon@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Please find those two short patches to improve support of (at least) 15c2:0036 imon device.
These apply on latest git and were tested on 3.7.8 and 3.7.9 kernels.

Thanks.

Kevin Baradon (2):
  media/rc/imon.c: make send_packet() delay configurable
  media/rc/imon.c: avoid flooding syslog with "unknown keypress" when keypad is pressed

 drivers/media/rc/imon.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

-- 
1.7.10.4

