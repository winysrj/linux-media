Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52476 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab2JKXQv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 19:16:51 -0400
Date: Fri, 12 Oct 2012 01:16:36 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] winbond: remove space from driver name
Message-ID: <20121011231636.GA22453@hardeman.nu>
References: <1348821873-32527-1-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1348821873-32527-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 28, 2012 at 09:44:33AM +0100, Sean Young wrote:
>[root@pequod ~]# udevadm test /sys/class/rc/rc0
>-snip-
>ACTION=add
>DEVPATH=/devices/pnp0/00:04/rc/rc0
>DRV_NAME=Winbond CIR
>NAME=rc-rc6-mce
>SUBSYSTEM=rc
>UDEV_LOG=6
>USEC_INITIALIZED=88135858
>run: '/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s rc0'
>
>Having a space makes it impossible to match in /etc/rc_maps.cfg.
>
>Signed-off-by: Sean Young <sean@mess.org>
>---
> drivers/media/rc/winbond-cir.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
>index 30ae1f2..7c9b5f3 100644
>--- a/drivers/media/rc/winbond-cir.c
>+++ b/drivers/media/rc/winbond-cir.c
>@@ -184,7 +184,7 @@ enum wbcir_txstate {
> };
> 
> /* Misc */
>-#define WBCIR_NAME	"Winbond CIR"
>+#define WBCIR_NAME	"winbond-cir"

I'm not opposed to the change per se, but WBCIR_NAME is used for
input_name as well and a quick "lsinput" on my laptop shows that all
evdev devices (18 in total) have properly capitalized names.

I'd suggest a separate WBCIR_DNAME.

> #define WBCIR_ID_FAMILY          0xF1 /* Family ID for the WPCD376I	*/
> #define	WBCIR_ID_CHIP            0x04 /* Chip ID for the WPCD376I	*/
> #define INVALID_SCANCODE   0x7FFFFFFF /* Invalid with all protos	*/
>-- 
>1.7.11.4
>

-- 
David H�rdeman
