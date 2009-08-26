Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:49032 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390AbZHZOEb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 10:04:31 -0400
Received: from yoshi.upcore.net (c-83-233-110-151.cust.bredband2.com [83.233.110.151])
	by smtp.bredband2.com (Postfix) with ESMTPA id DCA0CAE591
	for <linux-media@vger.kernel.org>; Wed, 26 Aug 2009 15:53:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by yoshi.upcore.net (Postfix) with ESMTP id B13C2C000140
	for <linux-media@vger.kernel.org>; Wed, 26 Aug 2009 15:53:59 +0200 (CEST)
Received: from yoshi.upcore.net ([127.0.0.1])
	by localhost (mail.upcore.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id GCx35wRuHt5z for <linux-media@vger.kernel.org>;
	Wed, 26 Aug 2009 15:53:57 +0200 (CEST)
Received: from [IPv6:2001:470:9168:1:21b:fcff:fee1:7d85] (unknown [IPv6:2001:470:9168:1:21b:fcff:fee1:7d85])
	by yoshi.upcore.net (Postfix) with ESMTPSA id 360F7C000128
	for <linux-media@vger.kernel.org>; Wed, 26 Aug 2009 15:53:57 +0200 (CEST)
Message-ID: <4A953E52.4020300@upcore.net>
Date: Wed, 26 Aug 2009 15:53:22 +0200
From: Magnus Nilsson <magnus@upcore.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Azurewave AD-CP400 (Twinhan VP-2040 DVB-C)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I've two identical cards of this model, with the sticker on the tuner 
saying:
3139 147 24321G#
CU1216LS/AGIGH-3
SW21 0717
MADE IN INDONESIA

I've been trying as few different kernels, with the current one being 
2.6.30-5.
As far as I can understand these cards have the tda10023 frontend. 
However, when trying s2-liplianin through opensascng (using cardsharing, 
which I can't do without) the machine completely locks up. If I try 
without sasc, and just point mythtv to devices 0 and 1, it doesn't seem 
to hang but then I can only watch FTA channels.

I've also tried mantis-v4l, which for some strange reason detects the 
tda10021 frontend instead of tda10023, hence it doesn't achieve a lock 
at all.

Any ideas?
