Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:58511 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751519AbaDNMNA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 08:13:00 -0400
Date: Mon, 14 Apr 2014 09:12:31 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-usb@vger.kernel.org
Subject: Re: stk1160 / ehci-pci 0000:00:0a.0: DMA-API: device driver maps
 memory fromstack [addr=ffff88003d0b56bf]
Message-ID: <20140414121231.GA6393@arch.cereza>
References: <438386739.20140413224553@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <438386739.20140413224553@eikelenboom.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Apr 13, Sander Eikelenboom wrote:
> 
> I'm hitting this warning on boot with a syntek usb video grabber, it's not clear 
> to me if it's a driver issue of the stk1160 or a generic ehci issue.
> 

Can't reproduce the same warning easily here. Could you test the following patch?

diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index 34a26e0..304fdb3 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -71,13 +71,14 @@ int stk1160_read_reg(struct stk1160 *dev, u16 reg, u8 *value)
 	*value = 0;
 	ret = usb_control_msg(dev->udev, pipe, 0x00,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			0x00, reg, value, sizeof(u8), HZ);
+			0x00, reg, dev->urb_buf, sizeof(u8), HZ);
 	if (ret < 0) {
 		stk1160_err("read failed on reg 0x%x (%d)\n",
 			reg, ret);
 		return ret;
 	}
 
+	*value = dev->urb_buf[0];
 	return 0;
 }
 
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
