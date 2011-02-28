Return-path: <mchehab@pedra>
Received: from skyboo.net ([82.160.187.4]:42740 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752562Ab1B1WYr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 17:24:47 -0500
Message-ID: <4D6C20A0.40705@skyboo.net>
Date: Mon, 28 Feb 2011 23:24:32 +0100
From: Mariusz Bialonczyk <manio@skyboo.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: "Igor M. Liplianin" <liplianin@me.by>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <4D3358C5.5080706@skyboo.net> <201102281901.50579.liplianin@me.by> <4D6BFB6A.1090404@skyboo.net> <201102282237.07948.liplianin@me.by>
In-Reply-To: <201102282237.07948.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] Prof 7301: switching frontend to stv090x, fixing "LOCK
 FAILED" issue
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 02/28/2011 09:37 PM, Igor M. Liplianin wrote:
> Sorry, I have nothing against you personally.
me too :)

> I have excuses, but you not intresting, I think.
> Peace, friendship, chewing gum, like we use to say in my childhood :)
> 
> Switching to other driver not helps me, so be patient.
> 
> I patched stv0900 and send pull request.
I've tested it - and for the first sight it seems that it indeed
solves the problem. Thank you :)

And about frontend: I think I found a solution which I hope will
satisfy all of us. I think it would be great if user have
an alternative option to use stv090x frontend anyway. I mean your
frontend as default, but a module parameter which enables using
stv090x instead of stv0900 (enabling what's is inside my patch).
This will be a flexible solution which shouldn't harm anyone,
but instead gives an option.

Igor, Mauro, do you have objections against this solution?
If you agree, then I'll try to prepare an RFC patch for that.

regards,
-- 
Mariusz Bialonczyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
