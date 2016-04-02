Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:45167 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbcDBRm7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2016 13:42:59 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-renesas-soc@vger.kernel.org, lars@metafoo.de,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 0/3] [media] adv7180: Add more operations
Date: Sat,  2 Apr 2016 19:42:17 +0200
Message-Id: <1459618940-8170-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add more operations to allow for the user to read the std and supported
tvnorms. Also expose the pixel aspect ratio using the cropcap operation.

These operations where developed in conjuctin with the new rcar-vin
drvier that is posted in a separat patch. It is also that driver I have
used to test this series.

Niklas Söderlund (3):
  [media] adv7180: Add g_std operation
  [media] adv7180: Add cropcap operation
  [media] adv7180: Add g_tvnorms operation

 drivers/media/i2c/adv7180.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

--
2.7.4

