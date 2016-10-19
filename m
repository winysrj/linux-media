Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.abbadie.fr ([37.187.122.32]:54513 "EHLO mail.abbadie.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938778AbcJSUrk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 16:47:40 -0400
From: Jean-Baptiste Abbadie <jb@abbadie.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Cc: Jean-Baptiste Abbadie <jb@abbadie.fr>
Subject: [PATCH 3/3] Staging: media: radio-bcm2048: Remove FSF address from GPL notice
Date: Wed, 19 Oct 2016 22:47:14 +0200
Message-Id: <20161019204714.11645-4-jb@abbadie.fr>
In-Reply-To: <20161019204714.11645-1-jb@abbadie.fr>
References: <20161019204714.11645-1-jb@abbadie.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removes the superfluous statement about writing to the FSF in the GPL
notice

Signed-off-by: Jean-Baptiste Abbadie <jb@abbadie.fr>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index f66bea631e8e..607dd5285149 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -17,10 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
  */
 
 /*
-- 
2.10.0

