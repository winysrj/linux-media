Return-path: <linux-media-owner@vger.kernel.org>
Received: from moh2-ve3.go2.pl ([193.17.41.208]:50444 "EHLO moh2-ve3.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab2JHOj5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Oct 2012 10:39:57 -0400
Received: from moh2-ve3.go2.pl (unknown [10.0.0.208])
	by moh2-ve3.go2.pl (Postfix) with ESMTP id 78A6E373B46
	for <linux-media@vger.kernel.org>; Mon,  8 Oct 2012 16:39:55 +0200 (CEST)
Received: from unknown (unknown [10.0.0.108])
	by moh2-ve3.go2.pl (Postfix) with SMTP
	for <linux-media@vger.kernel.org>; Mon,  8 Oct 2012 16:39:55 +0200 (CEST)
Message-ID: <5072E5BA.2020205@tlen.pl>
Date: Mon, 08 Oct 2012 16:39:54 +0200
From: Wojciech Myrda <vojcek@tlen.pl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Mariusz Bialonczyk <manio@skyboo.net>
Subject: Bugs in DVB-S Prof-Tuner 8000 driver (idle & suspend)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am using these new driver http://patchwork.linuxtv.org/patch/14300/
for my card. It generally works great allowing me to send DiseqC
commands, tune to LNBs etc but only as long as I do not use idle or
suspend with it which in first circumstance leads to kernel panics for
which I acquired number of pictures http://bigvo.dyndns.org/dvb/cx23885/
and in second requires reloading the driver to work properly


CARD INFO
[    4.600476] cx23885 driver version 0.0.3 loaded
[    4.600828] CORE cx23885[0]: subsystem: 8000:3034, board: Prof
Revolution DVB-S2 8000 [card=37,autodetected]
[    5.334312] cx23885_dvb_register() allocating 1 frontend(s)
[    5.334342] cx23885[0]: cx23885 based dvb card
[    5.423938] DVB: registering new adapter (cx23885[0])
[    5.424427] cx23885_dev_checkrevision() Hardware revision = 0xb0
[    5.424437] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16,
latency: 0, mmio: 0xfe600000

More info here: http://bigvo.dyndns.org/dvb/

If anyone is willing to take time and effort to improve the code for the
driver I would greatly appreciate it and I am willing to test it

Regards,
_WM
