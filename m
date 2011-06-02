Return-path: <mchehab@pedra>
Received: from mailfe07.c2i.net ([212.247.154.194]:56497 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932138Ab1FBKFL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jun 2011 06:05:11 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Lutz Sammer <johns98@gmx.net>
Subject: Re: [PATCH v3 - resend] Fix the derot zig-zag to work with TT-USB2.0 TechnoTrend.
Date: Thu, 2 Jun 2011 12:03:47 +0200
Cc: linux-media@vger.kernel.org
References: <4DE75BE7.4050403@gmx.net>
In-Reply-To: <4DE75BE7.4050403@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106021203.47366.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday 02 June 2011 11:46:15 Lutz Sammer wrote:
> Hello Hans Petter,

Hi,

> 
> I haven't tested your patch yet, but looking at the source I see some
> problems.
> 
> What does your patch fix and how?

It switches from software derot to hardware derot, by writing zero to the 
derot register.

> 
> If you have problem locking channels, try my locking patch:
> https://patchwork.kernel.org/patch/753382/
> 
> On each step (timing, carrier, data) you reset the derot:
>      stb0899_set_derot(state, 0);
> Why?

I have no good reason. It just works.

> 
> Afaik you destroy already locked frequencies, which slows
> down the locking.
> 
> Than you do 8 loops:
>     for (index = 0; index < 8; index++) {
> Why?

> 
> All checks already contains some delays, if the delays are too
> short, you should fix this delays.

I can test patches regarding channel locking. The initial problem was the the 
stb0899 driver would not tune any channels.

--HPS
