Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55160 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934Ab2DFMCx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Apr 2012 08:02:53 -0400
Message-ID: <4F7EDB6B.7000402@iki.fi>
Date: Fri, 06 Apr 2012 15:02:51 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Michael_B?= =?ISO-8859-1?Q?=FCsch?= <m@bues.ch>,
	Hans-Frieder Vogt <hfvogt@gmx.net>,
	Gianluca Gennari <gennarone@gmail.com>
Subject: AF9035/AF9033 development
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is TODO list I took from mail I wrote 31.3.2012:

* fix af9033 IF freq control (now Zero-IF only)
DONE

* change firmware download to use new firmware syntax
DONE

* dual tuner support

* check if IT9035 is enough similar (My personal suspicion is that 
integrated tuner is only main difference, whilst USB-interface and demod 
are same. But someone has told that it is quite different design though.)
DONE. It is similar. AF9035 code changes are done. New tuner driver 
still needed.

* implement SNR, BER and USB counters
partly DONE!

* implement remote controller



Remote controller and dual tuner support are main missing features. I 
will try implement remote controller next, maybe later tonight.


regards
Antti
-- 
http://palosaari.fi/
