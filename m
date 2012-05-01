Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49271 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2EAEMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 00:12:49 -0400
Received: by mail-vb0-f46.google.com with SMTP id ff1so2558685vbb.19
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2012 21:12:49 -0700 (PDT)
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 08/10] dvb-usb: add support for dvb-usb-adapters that deliver raw payload
Date: Tue,  1 May 2012 00:12:23 -0400
Message-Id: <1335845545-20879-8-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org>
References: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michael Krufky <mkrufky@kernellabs.com>

Select this feature setting the dvb-usb-adapter caps field with
DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb/dvb-usb/dvb-usb-urb.c |   12 ++++++++++++
 drivers/media/dvb/dvb-usb/dvb-usb.h     |    1 +
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-urb.c b/drivers/media/dvb/dvb-usb/dvb-usb-urb.c
index 53a5c30..5c8f651 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-urb.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-urb.c
@@ -80,6 +80,14 @@ static void dvb_usb_data_complete_204(struct usb_data_stream *stream, u8 *buffer
 		dvb_dmx_swfilter_204(&adap->demux, buffer, length);
 }
 
+static void dvb_usb_data_complete_raw(struct usb_data_stream *stream,
+				      u8 *buffer, size_t length)
+{
+	struct dvb_usb_adapter *adap = stream->user_priv;
+	if (adap->feedcount > 0 && adap->state & DVB_USB_ADAP_STATE_DVB)
+		dvb_dmx_swfilter_raw(&adap->demux, buffer, length);
+}
+
 int dvb_usb_adapter_stream_init(struct dvb_usb_adapter *adap)
 {
 	int i, ret = 0;
@@ -90,6 +98,10 @@ int dvb_usb_adapter_stream_init(struct dvb_usb_adapter *adap)
 			adap->fe_adap[i].stream.complete =
 				dvb_usb_data_complete_204;
 		else
+		if (adap->props.fe[i].caps & DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD)
+			adap->fe_adap[i].stream.complete =
+				dvb_usb_data_complete_raw;
+		else
 		adap->fe_adap[i].stream.complete  = dvb_usb_data_complete;
 		adap->fe_adap[i].stream.user_priv = adap;
 		ret = usb_urb_init(&adap->fe_adap[i].stream,
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 6d7d13f..86cfa86 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -141,6 +141,7 @@ struct dvb_usb_adapter_fe_properties {
 #define DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF 0x02
 #define DVB_USB_ADAP_NEED_PID_FILTERING           0x04
 #define DVB_USB_ADAP_RECEIVES_204_BYTE_TS         0x08
+#define DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD         0x10
 	int caps;
 	int pid_filter_count;
 
-- 
1.7.5.4

