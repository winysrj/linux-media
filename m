Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:47538 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab1K1Q5j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 11:57:39 -0500
Message-ID: <4ED3BD7F.1020406@linuxtv.org>
Date: Mon, 28 Nov 2011 17:57:35 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Jens Erdmann <Jens.Erdmann@web.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: Add Terratec Cinergy HTC Stick
References: <11607963.5467764.1322494881126.JavaMail.fmail@mwmweb051>
In-Reply-To: <11607963.5467764.1322494881126.JavaMail.fmail@mwmweb051>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jens,

On 28.11.2011 16:41, Jens Erdmann wrote:
> Hi folks,
> 
> just a few quetstions:
> 1. Why is the device named EM2884_BOARD_CINERGY_HTC_STICK and not
>     EM2884_BOARD_TERRATEC_HTC_STICK like all the other devices from that
>     vendor? Looks inconsistent to me.

that's because it's the product name. Even though TERRATEC is the
vendor, the TERRATEC series of devices is different from the Cinergy
series (mostly due to software bundles, IMHO). See their homepage for
details.

So, TERRATEC_HTC_STICK would be wrong. You could change it to
TERRATEC_CINERGY_HTC_STICK, if it's important to you. However, following
the same logic, the TERRATEC H5 should then be called
TERRATEC_TERRATEC_H5, which seems rather odd.

Btw.: The em28xx driver wrongly lists the H5 as "Terratec Cinergy H5".

> 2. I stumbled over http://linux.terratec.de/tv_en.html where they list a NXP TDA18271
>     as used tuner for H5 and HTC Stick devices. I dont have any experience in this
>     kind of stuff but i am just asking.

That's right.

Regards,
Andreas
