Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:47867 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbZA2Wvg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 17:51:36 -0500
Message-ID: <498232EE.8060209@free.fr>
Date: Thu, 29 Jan 2009 23:51:26 +0100
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: tm6010 : strange i2c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am trying to make work my hauppauge HVR900H, and I start looking at 
http://linuxtv.org/hg/~mchehab/tm6010/ drivers and windows usb trace.


After some experiment I found that the i2c is very strange :
  * for the zl10353 demodulator, the register read only seems to work if 
the register address is odd and we read at least 2 bytes[1]. And the 
windows driver seems to really do that according usb trace (read always 
2 bytes at odd address).

  * the windows driver read the eeprom in the strange way : it use 
REQ_14_SET_GET_I2C_WR2_RDN, but setting the offset in the high byte of 
wIndex. And it does 16 bytes read, 1 bytes read for reading again the 
last 16th byte, and continue 16 bytes read, 1 byte read.

Did the people that worked on the tm6000 driver saw that weird i2c ?


Matthieu


[1]
Doing REQ_16_SET_GET_I2C_WR1_RDN on the demodulator with different 
register address and read size.

0051: 00
------
0051: 00
------
0052: 00
------
0050: 00
------
004f: 00
------
0050: 00
------
0051: 44 46
------
0051: 44 46
------
0052: 46 46
------
0050: 46 46
------
004f: 46 0c
------
0050: 0c 0c
------
0051: 44 46 15 0f
------
0051: 44 46 15 0f
------
0052: 0f 0f 00 00
------
0050: 00 00 00 00
------
004f: 00 0c 44 46
------
0050: 46 46 00 00
------
0051: 44 46 15 0f 00 00 00 00
------
0051: 44 46 15 0f 00 00 00 00
------
0052: 00 00 00 00 00 00 00 00
------
0050: 00 00 00 00 00 00 00 00
------
004f: 00 0c 44 46 15 0f 00 00
------
0050: 00 00 00 00 00 00 00 00
------
0051: 44 46 15 0f 00 00 00 00 00 48 00 75 0d 0d 0d 00
------
0051: 44 46 15 0f 00 00 00 00 00 48 00 75 0d 0d 0d 00
------
0052: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
------
0050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
------
004f: 00 0c 44 46 15 0f 00 00 00 00 00 48 00 75 0d 0d
------
0050: 0d 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00
------
0051: 44 46 15 0f 00 00 00 00 00 48 00 75 0d 0d 0d 00
0061: 4d 0a 0f 0f 0f 0f c2 00 00 80 00 00 00 00 00 00
------
0051: 44 46 15 0f 00 00 00 00 00 48 00 75 0d 0d 0d 00
0061: 4d 0a 0f 0f 0f 0f c2 00 00 80 00 00 00 00 00 00
------
0052: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0062: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
------
0050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
------
004f: 00 0c 44 46 15 0f 00 00 00 00 00 48 00 75 0d 0d
005f: 0d 00 4d 0a 0f 0f 0f 0f c2 00 00 80 00 00 00 00
------
0050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
------
