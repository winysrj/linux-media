Return-path: <mchehab@pedra>
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:4032 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1AWVBj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 16:01:39 -0500
Date: Sun, 23 Jan 2011 21:01:37 +0000 (GMT)
From: Alex Butcher <linuxtv@assursys.co.uk>
To: Malcolm Priestley <tvboxspy@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: Hauppauge Nova-T-500; losing one tuner. Regression?
In-Reply-To: <1295798575.9525.21.camel@tvboxspy>
Message-ID: <alpine.LFD.2.00.1101232055550.26778@sbhezbfg.of5.nffheflf.cev>
References: <alpine.LFD.2.00.1101231119320.26778@sbhezbfg.of5.nffheflf.cev> <1295798575.9525.21.camel@tvboxspy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 23 Jan 2011, Malcolm Priestley wrote:

> On Sun, 2011-01-23 at 11:58 +0000, Alex Butcher wrote:
>>
>> 11) I briefly experimented with setting buggy_sfn_workaround=1 when
>> loading
>> the dib3000mc and dib7000p modules with no apparent improvement.  As
>> far as
>> I can see, though, UK DVB-T broadcasting isn't a single frequency
>> network,
>> so a) this is not relevant here and b) it will impair performace.  As
>> a
>> result, I'm NOT using the buggy_sfn_workaround.
>
> The dib7000p does have issues with the UK DVB-T network where old 2K
> mode DVB-T is mixed with high power 8K transmissions in areas that have
> had a half switch over.

Checking <http://www.ukfree.tv/txdetail.php?a=ST564488> for my transmitter
(Mendip), I see that this applies to me as multiplexes A, C and COM6 are
2K/10kW, whilst PSB1 and PSB2 are 8k/100kW.

> Only the 2K mode appears to lock reliably. I think it something to do
> with the AGC settings.
>
> Unfortunately, attenuation of the signal results in reliable lock of the
> 8K signal with the 2K channels being lost.
>
> Until the 2K signals disappear in 2012 with the full retune this will
> remain a problem.

Can I shoot myself in the head /again/?

On the other hand, this did used to work 100% reliably on my old system both
before and after the analogue switch-off...

Best Regards,
Alex
