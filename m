Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51537 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab0KRUHa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 15:07:30 -0500
Received: by ewy5 with SMTP id 5so28998ewy.19
        for <linux-media@vger.kernel.org>; Thu, 18 Nov 2010 12:07:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CE5858E.10905@free.fr>
References: <4CDFF446.2000403@free.fr>
	<4CE0047D.8060401@arcor.de>
	<4CE03704.4070300@free.fr>
	<20101115091544.GA23490@linux-m68k.org>
	<4CE1715B.2070403@arcor.de>
	<4CE19F86.3010901@free.fr>
	<4CE1A13C.9000707@arcor.de>
	<4CE2E8FE.2030004@free.fr>
	<4CE2EA70.3060306@arcor.de>
	<4CE2ECB2.2010004@free.fr>
	<4CE2EF14.40007@arcor.de>
	<4CE42E0D.6030903@free.fr>
	<4CE5858E.10905@free.fr>
Date: Thu, 18 Nov 2010 15:07:28 -0500
Message-ID: <AANLkTikazW-kgDvVR0WtTmksMBNxjFigFvYgJSZ5zRa0@mail.gmail.com>
Subject: Re: HVR900H : IR Remote Control
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Massis Sirapian <msirapian@free.fr>
Cc: Stefan Ringel <stefan.ringel@arcor.de>,
	Richard Zidlicky <rz@linux-m68k.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Nov 18, 2010 at 2:59 PM, Massis Sirapian <msirapian@free.fr> wrote:
> Does it mean that the IR isn't wired in the case of HVR900H ? When you said
> that your Terratec equals the HVR900H, does it imply that if IR works on
> cinergy xe, it should on the HVR900H?

One thing you may wish to consider is that if I recall the Terratec
remotes are typically NEC and the Hauppauge remotes are typically RC5.
 So it's possible that only the NEC support is working in the current
tm6010 driver, which is why the Hauppauge remote doesn't work.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
