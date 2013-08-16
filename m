Return-path: <linux-media-owner@vger.kernel.org>
Received: from skyboo.net ([82.160.187.4]:37367 "EHLO skyboo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab3HPHqy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Aug 2013 03:46:54 -0400
Message-ID: <520DD27F.8020708@skyboo.net>
Date: Fri, 16 Aug 2013 09:19:27 +0200
From: Mariusz Bialonczyk <manio@skyboo.net>
MIME-Version: 1.0
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Chris Lee <updatelee@gmail.com>
References: <CAA9z4Lbd5wm0=T=CGHbxga5wOdj+TZQO2BA+spxV_keWS5OmcQ@mail.gmail.com>
In-Reply-To: <CAA9z4Lbd5wm0=T=CGHbxga5wOdj+TZQO2BA+spxV_keWS5OmcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: stv090x vs stv0900 support
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/24/2013 06:39 PM, Chris Lee wrote:
> Im looking for comments on these two modules, they overlap support for
> the same demods. stv0900 supporting stv0900 and stv090x supporting
> stv0900 and stv0903. Ive flipped a few cards from one to the other and
> they function fine. In some ways stv090x is better suited. Its a pain
> supporting two modules that are written differently but do the same
> thing, a fix in one almost always means it has to be implemented in
> the other as well.
I totally agree with you.

> Im not necessarily suggesting dumping stv0900, but Id like to flip a
> few cards that I own over to stv090x just to standardize it. The Prof
> 7301 and Prof 7500.
I did it already for 7301, see here:
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/28082
but due to 'political' reasons it doesn't went upstream.
For private use i am still using this patch on recent kernels, because
it is working much more stable for my card comparing to stv0900.
I think that moving prof 7500 should be relative easy, i even prepared
a patch for this but I was not able to test it due to lack of hardware.

> Whats everyones thoughts on this? It will cut the number of patch''s
> in half when it comes to these demods. Ive got alot more coming lol :)
Oh yes, you could also take into account another duplicate code:
stb6100_cfg.h used for stv090x
stb6100_proc.h used for stv0900
In my patch I've successfully switched to stb6100_cfg.h.
> 
> Chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

regards,
-- 
Mariusz Białończyk | xmpp/e-mail: manio@skyboo.net
http://manio.skyboo.net | https://github.com/manio

