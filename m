Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60405 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab0IXOOj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 10:14:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pete Eberlein <pete@sensoray.com>,
	Mike Isely <isely@pobox.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Muralidharan Karicheri <mkaricheri@gmail.com>
Subject: [PATCH 04/16] go7007: Fix the TW2804 I2C type name
Date: Fri, 24 Sep 2010 16:14:02 +0200
Message-Id: <1285337654-5044-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The TW2804 I2C sub-device type name was incorrectly set to wis_twTW2804
for the adlink mpg24 board. Rename it to wis_tw2804.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/go7007/go7007-usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/go7007/go7007-usb.c b/drivers/staging/go7007/go7007-usb.c
index 20ed930..bea9f4d 100644
--- a/drivers/staging/go7007/go7007-usb.c
+++ b/drivers/staging/go7007/go7007-usb.c
@@ -394,7 +394,7 @@ static struct go7007_usb_board board_adlink_mpg24 = {
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
-				.type	= "wis_twTW2804",
+				.type	= "wis_tw2804",
 				.id	= I2C_DRIVERID_WIS_TW2804,
 				.addr	= 0x00, /* yes, really */
 			},
-- 
1.7.2.2

