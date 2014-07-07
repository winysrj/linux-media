Return-path: <linux-media-owner@vger.kernel.org>
Received: from com.lmt.lv ([212.93.97.225]:12040 "HELO com.lmt.lv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750868AbaGGUXj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jul 2014 16:23:39 -0400
Received: from [10.88.207.76] (unknown [10.88.207.76])
	by com.lmt.lv (Postfix) with ESMTP id 06079120C6
	for <linux-media@vger.kernel.org>; Mon,  7 Jul 2014 23:23:36 +0300 (EEST)
Message-ID: <53BB01C7.3060405@apollo.lv>
Date: Mon, 07 Jul 2014 23:23:35 +0300
From: Raimonds Cicans <ray@apollo.lv>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Few questions about dibusb i2c over usb protocol
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

1) As I understand format of i2c read command is following:
2, (dev_i2c_addr<<1)|1, addr_hi, addr_lo, size_hi, size_lo

but in debug output I saw following commands:
 >>> 02 a3 00 01
<<< 55

 >>> 02 a3 00 04
<<< 55 00 53 00

This commands are shorter then command described above.
Meaning of bytes 1, 2 and 4 is clear, but what mean third byte:
if it is size_hi, then where is address?
if it is addr_lo, then it is not clear why answer's first byte is 55
according to Cypress documentation first byte of
program eeprom should be C2

2) What is format for i2c write command?
3, dev_i2c_addr<<1, addr_hi, addr_lo, data...   ?

3) what mean following command
 >>> 03 a2 51 3f 80

write byte 80 at address 513f?


Raimonds Cicans

