Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:47617 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751366AbeBVVYM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 16:24:12 -0500
To: linux-media@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Klimov <klimov.linux@gmail.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Johan Hovold <johan@kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Peter Rosin <peda@axentia.se>,
        Romain Reignier <r.reignier@robopec.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Sean Young <sean@mess.org>,
        Wei Yongjun <weiyongjun1@huawei.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2] [media] Delete unnecessary variable initialisations in
 seven functions
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <45c87e6b-9e01-eb5c-3c47-5aa6dcabb004@users.sourceforge.net>
Date: Thu, 22 Feb 2018 22:22:43 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 22 Feb 2018 21:45:47 +0100

Some local variables will be set to an appropriate value before usage.
Thus omit explicit initialisations at the beginning of these functions.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---

v2:
Hans Verkuil insisted on patch squashing. Thus some changes
were recombined based on source files from Linux next-20180216.

 drivers/media/radio/radio-mr800.c             | 2 +-
 drivers/media/radio/radio-wl1273.c            | 2 +-
 drivers/media/radio/si470x/radio-si470x-usb.c | 2 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c     | 2 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c       | 2 +-
 drivers/media/usb/go7007/snd-go7007.c         | 2 +-
 drivers/media/usb/tm6000/tm6000-cards.c       | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index dc6c4f985911..0f292c6ba338 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -511,5 +511,5 @@ static int usb_amradio_probe(struct usb_interface *intf,
 				const struct usb_device_id *id)
 {
 	struct amradio_device *radio;
-	int retval = 0;
+	int retval;
 
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 58e944591602..8f9f8dfc3497 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -671,6 +671,6 @@ static int wl1273_fm_start(struct wl1273_device *radio, int new_mode)
 static int wl1273_fm_suspend(struct wl1273_device *radio)
 {
 	struct wl1273_core *core = radio->core;
-	int r = 0;
+	int r;
 
 	/* Cannot go from OFF to SUSPENDED */
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index c311f9951d80..2277e850bb5e 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -578,6 +578,6 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 	struct si470x_device *radio;
 	struct usb_host_interface *iface_desc;
 	struct usb_endpoint_descriptor *endpoint;
-	int i, int_end_size, retval = 0;
+	int i, int_end_size, retval;
 	unsigned char version_warning = 0;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index f9ec7fedcd5b..14e3814f55d9 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1135,6 +1135,6 @@ static void cx231xx_config_tuner(struct cx231xx *dev)
 static int read_eeprom(struct cx231xx *dev, struct i2c_client *client,
 		       u8 *eedata, int len)
 {
-	int ret = 0;
+	int ret;
 	u8 start_offset = 0;
 	int len_todo = len;
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index fb5654062b1a..24ca011c49bb 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -604,6 +604,6 @@ static void unregister_dvb(struct cx231xx_dvb *dvb)
 
 static int dvb_init(struct cx231xx *dev)
 {
-	int result = 0;
+	int result;
 	struct cx231xx_dvb *dvb;
 	struct i2c_adapter *tuner_i2c;
diff --git a/drivers/media/usb/go7007/snd-go7007.c b/drivers/media/usb/go7007/snd-go7007.c
index c618764480c6..f84a2130f033 100644
--- a/drivers/media/usb/go7007/snd-go7007.c
+++ b/drivers/media/usb/go7007/snd-go7007.c
@@ -227,7 +227,7 @@ int go7007_snd_init(struct go7007 *go)
 {
 	static int dev;
 	struct go7007_snd *gosnd;
-	int ret = 0;
+	int ret;
 
 	if (dev >= SNDRV_CARDS)
 		return -ENODEV;
diff --git a/drivers/media/usb/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
index 4d5f4cc4887e..70939e96b856 100644
--- a/drivers/media/usb/tm6000/tm6000-cards.c
+++ b/drivers/media/usb/tm6000/tm6000-cards.c
@@ -1174,7 +1174,7 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 {
 	struct usb_device *usbdev;
 	struct tm6000_core *dev;
-	int i, rc = 0;
+	int i, rc;
 	int nr = 0;
 	char *speed;
 
-- 
2.16.2
