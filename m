Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:64934 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab0AJQ7I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 11:59:08 -0500
Message-ID: <4B4A0752.6030306@freemail.hu>
Date: Sun, 10 Jan 2010 17:58:58 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: gspca_pac7302: sporatdic problem when plugging the device
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have sporadic problem with Labtec Webcam 2200 (0x093a:0x2626). I'm using
gspca_pac7302 driver from http://linuxtv.org/hg/~jfrancois/gspca/
rev 13915 on top of Linux kernel 2.6.32.

I executed the following command in an xterm window:
$ while true; do ./svv; done

Then I plugged and unplugged the device 16 times. When I last plugged the
device I get the following error in the dmesg:

[32393.421313] gspca: probing 093a:2626
[32393.426193] gspca: video0 created
[32393.426958] gspca: probing 093a:2626
[32393.426968] gspca: Interface class 1 not handled here
[32394.005917] pac7302: reg_w_page(): Failed to write register to index 0x49, value 0x0, error -71
[32394.067799] gspca: set alt 8 err -71
[32394.090792] gspca: set alt 8 err -71
[32394.118159] gspca: set alt 8 err -71

The 17th plug was working correctly again. I executed this test on an EeePC 901.

This driver version contains the msleep(4) in the reg_w_buf(). However, here
the reg_w_page() fails, which does not have msleep() inside. I don't know what
is the real problem, but I am afraid that slowing down reg_w_page() would make
the time longer when the device can be used starting from the event when it is
plugged.

Regards,

	Márton Németh
