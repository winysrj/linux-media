Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35421 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2ALQWz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jan 2012 11:22:55 -0500
Received: by wgbds12 with SMTP id ds12so1978140wgb.1
        for <linux-media@vger.kernel.org>; Thu, 12 Jan 2012 08:22:54 -0800 (PST)
Message-ID: <4F0F08DB.4050301@gmail.com>
Date: Thu, 12 Jan 2012 17:22:51 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Jim Darby <uberscubajim@gmail.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Possible regression in 3.2 kernel with PCTV Nanostick T2 (em28xx,
 cxd2820r and tda18271)
References: <4F0C3D1B.2010904@gmail.com> <4F0CE040.7020904@iki.fi> <4F0DE0C2.5050907@gmail.com>
In-Reply-To: <4F0DE0C2.5050907@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 11/01/2012 20:19, Jim Darby ha scritto:
> On 11/01/12 01:05, Antti Palosaari wrote:
>> [snip]
>> Also latest LinuxTV.org devel could be interesting to see. There is
>> one patch that changes em28xx driver endpoint configuration. But as
>> that patch is going for 3.3 it should not be cause of issue, but I
>> wonder if it could fix... Use media_build.git if possible.
> 
> Well, I built the kernel and installed it. Sadly I get entries of the
> form: "dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3
> call to delivery system 0" which isn't what I was looking for. I guess
> there's a new API? It would appear this is from the set frontend call.
> 
> This is most annoying as I'd like to try out the newest code.
> 
> Is there a v3 to v3 transition document anywhere?
> 
> Best regards,
> 
> Jim.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Jim,
you spotted a regression in the latest media_build release from
11/01/2012.
I had the same problem here:

"dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to
delivery system 0"

with 3 totally different sticks (em28xx, dvb-usb, as102).

Everything was working fine with media_build drivers from 08/01/2011, so
the problem originates from a patch committed in the last few days.

In fact, I reverted this patch:

http://patchwork.linuxtv.org/patch/9443/

and Kaffeine started working again with all my DVB-T sticks.

Best regards,
Gianluca
