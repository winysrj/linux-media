Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55766 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab2ENWL2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 18:11:28 -0400
Received: by mail-qa0-f46.google.com with SMTP id b17so3179695qad.19
        for <linux-media@vger.kernel.org>; Mon, 14 May 2012 15:11:28 -0700 (PDT)
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, Michael Krufky <mkrufky@kernellabs.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 08/11] dvb-usb: add support for dvb-usb-adapters that deliver raw payload
Date: Mon, 14 May 2012 18:10:50 -0400
Message-Id: <1337033453-22119-8-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1337033453-22119-1-git-send-email-mkrufky@linuxtv.org>
References: <1337033453-22119-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michael Krufky <mkrufky@kernellabs.com>

Select this feature setting the dvb-usb-adapter caps field with
DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb/dvb-usb/dvb-usb-urb.c |   12 ++++++++++++
 drivers/media/dvb/dvb-usb/dvb-usb.h     |    1 +
 2 files changed, 13 insertions(+)

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
1.7.9.5

