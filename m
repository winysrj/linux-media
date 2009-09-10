Return-path: <linux-media-owner@vger.kernel.org>
Received: from feuersaenger.de ([77.37.20.51]:48662 "EHLO mail.feuersaenger.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbZIJNXg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 09:23:36 -0400
Received: from www-data by mail.feuersaenger.de with local (Exim 4.69)
	(envelope-from <m@feuersaenger.de>)
	id 1Mlixf-0005We-JL
	for linux-media@vger.kernel.org; Thu, 10 Sep 2009 14:41:15 +0200
Message-ID: <18737.168.87.60.62.1252586475.squirrel@wm.feuersaenger.de>
Date: Thu, 10 Sep 2009 14:41:15 +0200 (CEST)
Subject: Problems with Haupauge WinTV-HVR 900
From: Martin =?iso-8859-1?Q?Feuers=E4nger?= <m@feuersaenger.de>
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi list,

I own the above TV USB stick (the 2040:6500 version, which is revision 1
of the model)since a while now but didn't use it for several months (and
kernel versions) now. It used to work in previous kernel versions.

I guess that quite some things have changed in the kernel modules since
last time I used the stick. From my previous usage I still had the
xc3023_*.i2c.fw files hanging around in /lib/firmware but they seem
obsolete now. So I followed the firmware extraction information (which was
new to me) at http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028
where it is claimed that the extracted firmware should "work with a large
number of boards from different manufacturers."

However, I seem to have problems. Right now I'm running
2.6.30-4.slh.2-sidux-686 kernel version (provided by the sidux team) and
when plugging in the stick I get

xc2028 0-0061: creating new instance
xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
i2c-adapter i2c-0: firmware: requesting xc3028-v27.fw
xc2028 0-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028
firmware,
ver 2.7
xc2028 0-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
xc2028 0-0061: Loading firmware for type=MTS (4), id ffffffffffffffff.
xc2028 0-0061: attaching existing instance
xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner

(Full dmesg output can be seen at http://pastebin.com/f148257f6)

When I try to do something with the stick I get error messages saying
"Incorrect readback of firmware version."

>From googleing I found that other people with the same device for the
type=MTS have a line with a different id, i.e.

xc2028 0-0061: Loading firmware for type=MTS (4), id 000000000000b700.

I hope that someone on this list can identify what problem I have/what I
do wrong.

Thanks in advance!

  Martin

