Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.youplala.net ([88.191.51.216]:51407 "EHLO mail.youplala.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbZD3FZI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 01:25:08 -0400
Received: from [10.11.11.141] (host86-148-32-100.range86-148.btcentralplus.com [86.148.32.100])
	by mail.youplala.net (Postfix) with ESMTPSA id 4ECA0D880AC
	for <linux-media@vger.kernel.org>; Thu, 30 Apr 2009 07:15:25 +0200 (CEST)
Subject: Nova-T 500 does not survive reboot
From: Nicolas Will <nico@youplala.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Thu, 30 Apr 2009 06:15:23 +0100
Message-Id: <1241068523.4632.8.camel@youkaida>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I am running an hg clone from a few days ago with firmware 1.20 on a
64-bit Ubuntu Intrepid (2.6.27 kernel).

I have noticed that for some time now the card/driver/firmware
combination does not like warm reboots.

If I reboot the system and try to use any Nova-T 500 tuner, I
immediately get the mt2060 I2C errors.

If I completely shut down the system, remove the power, then reboot, all
is fine.

I have missed most of the linux-media traffic, I was still stuck on
linux-dvb. Have I missed some discussions about this?

Thanks!

Nico

