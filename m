Return-path: <linux-media-owner@vger.kernel.org>
Received: from nschwqsrv01p.mx.bigpond.com ([61.9.189.231]:49474 "EHLO
	nschwqsrv01p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252Ab1HNMHq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 08:07:46 -0400
Received: from nschwotgx01p.mx.bigpond.com ([121.214.104.126])
          by nschwmtas06p.mx.bigpond.com with ESMTP
          id <20110814092129.UQKX18547.nschwmtas06p.mx.bigpond.com@nschwotgx01p.mx.bigpond.com>
          for <linux-media@vger.kernel.org>;
          Sun, 14 Aug 2011 09:21:29 +0000
Received: from max.localnet ([121.214.104.126])
          by nschwotgx01p.mx.bigpond.com with ESMTP
          id <20110814092129.GPZX2024.nschwotgx01p.mx.bigpond.com@max.localnet>
          for <linux-media@vger.kernel.org>;
          Sun, 14 Aug 2011 09:21:29 +0000
From: Declan Mullen <declan.mullen@bigpond.com>
To: linux-media@vger.kernel.org
Subject: How to git and build HVR-2200 drivers from Kernel labs ?
Date: Sun, 14 Aug 2011 19:21:30 +1000
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108141921.30627.declan.mullen@bigpond.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I've got a 8940 edition of a Hauppauge HVR-2200. The driver is called saa7164. 
The versions included in my OS (mythbuntu 10.10 x86 32bit, kernel 2.6.35-30) 
and from linuxtv.org are too old to recognise the 8940 edition. Posts #124 to 
#128 in the "Hauppauge HVR-2200 Tuner Install Guide" topic 
(http://www.pcmediacenter.com.au/forum/topic/37541-hauppauge-hvr-2200-tuner-
install-guide/page__view__findpost__p__321195) document my efforts with those 
versions.

So I wish to use the latest stable drivers from the driver maintainers, ie 
http://kernellabs.com/gitweb/?p=stoth/saa7164-stable.git;a=summary

Problem is, I don't know git and I don't know how I'm suppose to git, build 
and install it.  

Taking a guess I've tried:
  git clone git://kernellabs.com/stoth/saa7164-stable.git 
  cd saa7164-stable
  make menuconfig
  make

However I suspect these are not the optimum steps, as it seems to have 
downloaded and built much more than just the saa7164 drivers. The git pulled 
down nearly 1GB (which seems a lot) and the resultant menuconfig produced a 
very big ".config".

Am I doing the right steps or should I be doing something else to git, build 
and install  the latest drivers ?

Thanks,
Declan
