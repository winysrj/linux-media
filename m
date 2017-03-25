Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:43543 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751284AbdCYMC6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Mar 2017 08:02:58 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/8] [media] staging: sir: fix checkpatch strict warnings
Date: Sat, 25 Mar 2017 12:02:21 +0000
Message-Id: <265367ff24ffa9280cceff67e216962470c8405b.1490443026.git.sean@mess.org>
In-Reply-To: <cover.1490443026.git.sean@mess.org>
References: <cover.1490443026.git.sean@mess.org>
In-Reply-To: <cover.1490443026.git.sean@mess.org>
References: <cover.1490443026.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the code more readable and clean up the includes list.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/staging/media/lirc/lirc_sir.c | 46 ++++++-----------------------------
 1 file changed, 8 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index ec5a3c7..3a2bac9 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -9,15 +9,6 @@
  *  the Free Software Foundation; either version 2 of the License, or
  *  (at your option) any later version.
  *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
  *
  * 2000/09/16 Frank Przybylski <mail@frankprzybylski.de> :
  *  added timeout and relaxed pulse detection, removed gap bug
@@ -36,38 +27,23 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/sched/signal.h>
-#include <linux/errno.h>
-#include <linux/signal.h>
-#include <linux/fs.h>
 #include <linux/interrupt.h>
-#include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/serial_reg.h>
 #include <linux/ktime.h>
-#include <linux/string.h>
-#include <linux/types.h>
-#include <linux/wait.h>
-#include <linux/mm.h>
 #include <linux/delay.h>
-#include <linux/poll.h>
-#include <linux/io.h>
-#include <asm/irq.h>
-#include <linux/fcntl.h>
 #include <linux/platform_device.h>
 
-#include <linux/timer.h>
-
 #include <media/rc-core.h>
 
 /* SECTION: Definitions */
 #define PULSE '['
 
 /* 9bit * 1s/115200bit in milli seconds = 78.125ms*/
-#define TIME_CONST (9000000ul/115200ul)
+#define TIME_CONST (9000000ul / 115200ul)
 
 /* timeout for sequences in jiffies (=5/100s), must be longer than TIME_CONST */
-#define SIR_TIMEOUT	(HZ*5/100)
+#define SIR_TIMEOUT	(HZ * 5 / 100)
 
 /* onboard sir ports are typically com3 */
 static int io = 0x3e8;
@@ -117,7 +93,7 @@ static inline void soutp(int offset, int value)
 #ifndef MAX_UDELAY_MS
 #define MAX_UDELAY_US 5000
 #else
-#define MAX_UDELAY_US (MAX_UDELAY_MS*1000)
+#define MAX_UDELAY_US (MAX_UDELAY_MS * 1000)
 #endif
 
 static void safe_udelay(unsigned long usecs)
@@ -241,18 +217,12 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
 	int iir, lsr;
 
 	while ((iir = inb(io + UART_IIR) & UART_IIR_ID)) {
-		switch (iir&UART_IIR_ID) { /* FIXME toto treba preriedit */
+		switch (iir & UART_IIR_ID) { /* FIXME toto treba preriedit */
 		case UART_IIR_MSI:
-			(void) inb(io + UART_MSR);
+			(void)inb(io + UART_MSR);
 			break;
 		case UART_IIR_RLSI:
-			(void) inb(io + UART_LSR);
-			break;
-		case UART_IIR_THRI:
-#if 0
-			if (lsr & UART_LSR_THRE) /* FIFO is empty */
-				outb(data, io + UART_TX)
-#endif
+			(void)inb(io + UART_LSR);
 			break;
 		case UART_IIR_RDI:
 			/* avoid interference with timer */
@@ -293,7 +263,7 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
 					 * the other case is timeout
 					 */
 					add_read_queue(last_value,
-						       delt-TIME_CONST);
+						       delt - TIME_CONST);
 					last_value = data;
 					last = curr_time;
 					last = ktime_sub_us(last,
@@ -362,7 +332,7 @@ static int init_hardware(void)
 	/* outb(UART_IER_RLSI|UART_IER_RDI|UART_IER_THRI, io + UART_IER); */
 	outb(UART_IER_RDI, io + UART_IER);
 	/* turn on UART */
-	outb(UART_MCR_DTR|UART_MCR_RTS|UART_MCR_OUT2, io + UART_MCR);
+	outb(UART_MCR_DTR | UART_MCR_RTS | UART_MCR_OUT2, io + UART_MCR);
 	spin_unlock_irqrestore(&hardware_lock, flags);
 	return 0;
 }
-- 
2.9.3
