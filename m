Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:39760 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2ALRee (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jan 2012 12:34:34 -0500
Received: by werm1 with SMTP id m1so1535988wer.19
        for <linux-media@vger.kernel.org>; Thu, 12 Jan 2012 09:34:33 -0800 (PST)
Message-ID: <4F0F199F.8080804@gmail.com>
Date: Thu, 12 Jan 2012 18:34:23 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Jim Darby <uberscubajim@gmail.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Possible regression in 3.2 kernel with PCTV Nanostick T2 (em28xx,
 cxd2820r and tda18271)
References: <4F0C3D1B.2010904@gmail.com> <4F0CE040.7020904@iki.fi> <4F0DE0C2.5050907@gmail.com> <4F0F08DB.4050301@gmail.com> <4F0F0BEF.8040002@gmail.com>
In-Reply-To: <4F0F0BEF.8040002@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 12/01/2012 17:35, Jim Darby ha scritto:
> On 12/01/12 16:22, Gianluca Gennari wrote:
>> Hi Jim,
>> you spotted a regression in the latest media_build release from
>> 11/01/2012.
>> I had the same problem here:
>>
>> "dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to
>> delivery system 0"
>>
>> with 3 totally different sticks (em28xx, dvb-usb, as102).
>>
>> Everything was working fine with media_build drivers from 08/01/2011, so
>> the problem originates from a patch committed in the last few days.
>>
>> In fact, I reverted this patch:
>>
>> http://patchwork.linuxtv.org/patch/9443/
>>
>> and Kaffeine started working again with all my DVB-T sticks.
>>
>> Best regards,
>> Gianluca
> 
> I think that we need to be careful about two different problems here.
> 
> The first is the regression that I originally reported. In this case the
> device stops sending data after a variable period of time and we get to
> miss the end of the programme that we're watching.
> 
> The second, which is the one that Gianluca has spotted as well, is that
> there seems to be some form of API change in the latest linux-media
> which is causing kaffeine to stop working.
> 
> I'm still unsure about the first. It might be a 32/64-bit problem (based
> on evidence from Simon Jones), it might be flaky hardware or it might be
> a real problem. I'm planning to build the 3.2.0 kernel (minus the
> linux-media patches) for 64-bit on different hardware and see what happens.

Yes, of course reverting that patch is not going to affect your first issue.

> As for the second I suspect it might be a kaffeine problem. It might
> just need recompiling with the new headers or it might need some work on
> it. I'll investigate that after I've solved the first regression.
> 
> Pedant mode: the kaffeine problem isn't really a regression as such.
> It's more of a API versioning issue. More on this later.
> 
> Hope this helps,
> 
> Jim.
> 

I don't think the intention of that patch was to broke support for DVBv3
applications when using a tuner with a single delivery system.
That would be quite a big API change.

Best regards,
Gianluca

