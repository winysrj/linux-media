Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46195 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab0H2RcA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Aug 2010 13:32:00 -0400
Received: by qyk9 with SMTP id 9so2264941qyk.19
        for <linux-media@vger.kernel.org>; Sun, 29 Aug 2010 10:31:59 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 29 Aug 2010 19:31:59 +0200
Message-ID: <AANLkTinB=N3aYUc4L8zLsMcUgdBnbShVA=fKsAWxNb0y@mail.gmail.com>
Subject: Kernel hangs after suspend to ram
From: Andrea Amorosi <andrea.amorosi76@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi to all!
I'm trying to use my Dikom DK-300 usb dvb-t device connected to an old
laptop used as media player.
The device works well but if I suspend to ram the pc when it is
plugged in, the system hangs when I try to resume it.
So I've tryed to create two script to remove the driver before
sleeping (the script is in the /etc/acpi/suspend.d directory) and to
reload it during the resume phase (this script is in
/etc/acpi/resume.d directory).
I've also inserted in the scripts some logs and it seems that the
driver is correctly removed before the suspension, but then the pc
hangs when resuming.
Do you have some suggestion on how to resolve?
Thank you,
Andrea Amorosi
