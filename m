Return-path: <mchehab@pedra>
Received: from rcsinet10.oracle.com ([148.87.113.121]:36655 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab1C1PXY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2011 11:23:24 -0400
Date: Mon, 28 Mar 2011 08:23:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-media@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"Igor M. Liplianin" <liplianin@netup.ru>
Subject: Fw: [PATCH -next RESEND/still needed] staging: altera-jtag needs
 delay.h
Message-Id: <20110328082305.c6fa41d9.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Randy Dunlap <randy.dunlap@oracle.com>

altera-jtag.c needs to include <linux/delay.h> to fix a build error:

drivers/staging/altera-stapl/altera-jtag.c:398: error: implicit declaration of function 'udelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Igor M. Liplianin <liplianin@netup.ru>
---
 drivers/staging/altera-stapl/altera-jtag.c |    1 +
 1 file changed, 1 insertion(+)

Somehow I was supposed to know to send this to Mauro instead of to Greg,
but I don't see anything in drivers/staging/altera-stapl/ that says that.


--- linux-next-20110304.orig/drivers/staging/altera-stapl/altera-jtag.c
+++ linux-next-20110304/drivers/staging/altera-stapl/altera-jtag.c
@@ -23,6 +23,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/slab.h>
 #include <staging/altera.h>
--
