Return-path: <mchehab@pedra>
Received: from skyboo.net ([82.160.187.4]:51516 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753325Ab1B1LhH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 06:37:07 -0500
Message-ID: <4D6B88DD.4040500@skyboo.net>
Date: Mon, 28 Feb 2011 12:37:01 +0100
From: Mariusz Bialonczyk <manio@skyboo.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: "Igor M. Liplianin" <liplianin@me.by>
References: <4D3358C5.5080706@skyboo.net>
In-Reply-To: <4D3358C5.5080706@skyboo.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] Prof 7301: switching frontend to stv090x, fixing "LOCK
 FAILED" issue
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 2011-01-16 21:44, Mariusz Bialonczyk wrote:
> Fixing the very annoying tunning issue. When switching from DVB-S2 to DVB-S,
> it often took minutes to have a lock.
 > [...]
> The patch is changing the frontend from stv0900 to stv090x.
> The card now works much more reliable. There is no problem with switching
> from DVB-S2 to DVB-S, tunning works flawless.

Igor, can I get your ACK on this patch?

regards,
-- 
Mariusz Bialonczyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
