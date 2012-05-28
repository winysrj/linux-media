Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:35101 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2E1REN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 13:04:13 -0400
Date: Mon, 28 May 2012 19:04:07 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] gspca - ov534/ov534_9: Fix sccd_read/write errors
Message-ID: <20120528190407.463f7d6e@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov534 bridge is too slow to handle the sensor accesses
requested by fast hosts giving 'sccb_reg_write failed'.
A small delay fixes the problem.

Signed-off-by: Jean-François Moine <moinejf@free.fr>
---
 drivers/media/video/gspca/ov534.c   |    1 +
 drivers/media/video/gspca/ov534_9.c |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/video/gspca/ov534.c b/drivers/media/video/gspca/ov534.c
index b5acb1e..d5a7873 100644
--- a/drivers/media/video/gspca/ov534.c
+++ b/drivers/media/video/gspca/ov534.c
@@ -851,6 +851,7 @@ static int sccb_check_status(struct gspca_dev *gspca_dev)
 	int i;
 
 	for (i = 0; i < 5; i++) {
+		msleep(10);
 		data = ov534_reg_read(gspca_dev, OV534_REG_STATUS);
 
 		switch (data) {
diff --git a/drivers/media/video/gspca/ov534_9.c b/drivers/media/video/gspca/ov534_9.c
index e6601b8..0120f94 100644
--- a/drivers/media/video/gspca/ov534_9.c
+++ b/drivers/media/video/gspca/ov534_9.c
@@ -1008,6 +1008,7 @@ static int sccb_check_status(struct gspca_dev *gspca_dev)
 	int i;
 
 	for (i = 0; i < 5; i++) {
+		msleep(10);
 		data = reg_r(gspca_dev, OV534_REG_STATUS);
 
 		switch (data) {
-- 
1.7.10

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
