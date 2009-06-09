Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:51909 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZFIWbz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 18:31:55 -0400
Received: by ewy6 with SMTP id 6so402407ewy.37
        for <linux-media@vger.kernel.org>; Tue, 09 Jun 2009 15:31:56 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 10 Jun 2009 00:31:55 +0200
Message-ID: <c4bc83220906091531h20677733kd993ed50c0bc74ec@mail.gmail.com>
Subject: [PATCH] af9015: fix stack corruption bug
From: Jan Nikitenko <jan.nikitenko@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes stack corruption bug present in af9015_eeprom_dump():
the buffer buf is one byte smaller than required - there is 4 chars
for address prefix, 16*3 chars for dump of 16 eeprom bytes per line
and 1 byte for zero ending the string required, i.e. 53 bytes, but
only 52 are provided.
The one byte missing in stack based buffer buf causes following oops
on MIPS little endian platform, because i2c_adap pointer in
af9015_af9013_frontend_attach() is corrupted by inlined function
af9015_eeprom_dump():

CPU 0 Unable to handle kernel paging request at virtual address 00000000, epc ==
803a4488, ra == c049a1c8
Oops[#1]:
Cpu 0
$ 0   : 00000000 10003c00 00000000 803a4468
$ 4   : 8f17c600 8f067b30 00000002 00000038
$ 8   : 00000001 8faf3e98 11da000d 09010002
$12   : 00000000 00000000 00000000 0000000a
$16   : 8f17c600 8f067b68 8faf3c00 8f067c04
$20   : 8f067b9c 00000100 8f067bf0 80104100
$24   : 00000000 2aba9fb0
$28   : 8f066000 8f067af0 802cbc48 c049a1c8
Hi    : 00000000
Lo    : 00000000
epc   : 803a4488 i2c_transfer+0x20/0x104
   Not tainted
ra    : c049a1c8 af9013_read_reg+0x78/0xc4 [af9013]
Status: 10003c03    KERNEL EXL IE
Cause : 00808008
BadVA : 00000000
PrId  : 03030200 (Au1550)
Modules linked in: af9013 dvb_usb_af9015(+) dvb_usb dvb_core firmware_class
i2c_au1550 au1550_spi
Process modprobe (pid: 2757, threadinfo=8f066000, task=8fade098, tls=2aad6470)
Stack : c049f5e0 80163090 805ba880 00000100 8f067bf0 0000d733 8f067b68 8faf3c00
       8f067c04 c049a1c8 80163bc0 8056a630 8f067b40 80163224 80569fc8 8f0033d7
       00000038 80140003 8f067b2c 00010038 c0420001 8f067b28 c049f5e0 00000004
       00000004 c049a524 c049d5a8 c049d5a8 00000000 803a6700 00000000 8f17c600
       c042a7a4 8f17c600 c042a7a4 c049c924 00000000 00000000 00000002 613a6c00
       ...
Call Trace:
[<803a4488>] i2c_transfer+0x20/0x104
[<c049a1c8>] af9013_read_reg+0x78/0xc4 [af9013]
[<c049a524>] af9013_read_reg_bits+0x2c/0x70 [af9013]
[<c049c924>] af9013_attach+0x98/0x65c [af9013]
[<c04257bc>] af9015_af9013_frontend_attach+0x214/0x67c [dvb_usb_af9015]
[<c03e2428>] dvb_usb_adapter_frontend_init+0x20/0x12c [dvb_usb]
[<c03e1ad8>] dvb_usb_device_init+0x374/0x6b0 [dvb_usb]
[<c0426120>] af9015_usb_probe+0x4fc/0xfcc [dvb_usb_af9015]
[<80381024>] usb_probe_interface+0xbc/0x218
[<803227fc>] driver_probe_device+0x12c/0x30c
[<80322a80>] __driver_attach+0xa4/0xac
[<80321ed0>] bus_for_each_dev+0x60/0xd0
[<8032162c>] bus_add_driver+0x1e8/0x2a8
[<80322cdc>] driver_register+0x7c/0x17c
[<80380d30>] usb_register_driver+0xa0/0x12c
[<c042e030>] af9015_usb_module_init+0x30/0x6c [dvb_usb_af9015]
[<8010d2a4>] __kprobes_text_end+0x3c/0x1f4
[<80167150>] sys_init_module+0xb8/0x1cc
[<80102370>] stack_done+0x20/0x3c


Code: afb10018  7000003f  00808021 <8c430000> 7000003f  1060002d  00c09021
8f830014  3c02efff

Signed-off-by: Jan Nikitenko <jan.nikitenko@gmail.com>
---
 linux/drivers/media/dvb/dvb-usb/af9015.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -r cff06234b725 linux/drivers/media/dvb/dvb-usb/af9015.c
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Sun May 31 23:07:01 2009 +0300
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Wed Jun 10 00:25:53 2009 +0200
@@ -541,7 +541,7 @@
 /* dump eeprom */
 static int af9015_eeprom_dump(struct dvb_usb_device *d)
 {
-	char buf[52], buf2[4];
+	char buf[4+3*16+1], buf2[4];
 	u8 reg, val;

 	for (reg = 0; ; reg++) {
