Return-path: <mchehab@gaivota>
Received: from ffm.saftware.de ([83.141.3.46]:37186 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab1EKUR0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 16:17:26 -0400
Message-ID: <4DCAEED2.6040906@linuxtv.org>
Date: Wed, 11 May 2011 22:17:22 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: linux-media@vger.kernel.org
Subject: Re: dvb-core/dvb_frontend.c: Synchronizing legacy and new tuning
 API
References: <87sjslaxwz.fsf@nemi.mork.no>
In-Reply-To: <87sjslaxwz.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 05/11/2011 08:34 PM, Bjørn Mork wrote:
> I see in drivers/media/dvb/dvb-core/dvb_frontend.c that there is some
> synchronization between the old and the new API.
> 
> But it is incomplete: The new FE_GET_PROPERTY will report only cached
> values, which is whatever the application has written and not the
> actual tuned values like FE_GET_FRONTEND will.  The problem is that 
> FE_GET_PROPERTY only will call fe->ops.get_property even for legacy
> drivers.  It could have fallen back to calling fe->ops.get_frontend
> followed by a cache synchronization.
> 
> Is this difference intentional (because it costs too much, doesn't
> matter, or whatever)?  Or should I prepare a patch for dvb_frontend.c?

Please try the patches submitted for testing:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg31194.html

Regards,
Andreas
