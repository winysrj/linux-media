Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366Ab0DUOfA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 10:35:00 -0400
Message-ID: <4BCF0D03.3030802@redhat.com>
Date: Wed, 21 Apr 2010 11:34:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: linux-media@vger.kernel.org, manu@linuxtv.org, user.vdr@gmail.com,
	Klaus.Schmidinger@vdr.de
Subject: Re: [git:v4l-dvb/master] V4L/DVB: Add FE_CAN_PSK_8 to allow apps
 to	identify PSK_8 capable DVB devices
References: <E1O4Rsq-0006zj-NH@www.linuxtv.org> <4BCEB022.2040807@linuxtv.org>
In-Reply-To: <4BCEB022.2040807@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andreas Oberritter wrote:
> Hello Mauro,
> 
> Mauro Carvalho Chehab wrote:
>> Subject: V4L/DVB: Add FE_CAN_PSK_8 to allow apps to identify PSK_8 capable DVB devices
>> Author:  Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
>> Date:    Sun Apr 11 06:12:52 2010 -0300
> 
> I wonder why this patch was applied without any modification. It seems
> like, as Manu pointed out, the flag should really indicate support for
> Turbo-FEC modes rather than just 8PSK (which is already a subset of
> FE_CAN_2G_MODULATION).

It is partially due to Patchwork's fault, plus my hurry of trying to handle my long
queue after returning for a one week trip. Unfortunately, the patchwork xml support 
only provides the patch on the mbox format, stripping all the patch history, just 
like if you click at the <mbox> link on the patch:

	https://patchwork.kernel.org/patch/91888/mbox/

So, the patch comments appear as:

>From patchwork Sun Apr 11 09:12:52 2010
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Add FE_CAN_PSK_8 to allow apps to identify PSK_8 capable DVB devices
Date: Sun, 11 Apr 2010 09:12:52 -0000
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
X-Patchwork-Id: 91888
Message-Id: <4BC19294.4010200@tvdr.de>
To: linux-media@vger.kernel.org

The enum fe_caps provides flags that allow an application to detect
whether a device is capable of handling various modulation types etc.
A flag for detecting PSK_8, however, is missing.
This patch adds the flag FE_CAN_PSK_8 to frontend.h and implements
it for the gp8psk-fe.c and cx24116.c driver (apparently the only ones
with PSK_8). Only the gp8psk-fe.c has been explicitly tested, though.

Signed-off-by: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Tested-by: Derek Kelly <user.vdr@gmail.com>
Acked-by: Manu Abraham <manu@linuxtv.org>

I generally take a look at the full patch history at the email, but, as the last
tag was an ack, and no nacked-by: tags were added on the patch, I assumed that
the patch were fine to apply.

People should not add a formal "acked-by" tag if the patch is not ready
yet to be committed.

I've submitted an email to patchwork ML asking for they to fix this bad behavior.
Let's see if this could be corrected on newer versions of the tool.

> 
> Btw., there is also no FE_CAN_APSK_16, FE_CAN_APSK_32 or FE_CAN_DQPSK.
> 
> Also, I'm unsure how to instruct a driver whether to choose Turbo-FEC
> mode or not in case it supports both DVB-S2 and what's used in the US.
> 
> Third, it was stated that cx24116's support for Turbo-FEC was untested
> and probably unsupported.

Btw, the DocBook describing the FE_CAN features (frontend.xml) is outdated. I
suggest to add the remaining features there, to keep the specs updated.

> So I'd vote for reverting this patch until these issues are cleared.

Ok, I'll do it.

> If my assumptions above are correct, my proposal is to rename the flag
>  to FE_CAN_TURBO_FEC (as Manu proposed earlier) and remove it from
> cx24116.c.
> 
> Regards,
> Andreas


-- 

Cheers,
Mauro
