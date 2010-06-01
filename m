Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:44024 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852Ab0FAUU2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jun 2010 16:20:28 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	eric.y.miao@gmail.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Soc-camera and 2.6.33
References: <87fx17vmzd.fsf@free.fr>
	<Pine.LNX.4.64.1005312338280.16053@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Tue, 01 Jun 2010 22:20:19 +0200
In-Reply-To: <Pine.LNX.4.64.1005312338280.16053@axis700.grange> (Guennadi Liakhovetski's message of "Mon\, 31 May 2010 23\:51\:43 +0200 \(CEST\)")
Message-ID: <87zkzetsho.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> a lot of things changed in and around soc-camera between 2.6.30 and 
> .33... E.g., previously you could load driver modules in any order, it 
> would work in any case. Now if you load your host driver (pxa) and your 
> client driver is not there yet, it should be automatically loaded. 
> However, if your user-space doesn't support this, it won't work. Can this 
> be the reason gor your problem? Otherwise, I'd suspect a problem with your 
> platform data (cf. other platforms), or, eventually with mt9m111.

I tracked down the beast ... :)

The problem is with the commit a48c24a696f0d93c49f913b7818e9819612b1f4e
"[ARM] pxa/mioa701: convert mioa701 to the new platform-device soc-camera
interface".

This is a tricky one ... :
  - ic_link is declared normally, and references &mioa701_i2c_devices[0]
  - but mioa701_i2c_devices[] is declared as __initdata, and discarded after
  init if I understand correctly.

This implies that the structure ic_link references something not present
anymore, hence my bug. I'm a bit disturbed that the compiler didn't catch that
...

Anyway, now I'll have to send a patch to Eric for that, to remove the
"__initdata" specifier from mioa701_i2c_devices[].

Eric, are you still taking in fix patches for the 2.6.35 kernel ?

Cheers.

--
Robert

PS: I checked for other pxa boards, and they don't suffer from my problem.
