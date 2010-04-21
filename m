Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:42176 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab0DUH6i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 03:58:38 -0400
Message-ID: <4BCEB022.2040807@linuxtv.org>
Date: Wed, 21 Apr 2010 09:58:26 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab via Mercurial <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, manu@linuxtv.org, user.vdr@gmail.com,
	Klaus.Schmidinger@vdr.de
Subject: Re: [git:v4l-dvb/master] V4L/DVB: Add FE_CAN_PSK_8 to allow apps
 to	identify PSK_8 capable DVB devices
References: <E1O4Rsq-0006zj-NH@www.linuxtv.org>
In-Reply-To: <E1O4Rsq-0006zj-NH@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Mauro Carvalho Chehab wrote:
> Subject: V4L/DVB: Add FE_CAN_PSK_8 to allow apps to identify PSK_8 capable DVB devices
> Author:  Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
> Date:    Sun Apr 11 06:12:52 2010 -0300

I wonder why this patch was applied without any modification. It seems
like, as Manu pointed out, the flag should really indicate support for
Turbo-FEC modes rather than just 8PSK (which is already a subset of
FE_CAN_2G_MODULATION).

Btw., there is also no FE_CAN_APSK_16, FE_CAN_APSK_32 or FE_CAN_DQPSK.

Also, I'm unsure how to instruct a driver whether to choose Turbo-FEC
mode or not in case it supports both DVB-S2 and what's used in the US.

Third, it was stated that cx24116's support for Turbo-FEC was untested
and probably unsupported.

So I'd vote for reverting this patch until these issues are cleared.

If my assumptions above are correct, my proposal is to rename the flag
 to FE_CAN_TURBO_FEC (as Manu proposed earlier) and remove it from
cx24116.c.

Regards,
Andreas
