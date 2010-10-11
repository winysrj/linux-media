Return-path: <mchehab@pedra>
Received: from psmtp08.wxs.nl ([195.121.247.22]:64589 "EHLO psmtp08.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113Ab0JKTVc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 15:21:32 -0400
Received: from localhost.sitecomwl312
 (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp08.wxs.nl (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14
 2006)) with ESMTP id <0LA500MEL4FQGH@psmtp08.wxs.nl> for
 linux-media@vger.kernel.org; Mon, 11 Oct 2010 21:21:31 +0200 (MEST)
Date: Mon, 11 Oct 2010 21:21:25 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: rtl2831-r2 still not working for Compro VideoMate U80
In-reply-to: <1286669246.3990.44.camel@linux-efue.site>
To: spam.ugnius40@gmail.com
Cc: linux-media@vger.kernel.org
Message-id: <4CB363B5.50101@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <1286669246.3990.44.camel@linux-efue.site>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Could you try:

http://linuxtv.org/hg/~anttip/qt1010/

Previous users of Compro VideoMate U80 has a qt1010 tuner, which 
required that branch.

Ugnius Soraka wrote:
> Hi,
>
> I'd like to get in touch with driver developers, is there any way I
> could help make RTL2831U driver work with Compro VideoMate U80. I would
> like to actively participate. My programming skills are well below
> required to write kernel modules, so I know I would be no use there. But
> anything else, testing with VideoMate U80, sending debug logs, I think I
> could do that.
>
> I've tried http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2 driver, it
> looked promising. U80 device was recognised as VideoMate U90, /dev/dvb
> entries were created. But when scanning it says there's no signal. Debug
> gives TPS_NON_LOCK, Signal NOT Present, rtd2830_soft_reset, etc. (I
> could post message log, if it's any use to somebody).
> U80 has a led which (on windows) shows if TV stick is tuned in and
> working, when scanning on linux it's always on.
>
> I've also tried to compile http://linuxtv.org/hg/~anttip/rtl2831u/ but
> for now it's based on old dvb tree and seems to be incompatible with new
> kernels (mine 2.6.34.7-0.3).
>
> Is anttip driver supposed to be included in kernel, but it looks like
> development is going slow.
>
> Thank you,
> Ugnius
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
