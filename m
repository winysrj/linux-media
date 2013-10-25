Return-path: <linux-media-owner@vger.kernel.org>
Received: from kripserver.net ([91.143.80.239]:36846 "EHLO mail.kripserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab3JYHGP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Oct 2013 03:06:15 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.kripserver.net (Postfix) with ESMTP id 41CE23AE08F
	for <linux-media@vger.kernel.org>; Fri, 25 Oct 2013 07:06:14 +0000 (UTC)
Received: from mail.kripserver.net ([91.143.80.239])
	by localhost (mail.kripserver.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Qy1UycGFaN7c for <linux-media@vger.kernel.org>;
	Fri, 25 Oct 2013 07:06:13 +0000 (UTC)
Received: from [192.168.189.220] (p5B0D49F7.dip0.t-ipconnect.de [91.13.73.247])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.kripserver.net (Postfix) with ESMTPSA id CEAD23AE08E
	for <linux-media@vger.kernel.org>; Fri, 25 Oct 2013 07:06:12 +0000 (UTC)
Message-ID: <526A1864.7020800@kripserver.net>
Date: Fri, 25 Oct 2013 09:06:12 +0200
From: Jannis <jannis-lists@kripserver.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: NAS for recording DVB-S2
References: <52663659.3040205@gmx.net>
In-Reply-To: <52663659.3040205@gmx.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am 22.10.2013 10:24, schrieb JPT:
> I want my NAS to record from USB DVB-S2.
> [...]
> I should buy either a Tevii S660 or a Terratec Cynergy S2 Stick.
> 
> I don't want to have another power supply, so I am going to "steal" the
> power from the nas somehow.
> The Tevii uses 7,5 V which is odd...
> I cannot find the voltage the Terratec requires. Does anyone own one?

Yesterday I recommended the Technisat SkyStar USB HD to s.o. else on
this list. Though I'm not beeing employed by or affiliated with
Technisat, you might also want to consider it:
http://www.linuxtv.org/wiki/index.php/Technisat_SkyStar_USB_HD
The driver is in mainline kernel (no patching' around), should work well
with ARM (If you want me to test it, I could. There are several
ARM-boards (armv6j-hf, armv7-hf) floating around here, I just didn't yet
bother to try).

The power-supply reads 12V, 1.5A for one device. As you didn't state at
what voltage your NAS runs at, it might just fit or be too high (the 12
Volts) for your application. I have a slightly larger NAS (more a less a
full blown PC with low-enery components) and I power two of the
technisat's off the PC's power supply's 12V rail.

And about the price: it looks like that one is even cheaper than the two
you proposed.

Best regards,
	Jannis

