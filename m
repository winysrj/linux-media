Return-path: <mchehab@gaivota>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50368 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab0KURC6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Nov 2010 12:02:58 -0500
Received: by fxm13 with SMTP id 13so2002619fxm.19
        for <linux-media@vger.kernel.org>; Sun, 21 Nov 2010 09:02:56 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 21 Nov 2010 17:02:56 +0000
Message-ID: <AANLkTinAKjPBWMPBoKgvQLpDj29L9T9+aimqhdC29Vos@mail.gmail.com>
Subject: Problem with HVR 900 (B2C0) and USB detection
From: Mike Martin <mike@redtux.org.uk>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi

I have been using this device for years using Markuses Driver.

Now for some bizarre reason using both this driver and devins the
wrong USB driver is being used (ohci rather than ehci), which means it
is recognised as a USB 1.1 device, which makes it stop working

Anyone know if there is any way to force it to use USB 2

Other usb devices use the correct usb speed

thanks
