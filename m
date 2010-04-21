Return-path: <linux-media-owner@vger.kernel.org>
Received: from crow.cadsoft.de ([217.86.189.86]:55717 "EHLO raven.cadsoft.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab0DUIvN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 04:51:13 -0400
Received: from [192.168.1.71] (falcon.cadsoft.de [192.168.1.71])
	by raven.cadsoft.de (8.14.3/8.14.3) with ESMTP id o3L8k8kK021692
	for <linux-media@vger.kernel.org>; Wed, 21 Apr 2010 10:46:09 +0200
Message-ID: <4BCEBB50.6040105@tvdr.de>
Date: Wed, 21 Apr 2010 10:46:08 +0200
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-media] Re: [git:v4l-dvb/master] V4L/DVB: Add FE_CAN_PSK_8
 to allow apps to	identify PSK_8 capable DVB devices
References: <E1O4Rsq-0006zj-NH@www.linuxtv.org> <4BCEB022.2040807@linuxtv.org>
In-Reply-To: <4BCEB022.2040807@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/21/10 09:58, Andreas Oberritter wrote:
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
> 
> Btw., there is also no FE_CAN_APSK_16, FE_CAN_APSK_32 or FE_CAN_DQPSK.
> 
> Also, I'm unsure how to instruct a driver whether to choose Turbo-FEC
> mode or not in case it supports both DVB-S2 and what's used in the US.
> 
> Third, it was stated that cx24116's support for Turbo-FEC was untested
> and probably unsupported.
> 
> So I'd vote for reverting this patch until these issues are cleared.
> 
> If my assumptions above are correct, my proposal is to rename the flag
>  to FE_CAN_TURBO_FEC (as Manu proposed earlier) and remove it from
> cx24116.c.

That's what I was intending to do - time permitting ;-)
I was also surprised that the patch got applied, since I was in the
middle of discussing this with Manu...

Klaus
