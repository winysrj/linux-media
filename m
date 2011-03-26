Return-path: <mchehab@pedra>
Received: from blu0-omc3-s15.blu0.hotmail.com ([65.55.116.90]:52278 "EHLO
	blu0-omc3-s15.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752Ab1CZP2c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2011 11:28:32 -0400
Message-ID: <BLU0-SMTP5B9728130D3ED48303AE3D8B80@phx.gbl>
From: "H. Ellenberger" <tuxoholic@hotmail.de>
To: linux-media@vger.kernel.org, manu@linuxtv.org
Date: Sat, 26 Mar 2011 16:22:15 +0100
MIME-Version: 1.0
Subject: Re: Re: S2-3200 switching-timeouts on 2.6.38
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Mar 25, 2011 at 23:23 PM, Manu Abraham <abraham.manu@xxxxxxxxx> wrote:

>
>Can you guys, (who seem to really need the said patch) please provide
>me the STB0899 chipset version on your card ?
>

2 x Twinhan VP-1041 Rev 1.0:

C2L STB0899 VQ637XDV 22 0P9 VQ MLT 22 651
C2L STB0899 VQ628PZF 8P CB5 VQ TWN 22 644


Can you explain what has to be changed in the code and why you are convinced it does does things the wrong way?

This demod patch will even coexist with your work on the tuner, so why not use it?


Regards,

H.E.
