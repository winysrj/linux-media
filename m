Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44278 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758307Ab2FUD0X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 23:26:23 -0400
Message-ID: <4FE29458.4060909@iki.fi>
Date: Thu, 21 Jun 2012 06:26:16 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: htl10@users.sourceforge.net,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: DVB USB new version v2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Good morning,

DVB USB changes I have been working are now ready at my point of view.
All changes are here:
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/dvb-usb

And here is some numbers I just took, in order first old version then 
new. I converted those 6 drivers (af9015, af9035, anysee, au6610, 
ce6230, ec168) during the development in order to see results and test 
functionality.

  text  data bss    dec   hex  filename
15656   600  12  16268  3f8c  2012-06-21/dvb-usb.ko
14212  2880   8  17100  42cc  2012-06-21/dvb_usbv2.ko
14878 13232  40  28150  6df6  2012-05-22/dvb-usb-af9015.ko
16740  1312   8  18060  468c  2012-06-21/dvb-usb-af9015.ko
  9917  9768   4  19689  4ce9  2012-05-22/dvb-usb-af9035.ko
  9236  1848   0  11084  2b4c  2012-06-21/dvb-usb-af9035.ko
  9756  5072   8  14836  39f4  2012-05-22/dvb-usb-anysee.ko
  9800  1552   4  11356  2c5c  2012-06-21/dvb-usb-anysee.ko
  1932  4688   4   6624  19e0  2012-05-22/dvb-usb-au6610.ko
  1763  1184   0   2947   b83  2012-06-21/dvb-usb-au6610.ko
  2917  4736   4   7657  1de9  2012-05-22/dvb-usb-ce6230.ko
  2763  1416   0   4179  1053  2012-06-21/dvb-usb-ce6230.ko
  3659  4784   4   8447  20ff  2012-05-22/dvb-usb-ec168.ko
  3607  1584   0   5191  1447  2012-06-21/dvb-usb-ec168.ko

Lines of code:
af9015  2084 => 1591
af9035  1355 => 1194
anysee  1738 => 1680
au6610   291 =>  238
ce6230   393 =>  348
ec168    508 =>  439

It was a little bit surprise new DVB USB is still few bytes larger than 
old, but likely it is coming from new functionality and debugs. Legacy 
remote and Cypress firmware download routines are functionality dropped 
out. Otherwise just some feature additions, many bug fixes and rather 
largely changed functionality. I tried to keep it close old as much as 
possible like naming but still did not keep backward compatibility in 
order to make it clean and small. So it should not consider as 1:1 
replacement, not even possible to convert old drivers without having a 
hardware in hands.

It implements all new features I planned. Suspend/resume is not 100% 
ready as it needs some work for DVB-core. It just kills streaming when 
suspend to make it happen even when streaming, but does not handle power 
management which needs to be done in DVB-core.

Also all bugs I was aware should be fixed. For example deferred firmware 
downloading (interoperability issue between DVB USB driver and udev), 
locking to sync frontend control and frontend streaming as there was 
race condition (aka bug "dvb-usb: error while stopping stream.").

Feel free to comment, lets try to fix if there is new findings or small 
feature addons.


regards
Antti

-- 
http://palosaari.fi/

