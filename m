Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB28C282CC
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4728218FE
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfBGJNn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 04:13:43 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:33929 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726579AbfBGJNm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 04:13:42 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5])
        by smtp-cloud9.xs4all.net with ESMTPA
        id rfkYgHeo6RO5ZrfkagrP3r; Thu, 07 Feb 2019 10:13:40 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     sakari.ailus@linux.intel.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 1/6] hdpvr: fix smatch warning
Date:   Thu,  7 Feb 2019 10:13:33 +0100
Message-Id: <20190207091338.55705-2-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
References: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfAjd/7ltqEPSxaBb9dbLcekKaGTns7bLf0arAdM6etvugChb7Cwt41l1ho9UHofXm/ORxKFn//31Cpi41SRvi2NGHGUnVF0c8EW+5JyyjkhbwTr/bo5x
 3Wj5TNqIrlGBCf3NY6XnuQdmjhystB1yegIy3mMXL5Cn23q3VFm0Z0aSGtzK2cNmmv96Sdvgv5gB0SvA8GSRGKo2rKizXO/ndmFUJCiT4FCx5aBmLQGAgjJw
 meAiiX5Vz3UbZ5kQTKx8OHjpzp3nwptH5NJA3vYcfGjx90+GSol5zaG4JW2FcVqsPayIXo+UNbuJKuvUab8Xcitw8Ib+N2FMJ/vb5LrB8AQOffZVum5W3giY
 6X3+mqJjdPwykfCKHEYFfRmGXuF5CjMHM7r2bJEPn2wG0QgtqqB27bBM7RcPsEzRl3WV906I
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

drivers/media/usb/hdpvr/hdpvr-i2c.c: drivers/media/usb/hdpvr/hdpvr-i2c.c:78 hdpvr_i2c_read() warn: 'dev->i2c_buf' 4216624615462223872 can't fit into 127 '*data'

dev->i2c_buf is a char array, so you can just use dev->i2c_buf to get the
start address, no need to do &dev->i2c_buf, even though it is the same
address in C. It only confuses smatch.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/usb/hdpvr/hdpvr-i2c.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-i2c.c b/drivers/media/usb/hdpvr/hdpvr-i2c.c
index 5a3cb614a211..d76173f1ced1 100644
--- a/drivers/media/usb/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/usb/hdpvr/hdpvr-i2c.c
@@ -61,10 +61,10 @@ static int hdpvr_i2c_read(struct hdpvr_device *dev, int bus,
 		return -EINVAL;
 
 	if (wlen) {
-		memcpy(&dev->i2c_buf, wdata, wlen);
+		memcpy(dev->i2c_buf, wdata, wlen);
 		ret = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
 				      REQTYPE_I2C_WRITE, CTRL_WRITE_REQUEST,
-				      (bus << 8) | addr, 0, &dev->i2c_buf,
+				      (bus << 8) | addr, 0, dev->i2c_buf,
 				      wlen, 1000);
 		if (ret < 0)
 			return ret;
@@ -72,10 +72,10 @@ static int hdpvr_i2c_read(struct hdpvr_device *dev, int bus,
 
 	ret = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
 			      REQTYPE_I2C_READ, CTRL_READ_REQUEST,
-			      (bus << 8) | addr, 0, &dev->i2c_buf, len, 1000);
+			      (bus << 8) | addr, 0, dev->i2c_buf, len, 1000);
 
 	if (ret == len) {
-		memcpy(data, &dev->i2c_buf, len);
+		memcpy(data, dev->i2c_buf, len);
 		ret = 0;
 	} else if (ret >= 0)
 		ret = -EIO;
@@ -91,17 +91,17 @@ static int hdpvr_i2c_write(struct hdpvr_device *dev, int bus,
 	if (len > sizeof(dev->i2c_buf))
 		return -EINVAL;
 
-	memcpy(&dev->i2c_buf, data, len);
+	memcpy(dev->i2c_buf, data, len);
 	ret = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
 			      REQTYPE_I2C_WRITE, CTRL_WRITE_REQUEST,
-			      (bus << 8) | addr, 0, &dev->i2c_buf, len, 1000);
+			      (bus << 8) | addr, 0, dev->i2c_buf, len, 1000);
 
 	if (ret < 0)
 		return ret;
 
 	ret = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
 			      REQTYPE_I2C_WRITE_STATT, CTRL_READ_REQUEST,
-			      0, 0, &dev->i2c_buf, 2, 1000);
+			      0, 0, dev->i2c_buf, 2, 1000);
 
 	if ((ret == 2) && (dev->i2c_buf[1] == (len - 1)))
 		ret = 0;
-- 
2.20.1

