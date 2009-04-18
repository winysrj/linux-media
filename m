Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.adamobredband.com ([91.126.224.27]:50093 "EHLO
	smtp.adamobredband.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbZDRT3P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Apr 2009 15:29:15 -0400
Received: from asrock (c-94-255-208-135.cust.bredband2.com [94.255.208.135])
	by smtp.adamobredband.com (Postfix) with ESMTP id 645717C302
	for <linux-media@vger.kernel.org>; Sat, 18 Apr 2009 21:29:14 +0200 (CEST)
From: "Sacha" <sacha@hemmail.se>
To: <linux-media@vger.kernel.org>
Subject: How to compile Mantis driver with em28xx driver installed?
Date: Sat, 18 Apr 2009 21:29:12 +0200
Message-ID: <000001c9c05b$f4d7f380$0401a8c0@asrock>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="x-user-defined"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I have a Pinnacle USB DVB-T stick and Azurwave Azurewave AD-SP400 CI
(Twinhan VP-1041) DVB-S2 on my system.
USB stick uses em28xx-new drivers from mcentral.
It works well untill I install Mantis/S2API drivers from I. Liplianin.
I get my DVB-S2 card workin but em28xx drivers wont load complaining
about unknown symbol etc...
If I understand well S2API installation overwrite some files used by
em28xx driver with its own leading to this conflict.
My question is how to avoide this? I want both cards working.

KR

