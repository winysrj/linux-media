Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:37479 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753460Ab0C0O4u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Mar 2010 10:56:50 -0400
Message-ID: <4BAE1C6A.6070601@arcor.de>
Date: Sat, 27 Mar 2010 15:55:38 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: tm6000
References: <1268243877-29157-1-git-send-email-stefan.ringel@arcor.de> <4B9C8C32.3070706@arcor.de> <4B9D2A67.80101@redhat.com> <4B9D44D3.8080201@arcor.de>
In-Reply-To: <4B9D44D3.8080201@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

First, I have a question, in the function "int tm6000_cards_setup(struct
tm6000_core *dev)" have you reset gpio 1 and 4, but why? In my lastest
patch I have add a few sticks and it's works with and without this
part.What for sticks use this part? For a week I have become a email
with usbsnoop log from a tm5600 based stick and I have analysed it.
Resume is that I think it use two reset gpio's.

1. GPIO1  = 0
2. GPIO4 = 0
3. wait a few ms
4. GPIO1 = 1
5. GPIO4 = 1

/*
     * Default initialization. Most of the devices seem to use GPIO1
     * and GPIO4.on the same way, so, this handles the common sequence
     * used by most devices.
     * If a device uses a different sequence or different GPIO pins for
     * reset, just add the code at the board-specific part
     */
    for (i = 0; i < 2; i++) {
        rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
                    dev->gpio.tuner_reset, 0x00);
        if (rc < 0) {
            printk(KERN_ERR "Error %i doing GPIO1 reset\n", rc);
            return rc;
        }

        msleep(10); /* Just to be conservative */
        rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
                    dev->gpio.tuner_reset, 0x01);
        if (rc < 0) {
            printk(KERN_ERR "Error %i doing GPIO1 reset\n", rc);
            return rc;
        }

        msleep(10);
        rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_4, 0);
        if (rc < 0) {
            printk(KERN_ERR "Error %i doing GPIO4 reset\n", rc);
            return rc;
        }

        msleep(10);
        rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_4, 1);
        if (rc < 0) {
            printk(KERN_ERR "Error %i doing GPIO4 reset\n", rc);
            return rc;
        }

        if (!i) {
            rc = tm6000_get_reg16(dev, 0x40, 0, 0);
            if (rc >= 0)
                printk(KERN_DEBUG "board=%d\n", rc);
        }
    }

For a week I have become a email with usbsnoop log from a tm5600 based
stick and I have analysed it. Resume is that I think it use two reset
gpio's.

1. GPIO1  = 0
2. GPIO4 = 0
3. wait a few ms
4. GPIO1 = 1
5. GPIO4 = 1

So I think, if it a part from function tm6000_cards_setup is, then is
that part wrong and must remove to tuner_callback function.

Second, I will rewrite the gpio's into a struct.

for example:

in tm6000.h

struct tm6000_gpio {
    int        tuner_reset;
    int        tuner_on;
    int        demod_reset;
    int        demod_on;
    int        power_led;
    int        dvb_led;
    int        ir;
};

in tm6000_card.c

[TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE] = {
        .name         = "Terratec Cinergy Hybrid XE / Cinergy Hybrid-Stick",
        .tuner_type   = TUNER_XC2028, /* has a XC3028 */
        .tuner_addr   = 0xc2 >> 1,
        .demod_addr   = 0x1e >> 1,
        .type         = TM6010,
        .caps = {
            .has_tuner    = 1,
            .has_dvb    = 1,
            .has_zl10353    = 1,
            .has_eeprom    = 1,
            .has_remote    = 1,
        },
        .gpio = {
            .tuner_reset     = TM6010_GPIO_2,
            .tuner_on    = TM6010_GPIO_3,
            .demod_reset    = TM6010_GPIO_1,
            .demod_on    = TM6010_GPIO_4,
            .power_led    = TM6010_GPIO_7,
            .dvb_led    = TM6010_GPIO_5,
            .ir        = TM6010_GPIO_0,
        },
    },

The rest I send in the patch email. So can the gpio's define in the
board struct and using per label in the functions.

Stefan Ringel

-- 
Stefan Ringel <stefan.ringel@arcor.de>

