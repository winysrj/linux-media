Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39080 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbZIENUM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Sep 2009 09:20:12 -0400
Message-ID: <4AA26587.7000506@iki.fi>
Date: Sat, 05 Sep 2009 16:20:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Heinrich Langos <henrik-vdr@prak.org>
Subject: DVB USB stream parameters
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

What are preferred BULK stream parameters, .count and .buffersize?

for USB2.0?
for USB1.1?

buffersize, which is URB size, have great effect to system load. For 
example 512 bytes generates about 10x more wakeups than 5120. It is 
quite clear that 512 is too small for whole DVB stream. I did some test 
and looks like all USB2.0 devices I have here allow x512 or x188 sizes.
Heinrich Langos did some measurements and results can be seen here:
http://www.linuxtv.org/wiki/index.php/User:Hlangos

In my understanding we should found some balance between URB size and 
transferred stream bandwidth. For example DVB-T stream, when common 
transmission parameters are used, is more than 20Mbit/sec.

There is also USB bridge chips which does have two or more different 
standard frontends needed different stream bandwidths.

Should we add new module param for override module default?

a800        BULK  7x 4096= 28672
af9005      BULK 10x 4096= 40960 USB1.1 BUGFIX: x512=>x188
af9015      BULK  6x 3072=  3072 BUGFIX: x512=>x188
anysee      BULK  8x  512=  4096
ce6230      BULK  6x  512=  3072
cinergyT2   BULK  5x  512=  2560
cxusb       BULK  5x 8192= 40960
cxusb       BULK  7x 4096= 28672
dib0700     BULK  4x39480=157920 210x188 !!HUGE!!
dibusb-mb   BULK  7x 4096= 28672  56x512
dibusb-mc   BULK  7x 4096= 28672
digitv      BULK  7x 4096= 28672
dtt200u     BULK  7x 4096= 28672
dtv5100     BULK  8x 4096= 32768
dw2102      BULK  8x 4096= 32768
gl861       BULK  7x  512=  3584
gp8psk      BULK  7x 8192= 57344
m920x       BULK  8x  512=  4096
m920x       BULK  8x16384=131072 256x512 !!HUGE!!
nova-t-usb2 BULK  7x 4096= 28672
opera1      BULK 10x 4096= 40960
umt-010     BULK 10x  512=  5120
vp702x      BULK 10x 4096= 40960
vp7045      BULK  7x 4096= 28672

au6610      ISOC  5 frames 40 size 942
ttusb2      ISOC  5 frames  4 size 942

regards
Antti
-- 
http://palosaari.fi/
