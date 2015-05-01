Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08lb.world4you.com ([81.19.149.118]:56750 "EHLO
	mx08lb.world4you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbbEBATF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2015 20:19:05 -0400
From: Thomas Reitmayr <treitmayr@devbase.at>
To: linux-media@vger.kernel.org
Cc: Thomas Reitmayr <treitmayr@devbase.at>
Subject: [PATCH] media: Fix regression in some more dib0700 based devices.
Date: Sat,  2 May 2015 01:18:04 +0200
Message-Id: <1430522284-9138-1-git-send-email-treitmayr@devbase.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix an oops during device initialization by correctly setting size_of_priv
instead of leaving it 0.
The regression was introduced by 8abe4a0a3f6d4217b16a ("[media] dib7000:
export just one symbol") and only fixed for one type of dib0700 based
devices in 9e334c75642b6e5bfb95 ("[media] Fix regression in some dib0700
based devices").

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=92301

Fixes: 8abe4a0a3f6d4217b16a ("[media] dib7000: export just one symbol")
Signed-off-by: Thomas Reitmayr <treitmayr@devbase.at>
---
 drivers/media/usb/dvb-usb/dib0700_devices.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 90cee38..e87ce83 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -3944,6 +3944,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
+				.size_of_priv = sizeof(struct
+						dib0700_adapter_state),
 			}, {
 			.num_frontends = 1,
 			.fe = {{
@@ -3956,6 +3958,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
 			}},
+				.size_of_priv = sizeof(struct
+						dib0700_adapter_state),
 			}
 		},
 
@@ -4009,6 +4013,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
+				.size_of_priv = sizeof(struct
+						dib0700_adapter_state),
 			},
 		},
 
-- 
2.1.4

