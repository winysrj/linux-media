Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48134 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab0DWM5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Apr 2010 08:57:18 -0400
Received: by gyg13 with SMTP id 13so5119821gyg.19
        for <linux-media@vger.kernel.org>; Fri, 23 Apr 2010 05:57:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100423104804.784fb730@glory.loctelecom.ru>
References: <20100423104804.784fb730@glory.loctelecom.ru>
Date: Fri, 23 Apr 2010 20:57:12 +0800
Message-ID: <m2s6e8e83e21004230557kb4f44b5dya243b5120a86282f@mail.gmail.com>
Subject: Re: [PATCH] tm6000 fix i2c
From: Bee Hock Goh <beehock@gmail.com>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am still able to watch tv after applying the patch but the return
code is bad and is causing unnecessary reloading of the same
firmwares.

[ 2482.599040] usb 1-1: firmware: requesting tm6000-xc3028.fw
[ 2482.607229] xc2028 2-0061: Loading 77 firmware images from
tm6000-xc3028.fw, type: xc2028 firmware, ver 2.4
[ 2482.788089] xc2028 2-0061: Loading firmware for type=BASE F8MHZ
(3), id 0000000000000000.
[ 2503.620069] (0), id 00000000000000ff:
[ 2503.620078] xc2028 2-0061: Loading firmware for type=(0), id
0000000100000007.
[ 2504.380061] xc2028 2-0061: Loading SCODE for type=MONO SCODE
HAS_IF_5320 (60008000), id 0000000f00000007.
[ 2504.520063] xc2028 2-0061: i2c input error: rc = -32 (should be 2)
[ 2504.536064] xc2028 2-0061: Unable to read tuner registers.
[ 2504.776079] xc2028 2-0061: Loading firmware for type=BASE F8MHZ
(3), id 0000000000000000.
[ 2525.556048] (0), id 00000000000000ff:
[ 2525.556057] xc2028 2-0061: Loading firmware for type=(0), id
0000000100000007.
[ 2526.312058] xc2028 2-0061: Loading SCODE for type=MONO SCODE
HAS_IF_5320 (60008000), id 0000000f00000007.
[ 2526.452061] xc2028 2-0061: i2c input error: rc = -32 (should be 2)
[ 2526.468050] xc2028 2-0061: Unable to read tuner registers.
[ 2527.648076] xc2028 2-0061: Loading firmware for type=BASE F8MHZ
(3), id 0000000000000000.
[ 2548.460067] (0), id 00000000000000ff:
[ 2548.460076] xc2028 2-0061: Loading firmware for type=(0), id
0000000100000007.
[ 2549.216070] xc2028 2-0061: Loading SCODE for type=MONO SCODE
HAS_IF_5320 (60008000), id 0000000f00000007.
[ 2549.356064] xc2028 2-0061: i2c input error: rc = -32 (should be 2)
[ 2549.372065] xc2028 2-0061: Unable to read tuner registers.
[ 2549.612052] xc2028 2-0061: Loading firmware for type=BASE F8MHZ
(3), id 0000000000000000.
[ 2570.609041] (0), id 00000000000000ff:
[ 2570.609049] xc2028 2-0061: Loading firmware for type=(0), id
0000000100000007.
[ 2571.397034] xc2028 2-0061: Loading SCODE for type=MONO SCODE
HAS_IF_5320 (60008000), id 0000000f00000007.
[ 2571.537025] xc2028 2-0061: i2c input error: rc = -32 (should be 2)
[ 2571.553024] xc2028 2-0061: Unable to read tuner registers.
[ 2572.553103] Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: 0)
[ 2572.561090] tm6000: open called (dev=video0)
[ 2573.081022] Original value=96
[ 2573.093037] tm6000: VIDIOC_QUERYCAP
[ 2573.149565] tm6000: open called (dev=video0)



