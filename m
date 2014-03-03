Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49484 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbaCCKIL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:11 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 24/79] [media] drx-j: Don't use buffer if an error occurs
Date: Mon,  3 Mar 2014 07:06:18 -0300
Message-Id: <1393841233-24840-25-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/drx39xyj/drxj.c: In function ‘drxj_dap_scu_atomic_read_reg16’:
drivers/media/dvb-frontends/drx39xyj/drxj.c:4170:9: warning: ‘*((void *)&buf+1)’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  word = (u16) (buf[0] + (buf[1] << 8));
         ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:4170:9: warning: ‘buf’ may be used uninitialized in this function [-Wmaybe-uninitialized]
drivers/media/dvb-frontends/drx39xyj/drxj.c: In function ‘drxj_dap_atomic_read_reg32.isra.59’:
drivers/media/dvb-frontends/drx39xyj/drxj.c:2186:7: warning: ‘*((void *)&buf+3)’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  word = (u32) buf[3];
       ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:2188:10: warning: ‘*((void *)&buf+2)’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  word |= (u32) buf[2];
          ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:2190:10: warning: ‘*((void *)&buf+1)’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  word |= (u32) buf[1];
          ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:2192:10: warning: ‘buf’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  word |= (u32) buf[0];
          ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index bb67edeb5121..d51cea9bc5eb 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -2183,6 +2183,9 @@ int drxj_dap_atomic_read_reg32(struct i2c_device_addr *dev_addr,
 	rc = drxj_dap_atomic_read_write_block(dev_addr, addr,
 					   sizeof(*data), buf, true);
 
+	if (rc < 0)
+		return 0;
+
 	word = (u32) buf[3];
 	word <<= 8;
 	word |= (u32) buf[2];
@@ -4166,6 +4169,8 @@ int drxj_dap_scu_atomic_read_reg16(struct i2c_device_addr *dev_addr,
 	}
 
 	rc = drxj_dap_scu_atomic_read_write_block(dev_addr, addr, 2, buf, true);
+	if (rc < 0)
+		return rc;
 
 	word = (u16) (buf[0] + (buf[1] << 8));
 
-- 
1.8.5.3

