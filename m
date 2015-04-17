Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:60129 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbbDQJGd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2015 05:06:33 -0400
Date: Fri, 17 Apr 2015 11:06:30 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Jemma Denson <jdenson@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for TechniSat Skystar S2
Message-ID: <20150417110630.554290f5@dibcom294.coe.adi.dibcom.com>
In-Reply-To: <552B62EF.8050705@gmail.com>
References: <201504122132.t3CLW6fQ018555@jemma-pc.denson.org.uk>
	<552B62EF.8050705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jemma,

Thanks for taking this one. I had this on my list for years.

On Mon, 13 Apr 2015 07:32:15 +0100 Jemma Denson <jdenson@gmail.com>
wrote:

> Oh, I was doing this the wrong way then. I did have some preamble to
> this but it seems to have been stripped.
> 
> Anyway, this patch adds support for the Technisat Skystar S2 - this
> has been tried before but the cx24120 driver was a bit out of shape
> and it didn't got any further:
> https://patchwork.linuxtv.org/patch/10575/
> 
> It is an old card, but currently being sold off for next to nothing,
> so it's proving quite popular of late.
> Noticing it's quite similar to the cx24116 and cx24117 I've rewritten
> the driver in a similar way. There were a few registers and commands
> from those drivers missing from this one I've tested out and found
> they do something so they've been added in to speed up tuning and to
> make get_frontend return something useful.

If time allows it I will try to install and test your driver this
weekend or, at the latest, next weekend.

> I've only got access to 28.2E, but everything I've tried seems to work
> OK, on both the v3 and v5 APIs. Assuming I've read the APIs and some
> of the modern drivers OK it should be doing things in the reasonably
> modern way, but if anything else needs doing let me know.

I have my Skystar S2 pointed to 19.2E.

To prepare an integration into 4.2 (or at least 4.3) I suggest using my
media_tree on linuxtv.org .

http://git.linuxtv.org/cgit.cgi/pb/media_tree.git/ cx24120-v2

I added a checkpatch-patch on top of it. If you can, please base any
future work of yours on this tree until is has been integrated.

Please also tell me, whether you are OK with the comment I added around
your commit or not.

Thanks,
--
Patrick.
