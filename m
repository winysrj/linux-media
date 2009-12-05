Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39711 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbZLEPcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2009 10:32:12 -0500
Received: by ewy19 with SMTP id 19so3952774ewy.1
        for <linux-media@vger.kernel.org>; Sat, 05 Dec 2009 07:32:18 -0800 (PST)
From: Alexey Chernov <4ernov@gmail.com>
To: linux-media@vger.kernel.org
Subject: Support of Gotview X5 3D card
Date: Sat, 5 Dec 2009 18:31:57 +0300
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912051831.57156.4ernov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I have Gotview X5 3D Hybrid PCI-E card (selector XCEIVE 5000, decoder CX23887, 
demodulator ZL10353). I tried to switch on it in Linux, but it seems it's not 
supported (cx23885 driver says board: UNKNOWN/GENERIC). But I've read that's 
not that very difficult to add necessary information about it to get it work, 
but I never read a detailed instructions how to do it.

Could you please tell me what should I do to get it supported? I'm C++ 
programmer myself but not familiar with Linux kernel very much. So any 
detailed instruction where to add necessary structures would be great. I also 
can gather information about the card (GPIO etc.) if it should be added by 
kernel maintainers only.

Thank you in advance.

Alexey Chernov.
