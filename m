Return-path: <linux-media-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:40686 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759226AbbFBOnz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Jun 2015 10:43:55 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] rc: gpio-ir-recv: don't sleep in irq handler
Date: Tue, 02 Jun 2015 16:43:50 +0200
Message-ID: <1607281.RSg8CEJ1UJ@diego>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't allow sleep when getting the gpio value in the irq-handler.
On my rk3288 board this results in might_sleep warnings when receiving
data like:

BUG: sleeping function called from invalid context at drivers/gpio/gpiolib.c:1531
in_atomic(): 1, irqs_disabled(): 128, pid: 0, name: swapper/0
CPU: 0 PID: 0 Comm: swapper/0 Tainted: P                4.1.0-rc5+ #2011
Hardware name: Rockchip (Device Tree)
[<c00189a0>] (unwind_backtrace) from [<c0013b04>] (show_stack+0x20/0x24)
[<c0013b04>] (show_stack) from [<c0757970>] (dump_stack+0x8c/0xbc)
[<c0757970>] (dump_stack) from [<c0053188>] (___might_sleep+0x238/0x284)
[<c0053188>] (___might_sleep) from [<c0053264>] (__might_sleep+0x90/0xa4)
[<c0053264>] (__might_sleep) from [<c02ff4ac>] (gpiod_get_raw_value_cansleep+0x28/0x44)
[<c02ff4ac>] (gpiod_get_raw_value_cansleep) from [<bf0363c4>] (gpio_ir_recv_irq+0x24/0x6c [gpio_ir_recv])
[<bf0363c4>] (gpio_ir_recv_irq [gpio_ir_recv]) from [<c008a78c>] (handle_irq_event_percpu+0x164/0x550)
[<c008a78c>] (handle_irq_event_percpu) from [<c008abc4>] (handle_irq_event+0x4c/0x6c)
[<c008abc4>] (handle_irq_event) from [<c008df88>] (handle_edge_irq+0x128/0x150)
[<c008df88>] (handle_edge_irq) from [<c0089edc>] (generic_handle_irq+0x30/0x40)
[<c0089edc>] (generic_handle_irq) from [<c02fc4cc>] (rockchip_irq_demux+0x158/0x210)
[<c02fc4cc>] (rockchip_irq_demux) from [<c0089edc>] (generic_handle_irq+0x30/0x40)
[<c0089edc>] (generic_handle_irq) from [<c008a058>] (__handle_domain_irq+0x98/0xc0)
[<c008a058>] (__handle_domain_irq) from [<c00094a4>] (gic_handle_irq+0x4c/0x70)
[<c00094a4>] (gic_handle_irq) from [<c0014684>] (__irq_svc+0x44/0x5c)

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/media/rc/gpio-ir-recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 229853d..e4d43cc 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -78,7 +78,7 @@ static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
 	int rc = 0;
 	enum raw_event_type type = IR_SPACE;
 
-	gval = gpio_get_value_cansleep(gpio_dev->gpio_nr);
+	gval = gpio_get_value(gpio_dev->gpio_nr);
 
 	if (gval < 0)
 		goto err_get_value;
-- 
2.1.4


