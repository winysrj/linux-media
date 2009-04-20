Return-path: <linux-media-owner@vger.kernel.org>
Received: from corsa.pop-pr.rnp.br ([200.238.128.2]:57077 "EHLO
	corsa.pop-pr.rnp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbZDTPIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 11:08:09 -0400
Received: from localhost (localhost [127.0.0.1])
	by corsa.pop-pr.rnp.br (Postfix) with ESMTP id 11AED42209
	for <linux-media@vger.kernel.org>; Mon, 20 Apr 2009 12:01:14 -0300 (BRT)
Received: from corsa.pop-pr.rnp.br ([127.0.0.1])
 by localhost (corsa.pop-pr.rnp.br [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 10721-02 for <linux-media@vger.kernel.org>;
 Mon, 20 Apr 2009 12:01:11 -0300 (BRT)
Received: from viper.pop-pr.rnp.br (viper.pop-pr.rnp.br [200.238.128.25])
	by corsa.pop-pr.rnp.br (Postfix) with ESMTP id 1C81842206
	for <linux-media@vger.kernel.org>; Mon, 20 Apr 2009 12:01:11 -0300 (BRT)
To: linux-media@vger.kernel.org
Subject: Current state of DVB-C support
Content-Disposition: inline
From: Christian Lyra <lyra@pop-pr.rnp.br>
Date: Mon, 20 Apr 2009 12:01:30 -0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200904201201.30409.lyra@pop-pr.rnp.br>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

	I´d like to share with you my recent experience with DVB-C cards and a 
Brazilian Provider.
	
	My first attempt to use a DVB-C was with a KNC1 card. I just had to 
download the latest source from dvb repository, compile and install. 
The card was identified, I could scan channels and watch TV. BUT some 
channels works very badly, as the card couldnt lock properly on a few 
transponders (309mhz and 321mhz). Running a czap on those channels 
shows that the card keep "locking" and loosing the lock.
	I thought that the problem could be something with my cabling, so I 
tried my card at a friend´s house with the same results. I also tried a 
attenuator, but without success too.
	  
	On my second attempt I bought a twinhan CAB ci card. Card identified, 
but scan didnt worked. Some googleing later, I got it working by 
commenting the line 1360 in dst.c (!(state->dst_type == 
DST_TYPE_IS_CABLE) &&). To my surprise this card has NO problem locking 
on 309mhz and 321mhz channels. It seems to take a little longer to 
lock/changing channels compared to my twinhan DVB-S card (I´m comparing 
apples and oranges, right?), but so far it´s working ok.

	My third attempt was with a technisat cablestar HD2 card. I used the 
mantis repository to get the card working (is the mantis driver already 
merged with v4l-dvb?). Again, I can scan channels, but the card could 
not  lock on those Transponders. In fact it also take a lot longer to 
lock on a channel, but after it got a lock, it works right.

	Since twinhan works fine, I supose that there´s no problem with my 
cable/splitter. Also, I supose that the chance of two disctinct broken 
tuners is low. A recent thread on TT-1501 shows that, if I understood 
it right, there´s a kind of table where a power level is set to each 
frequency range. Is it possible that my two cards didnt worked on those 
especif transporders because of this kind of setting?  BTW, the two non 
working cards have a TDA10023 demodulator. 

	I´m not a dev, but I would like to help to debug this. How can I help?

p.s. posting to linux-media, as I was told that linux-dvb is deprecated.

-- 
Christian Lyra
POP-PR - RNP
