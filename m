Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:33889 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab3GKJJR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 05:09:17 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Ming Lei <ming.lei@canonical.com>,
	Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 20/50] USB: serial: usb_wwan: spin_lock in complete() cleanup
Date: Thu, 11 Jul 2013 17:05:43 +0800
Message-Id: <1373533573-12272-21-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Complete() will be run with interrupt enabled, so change to
spin_lock_irqsave().

Cc: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/usb/serial/usb_wwan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 8257d30..c807d65 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -312,6 +312,7 @@ static void usb_wwan_outdat_callback(struct urb *urb)
 	struct usb_wwan_port_private *portdata;
 	struct usb_wwan_intf_private *intfdata;
 	int i;
+	unsigned long flags;
 
 	port = urb->context;
 	intfdata = port->serial->private;
@@ -319,9 +320,9 @@ static void usb_wwan_outdat_callback(struct urb *urb)
 	usb_serial_port_softint(port);
 	usb_autopm_put_interface_async(port->serial->interface);
 	portdata = usb_get_serial_port_data(port);
-	spin_lock(&intfdata->susp_lock);
+	spin_lock_irqsave(&intfdata->susp_lock, flags);
 	intfdata->in_flight--;
-	spin_unlock(&intfdata->susp_lock);
+	spin_unlock_irqrestore(&intfdata->susp_lock, flags);
 
 	for (i = 0; i < N_OUT_URB; ++i) {
 		if (portdata->out_urbs[i] == urb) {
-- 
1.7.9.5

