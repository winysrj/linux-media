Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:33523 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752521Ab1BTAmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Feb 2011 19:42:33 -0500
From: Malte Gell <malte.gell@gmx.de>
To: linux-media@vger.kernel.org
Subject: tm6000 module does not find firmware, despite being there
Date: Sun, 20 Feb 2011 01:42:29 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102200142.30222.malte.gell@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I run a Terratec Cinergy Hybrid Stick with the tm6000 module. The modules 
loads fine, but sometimes I see this message:

xc2028 8-0061: Error: firmware xc3028-v27.fw not found

Actually, the firmware file *is* there in /lib/firmware. What does this error 
mean? Does it have any importance?

Thanx
Malte
