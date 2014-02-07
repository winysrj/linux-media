Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4.pb.cz ([109.72.0.114]:60558 "EHLO smtp4.pb.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbaBGRXd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 12:23:33 -0500
Received: from [192.168.1.15] (unknown [109.72.4.22])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp4.pb.cz (Postfix) with ESMTPS id ECAC48140F
	for <linux-media@vger.kernel.org>; Fri,  7 Feb 2014 17:47:07 +0100 (CET)
Message-ID: <52F50E0B.1060507@mizera.cz>
Date: Fri, 07 Feb 2014 17:47:07 +0100
From: kapetr@mizera.cz
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: video from USB DVB-T get  damaged after some time
Content-Type: multipart/mixed;
 boundary="------------040302000209000709010102"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040302000209000709010102
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I have this:
http://linuxtv.org/wiki/index.php/ITE_IT9135

with dvb-usb-it9135-02.fw (chip version 2) on U12.04 64b with compiled 
newest drivers from: 
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers.


The problem is - after some time I receive a program (e.g. in Kaffeine, 
me-tv, vlc, ...) the program get more and more damaged and finely get 
lost at all.

I happens quicker (+- after 10-20 minutes) on channels with lower 
signal. On stronger signals it happens after +- 30-100 minutes.

The USB stick stays cool.

I can switch to another frequency and back and it works again OK - for 
only the "same" while.

Could that problem be in (or solvable by) FW/drivers or is it 
!absolutely certain! "only" HW problem ?

In attachment is output from tzap - you can see the time point where the 
video TS gets damaged.

Any suggestion ?


Thanks  --kapetr


--------------040302000209000709010102
Content-Type: text/x-log;
 name="tzap.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tzap.log"

status 1f | signal 7fff | snr e780 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e5bb | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e567 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e428 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e484 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e4a6 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e639 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e606 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e5aa | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e51b | ber 00000003 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e69d | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e780 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e5dc | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e591 | ber 00000003 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e4f1 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e534 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e5bb | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e46b | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e702 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e6e9 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e649 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e5fe | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e4d8 | ber 00000003 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e588 | ber 00000003 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e50a | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e577 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e31b | ber 00000003 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e3d4 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e26b | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e40e | ber 00000003 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e452 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e3e5 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e4bf | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e3fe | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e484 | ber 00000003 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e5a1 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e56f | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e639 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e6a6 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e4e0 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e5e5 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e4bf | ber 00000006 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e641 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e7bb | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e6bf | ber 00000006 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e6a6 | ber 00000003 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e513 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e406 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e262 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e4d0 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e273 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e388 | ber 00000003 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e3b2 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e2f1 | ber 00000003 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e588 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e5e5 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e3c3 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e695 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e54d | ber 00000003 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e628 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e580 | ber 00000003 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e724 | ber 00000037 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e5a1 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e9d4 | ber 00000000 | unc 00000016 | FE_HAS_LOCK
status 1f | signal 7fff | snr e6d0 | ber 000005fe | unc 00000042 | FE_HAS_LOCK
status 1f | signal 7fff | snr e50a | ber 000006f3 | unc 00000078 | FE_HAS_LOCK
status 1f | signal 7fff | snr e502 | ber 0000067e | unc 000000aa | FE_HAS_LOCK
status 1f | signal 7fff | snr eb1b | ber 00000000 | unc 000000aa | FE_HAS_LOCK
status 1f | signal 7fff | snr e76f | ber 00000003 | unc 000000aa | FE_HAS_LOCK
status 1f | signal 7fff | snr e430 | ber 00000b78 | unc 00000100 | FE_HAS_LOCK
status 1f | signal 7fff | snr e7c3 | ber 00000000 | unc 00000100 | FE_HAS_LOCK
status 1f | signal 7fff | snr e673 | ber 00000d2d | unc 00000168 | FE_HAS_LOCK
status 1f | signal 7fff | snr dae0 | ber 00003cf2 | unc 00000348 | FE_HAS_LOCK
status 1f | signal 7fff | snr df1b | ber 000043aa | unc 00000556 | FE_HAS_LOCK
status 1f | signal 7fff | snr d6f9 | ber 0000727d | unc 000008d6 | FE_HAS_LOCK
status 1f | signal 7fff | snr e284 | ber 0000131e | unc 00000968 | FE_HAS_LOCK
status 1f | signal 7fff | snr e2c7 | ber 00005074 | unc 00000be0 | FE_HAS_LOCK
status 1f | signal 7fff | snr e4d0 | ber 00002f4a | unc 00000d48 | FE_HAS_LOCK
status 1f | signal 7fff | snr e45a | ber 00000000 | unc 00000d48 | FE_HAS_LOCK
status 1f | signal 7fff | snr e53d | ber 00002f27 | unc 00000eba | FE_HAS_LOCK
status 1f | signal 7fff | snr db88 | ber 0000afdc | unc 0000140c | FE_HAS_LOCK
status 1f | signal 7fff | snr d9e4 | ber 00009715 | unc 0000189e | FE_HAS_LOCK
status 1f | signal 7fff | snr e45a | ber 00001513 | unc 00001946 | FE_HAS_LOCK
status 1f | signal 7fff | snr e228 | ber 000055f3 | unc 00001be4 | FE_HAS_LOCK
status 1f | signal 7fff | snr e188 | ber 0000225b | unc 00001cf4 | FE_HAS_LOCK
status 1f | signal 7fff | snr dea5 | ber 00004ef8 | unc 00001f58 | FE_HAS_LOCK
status 1f | signal 7fff | snr d7dc | ber 00006d49 | unc 000022b2 | FE_HAS_LOCK
status 1f | signal 7fff | snr e10a | ber 00008f09 | unc 00002718 | FE_HAS_LOCK
status 1f | signal 7fff | snr e113 | ber 00008550 | unc 00002b22 | FE_HAS_LOCK
status 1f | signal 7fff | snr d77f | ber 00009e77 | unc 00002ff2 | FE_HAS_LOCK
status 1f | signal 7fff | snr d94d | ber 0000a73d | unc 00003512 | FE_HAS_LOCK
status 1f | signal 7fff | snr dc95 | ber 000068da | unc 0000383a | FE_HAS_LOCK
status 1f | signal 7fff | snr d849 | ber 0000aad3 | unc 00003d6a | FE_HAS_LOCK
status 1f | signal 7fff | snr d6cf | ber 0000a2f9 | unc 00004260 | FE_HAS_LOCK
status 1f | signal 7fff | snr d9f5 | ber 00009cf3 | unc 0000471e | FE_HAS_LOCK
status 1f | signal 7fff | snr db5e | ber 00005f03 | unc 00004a06 | FE_HAS_LOCK
status 1f | signal 7fff | snr da41 | ber 000094b8 | unc 00004e8e | FE_HAS_LOCK
status 1f | signal 7fff | snr e11b | ber 000062d2 | unc 00005190 | FE_HAS_LOCK
status 1f | signal 8a3c | snr e67c | ber 0000a675 | unc 000056a2 | FE_HAS_LOCK
status 1f | signal 7fff | snr dab6 | ber 00005e8b | unc 00005986 | FE_HAS_LOCK
status 1f | signal 8a3c | snr dcb6 | ber 000094c5 | unc 00005e12 | FE_HAS_LOCK
status 1f | signal 7fff | snr dcc7 | ber 0000a6a9 | unc 00006320 | FE_HAS_LOCK
status 1f | signal 7fff | snr d73c | ber 0000a628 | unc 00006830 | FE_HAS_LOCK
status 1f | signal 7fff | snr d72b | ber 0000c2d3 | unc 00006e26 | FE_HAS_LOCK
status 1f | signal 7fff | snr d977 | ber 0000948e | unc 0000729a | FE_HAS_LOCK
status 1f | signal 7fff | snr db34 | ber 00009948 | unc 00007746 | FE_HAS_LOCK
status 1f | signal 8a3c | snr d702 | ber 0000a42e | unc 00007c4e | FE_HAS_LOCK
status 1f | signal 7fff | snr da84 | ber 000097ce | unc 000080ec | FE_HAS_LOCK
status 1f | signal 7fff | snr d945 | ber 0000a618 | unc 000085fc | FE_HAS_LOCK
status 1f | signal 7fff | snr da49 | ber 0000b373 | unc 00008b6e | FE_HAS_LOCK
status 1f | signal 7fff | snr d862 | ber 00009fcb | unc 0000904c | FE_HAS_LOCK
status 1f | signal 7fff | snr dd88 | ber 00009b67 | unc 0000950c | FE_HAS_LOCK
status 1f | signal 7fff | snr d6b6 | ber 0000aa80 | unc 00009a4e | FE_HAS_LOCK
status 1f | signal 7fff | snr d851 | ber 0000b054 | unc 00009fb8 | FE_HAS_LOCK
status 1f | signal 7fff | snr db0a | ber 0000a237 | unc 0000a4ae | FE_HAS_LOCK
status 1f | signal 7fff | snr d65a | ber 0000bd09 | unc 0000aa76 | FE_HAS_LOCK
status 1f | signal 7fff | snr d88c | ber 00009920 | unc 0000af20 | FE_HAS_LOCK
status 1f | signal 7fff | snr dbe4 | ber 00009ec1 | unc 0000b3ee | FE_HAS_LOCK
status 1f | signal 7fff | snr dab6 | ber 0000c720 | unc 0000ba00 | FE_HAS_LOCK
status 1f | signal 7fff | snr dbaa | ber 0000acc6 | unc 0000bf42 | FE_HAS_LOCK
status 1f | signal 7fff | snr d9ed | ber 0000a650 | unc 0000c450 | FE_HAS_LOCK
status 1f | signal 7fff | snr d873 | ber 0000c22f | unc 0000ca40 | FE_HAS_LOCK
status 1f | signal 7fff | snr dbb2 | ber 000099ed | unc 0000cef4 | FE_HAS_LOCK
status 1f | signal 7fff | snr daf9 | ber 0000ae13 | unc 0000d44c | FE_HAS_LOCK
status 1f | signal 7fff | snr db02 | ber 0000ab98 | unc 0000d982 | FE_HAS_LOCK
status 1f | signal 7fff | snr dc17 | ber 0000a9ef | unc 0000deb0 | FE_HAS_LOCK
status 1f | signal 7fff | snr db90 | ber 0000a681 | unc 0000e3c2 | FE_HAS_LOCK
status 1f | signal 7fff | snr e462 | ber 00000de6 | unc 0000e430 | FE_HAS_LOCK
status 1f | signal 7fff | snr e5c3 | ber 00001904 | unc 0000e4ec | FE_HAS_LOCK
status 1f | signal 7fff | snr e788 | ber 00000003 | unc 0000e4ec | FE_HAS_LOCK
status 1f | signal 7fff | snr e6f1 | ber 00000003 | unc 0000e4ec | FE_HAS_LOCK
status 1f | signal 7fff | snr e3e5 | ber 00000003 | unc 0000e4ec | FE_HAS_LOCK
status 1f | signal 7fff | snr e54d | ber 00000000 | unc 0000e4ec | FE_HAS_LOCK
status 1f | signal 7fff | snr e6c7 | ber 00000000 | unc 0000e4ec | FE_HAS_LOCK
status 1f | signal 7fff | snr e4b6 | ber 00000000 | unc 0000e4ec | FE_HAS_LOCK
status 1f | signal 7fff | snr e47c | ber 00000000 | unc 0000e4ec | FE_HAS_LOCK
status 1f | signal 7fff | snr e662 | ber 00000000 | unc 0000e4ec | FE_HAS_LOCK
status 1f | signal 7fff | snr e495 | ber 00000000 | unc 0000e4ec | FE_HAS_LOCK
status 1f | signal 7fff | snr e591 | ber 00000d1e | unc 0000e550 | FE_HAS_LOCK
status 1f | signal 7fff | snr e25a | ber 0000070d | unc 0000e588 | FE_HAS_LOCK
status 1f | signal 7fff | snr e577 | ber 00000681 | unc 0000e5ba | FE_HAS_LOCK
status 1f | signal 7fff | snr e4e9 | ber 00000e03 | unc 0000e62a | FE_HAS_LOCK
^C



--------------040302000209000709010102--
