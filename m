Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52778 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbbGIEGz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2015 00:06:55 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/12] a8293: coding style issues
Date: Thu,  9 Jul 2015 07:06:25 +0300
Message-Id: <1436414792-9716-5-git-send-email-crope@iki.fi>
In-Reply-To: <1436414792-9716-1-git-send-email-crope@iki.fi>
References: <1436414792-9716-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove FSF address from license. Indent parameter correctly.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/a8293.c | 6 +-----
 drivers/media/dvb-frontends/a8293.h | 4 ----
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/a8293.c b/drivers/media/dvb-frontends/a8293.c
index ef2b47c..1923133 100644
--- a/drivers/media/dvb-frontends/a8293.c
+++ b/drivers/media/dvb-frontends/a8293.c
@@ -12,10 +12,6 @@
  *    but WITHOUT ANY WARRANTY; without even the implied warranty of
  *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *    GNU General Public License for more details.
- *
- *    You should have received a copy of the GNU General Public License along
- *    with this program; if not, write to the Free Software Foundation, Inc.,
- *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
 #include "a8293.h"
@@ -26,7 +22,7 @@ struct a8293_dev {
 };
 
 static int a8293_set_voltage(struct dvb_frontend *fe,
-	enum fe_sec_voltage fe_sec_voltage)
+			     enum fe_sec_voltage fe_sec_voltage)
 {
 	struct a8293_dev *dev = fe->sec_priv;
 	struct i2c_client *client = dev->client;
diff --git a/drivers/media/dvb-frontends/a8293.h b/drivers/media/dvb-frontends/a8293.h
index aa07b68..7b90a03 100644
--- a/drivers/media/dvb-frontends/a8293.h
+++ b/drivers/media/dvb-frontends/a8293.h
@@ -12,10 +12,6 @@
  *    but WITHOUT ANY WARRANTY; without even the implied warranty of
  *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *    GNU General Public License for more details.
- *
- *    You should have received a copy of the GNU General Public License along
- *    with this program; if not, write to the Free Software Foundation, Inc.,
- *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
 #ifndef A8293_H
-- 
http://palosaari.fi/

