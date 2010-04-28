Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4.tech.numericable.fr ([82.216.111.40]:53882 "EHLO
	smtp4.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab0D1IdB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 04:33:01 -0400
Date: Wed, 28 Apr 2010 10:33:03 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: =?UTF-8?B?QW5kcsOp?= Weidemann <Andre.Weidemann@web.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] TT S2-1600 allow more current for diseqc
Message-ID: <20100428103303.2fe4c9ea@zombie>
In-Reply-To: <4BD7E7A3.2060101@web.de>
References: <20100411231805.4bc7fdef@borg.bxl.tuxicoman.be>
	<4BD7E7A3.2060101@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 28 Apr 2010 09:45:39 +0200
André Weidemann <Andre.Weidemann@web.de> wrote:

> I advise not to pull this change into the kernel sources.
> The card has only been testet with the a maximum current of 515mA.
> Anything above is outside the specification for this card.


I'm currently running two of these cards in the same box with this
patch.
Actually, later on I've even set curlim = SEC_CURRENT_LIM_OFF because
sometimes diseqc wasn't working fine and that seemed to solve the
problem.

I used to have skystar2 cards before and I did not run into those
issues. Diseqc just worked fine.

For reference each tt s2 is plugged to a diseqc switch with 4 output,
each output connected to a quad lnb.

Is there another way to solve this ?
Maybe add a module parameter for people who want to override the
default ?

Regards,
  Guy
