Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63893 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759674Ab1LOWnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 17:43:55 -0500
Received: by wgbdr13 with SMTP id dr13so4842399wgb.1
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 14:43:54 -0800 (PST)
Message-ID: <1323989024.21705.16.camel@tvbox>
Subject: [PATCH] it913x changed firmware loader for chip version 2 types
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Adrian N <adexmail@tlen.pl>
Date: Thu, 15 Dec 2011 22:43:44 +0000
In-Reply-To: <1323967323.2273.17.camel@tvbox>
References: <1323719580.2235.3.camel@tvbox>
	 <loom.20111214T071004-336@post.gmane.org> <4EEA16BA.4070209@tlen.pl>
	 <1323967323.2273.17.camel@tvbox>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2011-12-15 at 16:42 +0000, Malcolm Priestley wrote:
> > [ 1103.536156] it913x: Chip Version=ec Chip Type=5830
> > [ 1104.336178] it913x: Dual mode=92 Remote=92 Tuner Type=92
> > [ 1106.248116] dvb-usb: found a 'ITE 9135(9006) Generic' in cold state, 
> > will try to load a firmware
> > [ 1106.253773] dvb-usb: downloading firmware from file 
> > 'dvb-usb-it9135-02.fw'
> > [ 1106.452123] it913x: FRM Starting Firmware Download
> > [ 1130.756039] it913x: FRM Firmware Download Failed (ffffff92)
> > [ 1130.956168] it913x: Chip Version=79 Chip Type=5823
> > [ 1131.592192] it913x: DEV it913x Error
> > [ 1131.592271] usbcore: registered new interface driver it913x
> > 
> > No frontend is generated anyway.
> 
> Looks like the the firmware is not at all compatible with your device.
> 
> Have you applied the patch cleanly to the latest media_build?
> 
> These appear to be new version of the 9006. A supplier is sending me one
> of these devices.
> 
> As a last resort see if the device works with dvb-usb-it9137-01.fw
> 
> You will have force to use this firmware
> dvb-usb-it913x firmware=1

Here is a modified firmware loader for version 2 types.

The firmware must be as in original
./dvb_get_firmware it9135
 

dd if=dvb-usb-it9135.fw ibs=1 skip=12866 count=5817 of=dvb-usb-it9135-02.fw


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 6f6072b..9290bd8 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -557,7 +557,7 @@ static int it913x_download_firmware(struct usb_device *udev,
 					const struct firmware *fw)
 {
 	int ret = 0, i = 0, pos = 0;
-	u8 packet_size;
+	u8 packet_size, min_pkt;
 	u8 *fw_data;
 
 	ret = it913x_wr_reg(udev, DEV_0,  I2C_CLK, I2C_CLK_100);
@@ -569,11 +569,16 @@ static int it913x_download_firmware(struct usb_device *udev,
 	/* The firmware must start with 03 XX 00 */
 	/* and be the extact firmware length */
 
+	if (it913x_config.chip_ver == 2)
+		min_pkt = 0x11;
+	else
+		min_pkt = 0x19;
+
 	while (i <= fw->size) {
 		if (((fw->data[i] == 0x3) && (fw->data[i + 2] == 0x0))
 			|| (i == fw->size)) {
 			packet_size = i - pos;
-			if ((packet_size > 0x19) || (i == fw->size)) {
+			if ((packet_size > min_pkt) || (i == fw->size)) {
 				fw_data = (u8 *)(fw->data + pos);
 				pos += packet_size;
 				if (packet_size > 0)
-- 
1.7.7.3





