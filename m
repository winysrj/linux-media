Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:4420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555Ab0KLNbQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 08:31:16 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oACDVFVg008413
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 12 Nov 2010 08:31:16 -0500
Received: from pedra (vpn-229-188.phx2.redhat.com [10.3.229.188])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oACDTBbZ004220
	for <linux-media@vger.kernel.org>; Fri, 12 Nov 2010 08:31:15 -0500
Date: Fri, 12 Nov 2010 11:28:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] Fix i2c support for IR's on cx231xx
Message-ID: <20101112112839.621d3548@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Those two patches fix cx231xx-input, for I2C-based IR devices. They basically
allow caller drivers to pass a rc_dev pointer via platform_data, making it
possible to set other fields that are needed to be set by caller drivers.

Mauro Carvalho Chehab (2):
  [media] ir-kbd-i2c: add rc_dev as a parameter to the driver
  [media] cx231xx: Fix i2c support at cx231xx-input

 drivers/media/video/cx231xx/Kconfig         |    2 +-
 drivers/media/video/cx231xx/cx231xx-input.c |   55 ++++++++------------------
 drivers/media/video/cx231xx/cx231xx.h       |   21 +----------
 drivers/media/video/ir-kbd-i2c.c            |   45 ++++++++++++++++------
 include/media/ir-kbd-i2c.h                  |    2 +
 5 files changed, 54 insertions(+), 71 deletions(-)

