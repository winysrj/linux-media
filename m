Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:56479 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755764Ab2BVWWF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 17:22:05 -0500
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] Firmware for AF9035/AF9033 driver
Date: Wed, 22 Feb 2012 23:22:02 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201202222322.02424.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Firmware for the AF9035/AF9033 driver.

irmware format for af903x driver:
copied from it9135-driver by Jason Dong (C) 2011 ITE Technologies, INC.

00000000: 8 chars "AF9035BX"    Identifier of firmware
00000008: 4 bytes LE length of firmware following this:
                32 + 4 + 4 + 4 + 4 + 4 + Firmware_CODELENGTH +
                Firmware_SEGMENTLENGTH * Firmware_PARTITIONLENGTH * 5 +
                5 + 2 + Firmware_scriptSets[0] * 5;
0000000C: 32 chars firmware release version
0000002C: 4 bytes BE link version
00000030: 4 bytes BE ofdm version
00000034: 4 bytes LE firmware code length (Firmware_CODELENGTH)
00000038: 1 bytes number of firmware segments (Firmware_SEGMENTLENGTH)
00000039: 3 bytes filler (0)
0000003C: 1 bytes number of firmware partitions (Firmware_PARTITIONLENGTH)
0000003D: 3 bytes filler (0)
00000040: Firmware_CODELENGTH bytes
0000abcd: description of firmware segments, for each segment in every 
partition:
        1 byte segment type (0: download firmware, 1: copy firmware, else: 
direct write firmware)
        4 bytes LE segment length
0000bcde: 1 byte Firmware_SEGMENTLENGTH check
0000bcdf: 1 byte Firmware_PARTITIONLENGTH check
0000bce0: 3 bytes filler (0)
0000bce3: 2 bytes LE number of firmware (demodulator) scripts
0000bce5: list of firmware scripts, for each entry:
        4 bytes LE address
        1 byte value

Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>

http://home.arcor.de/hfvogt/af903x/dvb-usb-af9035-03.fw => for Terratec T5 
Ver. 2 / T6
http://home.arcor.de/hfvogt/af903x/dvb-usb-af9035-04.fw => for Avermedia A867

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
