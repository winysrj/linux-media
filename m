Return-path: <mchehab@localhost>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33161 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab0IEPsA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Sep 2010 11:48:00 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimXP-3OkoNCjTgrQmo29F0t-TmA9p4utAG2M3Qp@mail.gmail.com>
References: <AANLkTimXP-3OkoNCjTgrQmo29F0t-TmA9p4utAG2M3Qp@mail.gmail.com>
Date: Sun, 5 Sep 2010 11:48:00 -0400
Message-ID: <AANLkTim_HujYzL5SyotRb7w6-ZTc3_BtO=+YhCpnSzBT@mail.gmail.com>
Subject: Re: some question about
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: loody <miloody@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

On Sun, Sep 5, 2010 at 11:36 AM, loody <miloody@gmail.com> wrote:
> WinTV-HVR-1950 high performance USB TV tuner
> WinTV-HVR-950Q for laptop and notebooks

Both these devices are supported under Linux, and in fact are unlikely
to work properly with only Full Speed USB.  At least the 950q
definitely requires High speed (I put a check in there to specifically
not load the driver otherwise).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
