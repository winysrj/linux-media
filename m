Return-path: <mchehab@pedra>
Received: from skyboo.net ([82.160.187.4]:38399 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752852Ab1B1Tpz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 14:45:55 -0500
Message-ID: <4D6BFB6A.1090404@skyboo.net>
Date: Mon, 28 Feb 2011 20:45:46 +0100
From: Mariusz Bialonczyk <manio@skyboo.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: "Igor M. Liplianin" <liplianin@me.by>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <4D3358C5.5080706@skyboo.net> <201102281741.26950.liplianin@me.by> <4D6BC8D4.3080001@linuxtv.org> <201102281901.50579.liplianin@me.by>
In-Reply-To: <201102281901.50579.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] Prof 7301: switching frontend to stv090x, fixing "LOCK
 FAILED" issue
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 02/28/2011 06:01 PM, Igor M. Liplianin wrote:
> For those who ...
> He asked me to get rid of my driver. Why should I?
Maybe because (now) your frontend has problems with tunning on this card?
I though that references are known for you:
1. http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/24573
2. http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/25275
3. http://linuxdvb.org.ru/wbb/index.php?page=Thread&threadID=641

And to be more specific: I am not asking to get rid of your driver,
my patch doesn't touch your stv0900 implementation, it only change the
frontend for one particular card.

> I have 7301, test it myself and see nothing bad with stv0900.
If it is working for you - lucky you! But keep in mind that it it doesn't
mean that it is working for others. Have you tested it with my patch applied?
Besides it is not using your frontend, maybe it just *work*?

> Obviously, I better patch stv0900 then convert the driver to stv090x.
Sure, go ahead... I am only wondering why wasn't you so helpful when I was
trying to contact you and offer debugging help when I discovered the problem
after I started using this card. Your only response was:
"I know this issue. Your card is fine."
So now I resolved the problem myself and sent a working solution (tested
by some people - always with good results) and you disagree now.

I'm only hoping that a hardware *usability* will win over an ego!

regards,
-- 
Mariusz Bialonczyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
