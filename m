Return-path: <mchehab@gaivota>
Received: from chybek.jannau.net ([83.169.20.219]:58289 "EHLO
	chybek.jannau.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0LOMJy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 07:09:54 -0500
Date: Wed, 15 Dec 2010 13:03:46 +0100
From: Janne Grunau <j@jannau.net>
To: Schubert Andreas <andreas.schubert@die-einrichtung.org>
Cc: linux-media@vger.kernel.org
Subject: Re: budget_av and high load
Message-ID: <20101215120346.GV8381@aniel.fritz.box>
References: <E337B607-FA77-46A4-BB16-1A1700BFC7C3@die-einrichtung.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E337B607-FA77-46A4-BB16-1A1700BFC7C3@die-einrichtung.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Dec 10, 2010 at 01:15:14PM +0100, Schubert Andreas wrote:
> Hello everybody on the list,
> 
> I have a KNC-1 DVB-S card running under kernel 2.6.36 and mythtv. I experience high load values in top like mentioned ages ago in this thread: http://www.linuxtv.org/pipermail/linux-dvb/2008-June/026509.html. 
> My card has no CI-Module installed and the high load was CI-Module related, so I decided to give it a try and completely disable ciintf_init() in the kernel module which helped a lot. Load decreased by 50-80%. So I decided to add a module parameter to disable ciintf_init() on demand. Here is the diff:
> 
> 65,69d64
> < 
> < int budget_init_ci=1;
> < module_param_named(init_ci, budget_init_ci, int, 0644);
> < MODULE_PARM_DESC(init_ci, "Turn on(1)/off(0) ci initializing (default:on).");
> < 
> 1519,1520c1514
> < 	if (budget_init_ci)
> < 	  ciintf_init(budget_av);
> ---
> > 	ciintf_init(budget_av);
> 
> I don't know if this is useful at all so please be patient with me.

It's useful as bug report. I don't think the module parameter makes
sense we should simply fix the bug. I'll look if I can reproduce this
with one of my budget_av DVB-C cards.

Janne
