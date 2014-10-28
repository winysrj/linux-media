Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46262 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaJ1PA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 11:00:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Fred Richter <frichter@hauppauge.com>
Subject: [PATCH 06/13] [media] lgdt3306a: Remove FSF address
Date: Tue, 28 Oct 2014 13:00:41 -0200
Message-Id: <d65bb8f2b7b68f6699d37f109c552da7dd468735.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this CodingStyle error:

	ERROR: Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so ag$
	#56: FILE: drivers/media/dvb-frontends/lgdt3306a.c:19:
	+ *    along with this program; if not, write to the Free Software$

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index d1a914de4180..54c2c282e97e 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -14,11 +14,6 @@
  *    but WITHOUT ANY WARRANTY; without even the implied warranty of
  *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *    GNU General Public License for more details.
- *
- *    You should have received a copy of the GNU General Public License
- *    along with this program; if not, write to the Free Software
- *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
  */
 
 #include <asm/div64.h>
@@ -1455,6 +1450,7 @@ static u32 lgdt3306a_calculate_snr_x100(struct lgdt3306a_state *state)
 
 static enum lgdt3306a_lock_status lgdt3306a_vsb_lock_poll(struct lgdt3306a_state *state)
 {
+	int ret;
 	u8 cnt = 0;
 	u8 packet_error;
 	u32 snr;
diff --git a/drivers/media/dvb-frontends/lgdt3306a.h b/drivers/media/dvb-frontends/lgdt3306a.h
index 0b020e743060..6d7daf6f52de 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.h
+++ b/drivers/media/dvb-frontends/lgdt3306a.h
@@ -13,11 +13,6 @@
  *    but WITHOUT ANY WARRANTY; without even the implied warranty of
  *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *    GNU General Public License for more details.
- *
- *    You should have received a copy of the GNU General Public License
- *    along with this program; if not, write to the Free Software
- *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
  */
 
 #ifndef _LGDT3306A_H_
-- 
1.9.3

