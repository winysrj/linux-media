Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38622 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab1G1PFI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 11:05:08 -0400
Message-ID: <4E317AA3.4090009@iki.fi>
Date: Thu, 28 Jul 2011 18:05:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Thomas Gutzler <thomas.gutzler@gmail.com>
Subject: [PATCH 1/2] af9015: map remote for Leadtek WinFast DTV2000DS
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks to Thomas Gutzler for reporting this.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Cc: Thomas Gutzler <thomas.gutzler@gmail.com>
---
  drivers/media/dvb/dvb-usb/af9015.c |    2 ++
  1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c 
b/drivers/media/dvb/dvb-usb/af9015.c
index d7ad05f..1fb8248 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -758,6 +758,8 @@ static const struct af9015_rc_setup 
af9015_rc_setup_usbids[] = {
  		RC_MAP_MSI_DIGIVOX_III },
  	{ (USB_VID_LEADTEK << 16) + USB_PID_WINFAST_DTV_DONGLE_GOLD,
  		RC_MAP_LEADTEK_Y04G0051 },
+	{ (USB_VID_LEADTEK << 16) + USB_PID_WINFAST_DTV2000DS,
+		RC_MAP_LEADTEK_Y04G0051 },
  	{ (USB_VID_AVERMEDIA << 16) + USB_PID_AVERMEDIA_VOLAR_X,
  		RC_MAP_AVERMEDIA_M135A },
  	{ (USB_VID_AFATECH << 16) + USB_PID_TREKSTOR_DVBT,
-- 
1.7.6

-- 
http://palosaari.fi/
