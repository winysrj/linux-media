Return-path: <mchehab@pedra>
Received: from skyboo.net ([82.160.187.4]:59893 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754890Ab0KRHYd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 02:24:33 -0500
Received: from localhost ([::1])
	by skyboo.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <manio@skyboo.net>)
	id 1PIyr3-0006Nv-2R
	for linux-media@vger.kernel.org; Thu, 18 Nov 2010 08:24:25 +0100
Message-ID: <4CE4D4AC.5060201@skyboo.net>
Date: Thu, 18 Nov 2010 08:24:28 +0100
From: =?UTF-8?B?TWFyaXVzeiBCaWHFgm/FhGN6eWs=?= <manio@skyboo.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
References: <1290062581.41867.321546213719.1.gpush@pororo>
In-Reply-To: <1290062581.41867.321546213719.1.gpush@pororo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] V4L/DVB: cx88: Add module parameter to disable IR
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 2010-11-18 07:43, Jeremy Kerr wrote:
> Currently, the cx88-input code unconditionally establishes an input
> device for IR events. On some cards, this sets up a hrtimer to poll the
> IR status frequently - I get around 200 wakeups per second from this
> polling, and don't use the IR ports.
>
> Although the hrtimer is only run when the input device is opened, the
> device is actually unconditionally opened by kbd_connect, because we
> have the EV_KEY bit set in the input device descriptor. In effect, the
> IR device is always opened (and so polling) if CONFIG_VT.
>
> This change adds a module parameter, 'ir_disable' to disable the IR
> code, and not register this input device at all. This drastically
> reduces the number of wakeups per second for me.

AFAIK we have disable support in cx88:
http://git.linuxtv.org/media_tree.git?a=commit;h=89c3bc78075042ae1f4452687f626acce06b3b21

isn't it related with your patch?

-- 
Mariusz Białończyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
