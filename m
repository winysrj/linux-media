Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38251 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab1AWQDE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 11:03:04 -0500
Received: by wwa36 with SMTP id 36so3516891wwa.1
        for <linux-media@vger.kernel.org>; Sun, 23 Jan 2011 08:03:02 -0800 (PST)
Subject: Re: Hauppauge Nova-T-500; losing one tuner. Regression?
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Alex Butcher <linuxtv@assursys.co.uk>
Cc: linux-media@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1101231119320.26778@sbhezbfg.of5.nffheflf.cev>
References: <alpine.LFD.2.00.1101231119320.26778@sbhezbfg.of5.nffheflf.cev>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Jan 2011 16:02:55 +0000
Message-ID: <1295798575.9525.21.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2011-01-23 at 11:58 +0000, Alex Butcher wrote:
> 
> 11) I briefly experimented with setting buggy_sfn_workaround=1 when
> loading
> the dib3000mc and dib7000p modules with no apparent improvement.  As
> far as
> I can see, though, UK DVB-T broadcasting isn't a single frequency
> network,
> so a) this is not relevant here and b) it will impair performace.  As
> a
> result, I'm NOT using the buggy_sfn_workaround.

The dib7000p does have issues with the UK DVB-T network where old 2K
mode DVB-T is mixed with high power 8K transmissions in areas that have
had a half switch over.

Only the 2K mode appears to lock reliably. I think it something to do
with the AGC settings.

Unfortunately, attenuation of the signal results in reliable lock of the
8K signal with the 2K channels being lost.

Until the 2K signals disappear in 2012 with the full retune this will
remain a problem.

