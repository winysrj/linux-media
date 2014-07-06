Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54962 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbaGFPrQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jul 2014 11:47:16 -0400
Received: from [192.168.178.21] ([85.177.121.229]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0LjZn2-1WSXxy0Ujg-00beKL for
 <linux-media@vger.kernel.org>; Sun, 06 Jul 2014 17:47:14 +0200
Message-ID: <53B96F81.2060203@gmx.de>
Date: Sun, 06 Jul 2014 17:47:13 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: drivers/media/pci/saa7134/saa7134-input.c: is variable b really uninitialized
 in line 136 ?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

/me wonders if cppcheck is right here :

static int get_key_flydvb_trio(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
{
        int gpio;
        int attempt = 0;
        unsigned char b;

        /* We need this to access GPI Used by the saa_readl macro. */
        struct saa7134_dev *dev = ir->c->adapter->algo_data;

        if (dev == NULL) {
                i2cdprintk("get_key_flydvb_trio: "
                           "ir->c->adapter->algo_data is NULL!\n");
                return -EIO;
        }

        /* rising SAA7134_GPIGPRESCAN reads the status */
        saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
        saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);

        gpio = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2);

        if (0x40000 & ~gpio)
                return 0; /* No button press */

        /* No button press - only before first key pressed */
        if (b == 0xFF)                                                           <--- Uninitialized variable: b
                return 0;

        /* poll IR chip */
        /* weak up the IR chip */
        b = 0;

 
-- 
Toralf

