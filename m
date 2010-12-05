Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: add Technisat skystar usb plus USB-ID
Date: Sun, 05 Dec 2010 14:31:17 -0000
From: Halim Sahin <halim.sahin@freenet.de>
Message-Id: <20101205143116.GA1533@gentoo.local>
To: linux-media@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

this device is a rebranded Technotrend s-2400 with USB id 0x3009.
THx to Carsten Wehmeier for reporting

Signed-off-by: Halim Sahin <halim.sahin@freenet.de>

---
drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 192a40c..380066b 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -204,6 +204,7 @@
 #define USB_PID_AVERMEDIA_A805				0xa805
 #define USB_PID_AVERMEDIA_A815M				0x815a
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
+#define USB_PID_TECHNOTREND_CONNECT_S2400               0x3009
 #define USB_PID_TECHNOTREND_CONNECT_CT3650		0x300d
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2	0x0081
