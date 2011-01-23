Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57233 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab1AWV5B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 16:57:01 -0500
Received: by wwa36 with SMTP id 36so3706402wwa.1
        for <linux-media@vger.kernel.org>; Sun, 23 Jan 2011 13:57:00 -0800 (PST)
Subject: Re: Hauppauge Nova-T-500; losing one tuner. Regression?
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Alex Butcher <linuxtv@assursys.co.uk>
Cc: linux-media@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1101232055550.26778@sbhezbfg.of5.nffheflf.cev>
References: <alpine.LFD.2.00.1101231119320.26778@sbhezbfg.of5.nffheflf.cev>
	 <1295798575.9525.21.camel@tvboxspy>
	 <alpine.LFD.2.00.1101232055550.26778@sbhezbfg.of5.nffheflf.cev>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Jan 2011 21:56:54 +0000
Message-ID: <1295819814.3007.33.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2011-01-23 at 21:01 +0000, Alex Butcher wrote:
> On Sun, 23 Jan 2011, Malcolm Priestley wrote:
> 
> > On Sun, 2011-01-23 at 11:58 +0000, Alex Butcher wrote:
> >>
> >> 11) I briefly experimented with setting buggy_sfn_workaround=1 when
> >> loading
> >> the dib3000mc and dib7000p modules with no apparent improvement.  As
> >> far as
> >> I can see, though, UK DVB-T broadcasting isn't a single frequency
> >> network,
> >> so a) this is not relevant here and b) it will impair performace.  As
> >> a
> >> result, I'm NOT using the buggy_sfn_workaround.
> >
> > The dib7000p does have issues with the UK DVB-T network where old 2K
> > mode DVB-T is mixed with high power 8K transmissions in areas that have
> > had a half switch over.
> 
> Checking <http://www.ukfree.tv/txdetail.php?a=ST564488> for my transmitter
> (Mendip), I see that this applies to me as multiplexes A, C and COM6 are
> 2K/10kW, whilst PSB1 and PSB2 are 8k/100kW.

lol ... I use the same transmitter and have the same problems.

I have several devices and the only thing common was the dib7000p. After
a week of trying to debug to no avail. There appears to be no way to
back the gain off from the tuner.

It is the 2K/8K and/or power mix. The windows driver also suffers the
same problem but it attempts a number of retries to gain lock.

An all 8K transmitter in the South West(Beacon Hill) is fine, so full
switch over should be fine.

