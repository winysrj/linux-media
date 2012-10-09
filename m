Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab2JIWfB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 18:35:01 -0400
Date: Tue, 9 Oct 2012 19:34:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: =?UTF-8?B?UsOpbWk=?= Cardona <remi@gentoo.org>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Subject: Re: [git:v4l-dvb/for_v3.7] [media] ds3000: add module parameter to
 force firmware upload
Message-ID: <20121009193445.351aecff@redhat.com>
In-Reply-To: <1349724224.2142.11.camel@exos>
References: <1349724224.2142.11.camel@exos>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 08 Oct 2012 21:23:44 +0200
Rémi Cardona <remi@gentoo.org> escreveu:

> Hi Mauro,
> 
> There's indeed a conflict since (as far as I can tell) only patch #6 of
> a 7 patch series was applied.
> 
> The entire patch series is:
>  - http://patchwork.linuxtv.org/patch/14752/
>  - http://patchwork.linuxtv.org/patch/14749/
>  - http://patchwork.linuxtv.org/patch/14753/
>  - http://patchwork.linuxtv.org/patch/14750/
>  - http://patchwork.linuxtv.org/patch/14751/
>  - http://patchwork.linuxtv.org/patch/14747/ (which is somewhat applied)
>  - http://patchwork.linuxtv.org/patch/14748/
> 
> Maybe it would be safer to revert patch #6 to cleanly reapply the entire
> series?

This patch is independent of the other stuff. I don't see a good reason
to revert it.

I'm keeping most of the patches for ds3000 in hold, as this driver should
be broken into two separate drivers. I provided already a feedback on
the patch series that splits this driver. So, I'm waiting for his new
patchset. Only after that change, I'll be handling other patches for ds3000,
as it will make easier to review and understand this driver.

> As for the "force firmware load" patch, the reason for that patch was
> that some cards report already having a firmware (despite having been
> powered off for a while) when in fact they don't. Reloading the ds3000
> module with this new option allows those cards to work properly. Out of
> the thousand S470/471 cards we have in production, only a tiny fraction
> require this option. That's why I didn't change the default behavior.

Wouldn't be better then to add it at the boards configuration, instead of
using a modprobe parameter?

Regards,
Mauro
