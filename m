Return-path: <mchehab@pedra>
Received: from nm2-vm0.bullet.mail.ird.yahoo.com ([77.238.189.199]:39322 "HELO
	nm2-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753342Ab1FKJpv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 05:45:51 -0400
Message-ID: <672951.10004.qm@web24108.mail.ird.yahoo.com>
References: <S1753342Ab1FKJ3p/20110611092945Z+46855@vger.kernel.org>
Date: Sat, 11 Jun 2011 10:38:43 +0100 (BST)
From: Lopez Lopez <reality_es@yahoo.es>
Reply-To: Lopez Lopez <reality_es@yahoo.es>
Subject: dual sveon stv22 Afatech af9015 support (kworld clone)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <S1753342Ab1FKJ3p/20110611092945Z+46855@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello:

I have patched af9015.c and dvb-usb-ids to support sveon stv22 ( KWorld USB Dual DVB-T TV Stick (DVB-T 399U)  clone ) dual with
-----
#define USB_PID_SVEON_STV22                0xe401
------
 in dvb-usb-ids.h file 

and 
-----
/* 30 */{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_UB383_T)},
    {USB_DEVICE(USB_VID_KWORLD_2, 
 USB_PID_KWORLD_395U_4)},
    {USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_SVEON_STV22)},
    {0},
};

------
{
                .name = "Sveon STV22 Dual USB DVB-T Tuner HDTV ",
                .cold_ids = {&af9015_usb_table[32], NULL},
                .warm_ids = {NULL},
            },

-----

in af9015.c

i expect to help you to extends linux dvb usb support.

thanks for your time

Emilio David Diaus Lopez