On Fri, Apr 23, 2010 at 8:48 AM, Dmitri Belimov <d.belimov@gmail.com> wrote:
> Hi
>
> Rework I2C for read word from connected devices, now it works well.
> Add new functions for read/write blocks.
>
> diff -r 7c0b887911cf linux/drivers/staging/tm6000/tm6000-i2c.c
> --- a/linux/drivers/staging/tm6000/tm6000-i2c.c Mon Apr 05 22:56:43 2010 -0400
> +++ b/linux/drivers/staging/tm6000/tm6000-i2c.c Fri Apr 23 04:23:03 2010 +1000
> @@ -24,6 +24,7 @@
>  #include <linux/kernel.h>
>  #include <linux/usb.h>
>  #include <linux/i2c.h>
> +#include <linux/delay.h>
>
>  #include "compat.h"
>  #include "tm6000.h"
> @@ -45,11 +46,39 @@
>                        printk(KERN_DEBUG "%s at %s: " fmt, \
>                        dev->name, __FUNCTION__ , ##args); } while (0)
>
> +static void tm6000_i2c_reset(struct tm6000_core *dev)
> +{
> +       tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_CLK, 0);
> +       msleep(15);
> +       tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_CLK, 1);
> +       msleep(15);
> +}
> +
>  static int tm6000_i2c_send_regs(struct tm6000_core *dev, unsigned char addr,
>                                __u8 reg, char *buf, int len)
>  {
> -       return tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> -               REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, buf, len);
> +       int rc;
> +       unsigned int tsleep;
> +
> +       if (!buf || len < 1 || len > 64)
> +               return -1;
> +
> +       /* capture mutex */
> +       rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
> +               USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
> +               addr | reg << 8, 0, buf, len);
> +
> +       if (rc < 0) {
> +               /* release mutex */
> +               return rc;
> +       }
> +
> +       /* Calculate delay time, 14000us for 64 bytes */
> +       tsleep = ((len * 200) + 200 + 1000) / 1000;
> +       msleep(tsleep);
> +
> +       /* release mutex */
> +       return rc;
>  }
>
>  /* Generic read - doesn't work fine with 16bit registers */
> @@ -59,22 +88,30 @@
>        int rc;
>        u8 b[2];
>
> -       if ((dev->caps.has_zl10353) && (dev->demod_addr << 1 == addr) && (reg % 2 == 0)) {
> +       if (!buf || len < 1 || len > 64)
> +               return -1;
> +
> +       /* capture mutex */
> +       if ((dev->caps.has_zl10353) && (dev->demod_addr << 1 == addr)
> +       && (reg % 2 == 0)) {
>                /*
>                 * Workaround an I2C bug when reading from zl10353
>                 */
>                reg -= 1;
>                len += 1;
>
> -               rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> -                       REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, b, len);
> +               rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
> +               USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
> +               addr | reg << 8, 0, b, len);
>
>                *buf = b[1];
>        } else {
> -               rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> -                       REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, buf, len);
> +               rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
> +               USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
> +               addr | reg << 8, 0, buf, len);
>        }
>
> +       /* release mutex */
>        return rc;
>  }
>
> @@ -85,8 +122,106 @@
>  static int tm6000_i2c_recv_regs16(struct tm6000_core *dev, unsigned char addr,
>                                  __u16 reg, char *buf, int len)
>  {
> -       return tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> -               REQ_14_SET_GET_I2C_WR2_RDN, addr, reg, buf, len);
> +       int rc;
> +       unsigned char ureg;
> +
> +       if (!buf || len != 2)
> +               return -1;
> +
> +       /* capture mutex */
> +       ureg = reg & 0xFF;
> +       rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
> +               USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
> +               addr | (reg & 0xFF00), 0, &ureg, 1);
> +
> +       if (rc < 0) {
> +               /* release mutex */
> +               return rc;
> +       }
> +
> +       msleep(1400 / 1000);
> +       rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
> +               USB_RECIP_DEVICE, REQ_35_AFTEK_TUNER_READ,
> +               reg, 0, buf, len);
> +
> +       if (rc < 0) {
> +               /* release mutex */
> +               return rc;
> +       }
> +
> +       /* release mutex */
> +       return rc;
> +}
> +
> +static int tm6000_i2c_read_sequence(struct tm6000_core *dev, unsigned char addr,
> +                                 __u16 reg, char *buf, int len)
> +{
> +       int rc;
> +
> +       if (!buf || len < 1 || len > 64)
> +               return -1;
> +
> +       /* capture mutex */
> +       rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR |
> +               USB_RECIP_DEVICE, REQ_35_AFTEK_TUNER_READ,
> +               reg, 0, buf, len);
> +       /* release mutex */
> +       return rc;
> +}
> +
> +static int tm6000_i2c_write_sequence(struct tm6000_core *dev,
> +                               unsigned char addr, __u16 reg, char *buf,
> +                               int len)
> +{
> +       int rc;
> +       unsigned int tsleep;
> +
> +       if (!buf || len < 1 || len > 64)
> +               return -1;
> +
> +       /* capture mutex */
> +       rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
> +               USB_RECIP_DEVICE, REQ_16_SET_GET_I2C_WR1_RDN,
> +               addr | reg << 8, 0, buf+1, len-1);
> +
> +       if (rc < 0) {
> +               /* release mutex */
> +               return rc;
> +       }
> +
> +       /* Calculate delay time, 13800us for 64 bytes */
> +       tsleep = ((len * 200) + 1000) / 1000;
> +       msleep(tsleep);
> +
> +       /* release mutex */
> +       return rc;
> +}
> +
> +static int tm6000_i2c_write_uni(struct tm6000_core *dev, unsigned char addr,
> +                                 __u16 reg, char *buf, int len)
> +{
> +       int rc;
> +       unsigned int tsleep;
> +
> +       if (!buf || len < 1 || len > 64)
> +               return -1;
> +
> +       /* capture mutex */
> +       rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR |
> +               USB_RECIP_DEVICE, REQ_30_I2C_WRITE,
> +               addr | reg << 8, 0, buf+1, len-1);
> +
> +       if (rc < 0) {
> +               /* release mutex */
> +               return rc;
> +       }
> +
> +       /* Calculate delay time, 14800us for 64 bytes */
> +       tsleep = ((len * 200) + 1000 + 1000) / 1000;
> +       msleep(tsleep);
> +
> +       /* release mutex */
> +       return rc;
>  }
>
>  static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
>
> Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
>
>
> With my best regards, Dmitry.
