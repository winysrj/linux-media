Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57207 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab3ACVqa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jan 2013 16:46:30 -0500
Message-ID: <50E5FC11.5040306@iki.fi>
Date: Thu, 03 Jan 2013 23:45:53 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Diorser <diorser@gmx.fr>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: AverTV_A918R (af9035-af9033-tda18218) / patch proposal
References: <op.wp845xcf4bfdfw@quantal> <50E36298.3040009@iki.fi> <op.wp9b661h4bfdfw@quantal> <50E37C95.3020208@iki.fi> <op.wqctq1ej4bfdfw@quantal>
In-Reply-To: <op.wqctq1ej4bfdfw@quantal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/03/2013 11:24 PM, Diorser wrote:
>
>>  I don't know why you resists to remove antenna or unplug stick, but
>> even you remove antenna I am quite sure you will see similar results.
>
> I've been simply confused by the signal reported at ffff level most of
> the time, and the scanning working.

hmm, you could say it is working as you don't see errors but for me 
working means you could tune to channels and see programs. "Tuning 
failed" is not working for me.

> I thought the problem was a step behind with the demux error reported by
> dvbsnoop wrongly used.
>
> Can you confirm, either you personally, or someone else you know, that
> AVerTV_Volar_HD_PRO_A835 using same components as A918R fully works
> including tuning+scanning ?
> If so, it's hard to believe that Avermedia made something different when
> changing from a USB stick to Express card detected as USB, but who
> knows....
>
>> Maybe there is some GPIO controlling antenna input or switching some
>> other.
>
> I've noticed that af9035.c does not contain any GPIO settings for
> TDA18218 (all other tuners have).
> Would it be possible to implement gpio setting for TDA18218 so that they
> are used for implementations requesting it ? (just an assumption of
> course). Don't know at all if this kind of information is easily available.

I am quite 100% sure problems is GPIOs. Those could be different from 
design to design, especially in case of AverMedia....

> If necessary, although not familiar at all with debugging, I can try co
> compile a specific kernel with CONFIG_DEBUG_KERNEL=y option to see if I
> can grab something interesting.
>
> Finally, it seems that fresh implementation of TDA18218 needs a bit more
> investigation checked on more devices.
>
> BTW, is the A918R patch proposal accepted to be taken into
> consideration, or do I have to make a more formal GIT request ?
>
> Regards.
> Diorser.

Without the hardware it is hard to do anything. I don't care to spend my 
time of debugging it remotely.

Surely it is only under 10 lines of new code to support that device, but 
finding out reason is thing which took time.

regards
Antti

-- 
http://palosaari.fi/
