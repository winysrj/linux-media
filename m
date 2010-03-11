Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:61109 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954Ab0CKPsr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 10:48:47 -0500
Received: by fxm5 with SMTP id 5so202449fxm.29
        for <linux-media@vger.kernel.org>; Thu, 11 Mar 2010 07:48:45 -0800 (PST)
MIME-Version: 1.0
From: Piotr Oleszczyk <pataczek@gmail.com>
Date: Thu, 11 Mar 2010 16:48:25 +0100
Message-ID: <d3858cac1003110748w6c149a86jf2651151a5462c45@mail.gmail.com>
Subject: Hama DVB-T Hybrid USB Stick support
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I bought a Hama DVB-T Hybrid stick (147f:2758). I haven't found it in
supported devices list though it was extremely cheap, so I risked.
It's not working, but I opened it and found that it's a clone of
TerraTec Cinergy HT USB XE. It uses DIB7700C1, XC3028 and CX25843.
I tried to make a patch on my own, however it's too complicated to
find out what to modificate.
The thing is to make it discoverable. Everything is already contained in driver.
It would be great if somebody will lead me or make a finished patch.

Thank you
Piotrek
