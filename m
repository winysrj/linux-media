Return-path: <linux-media-owner@vger.kernel.org>
Received: from cmsout01.mbox.net ([165.212.64.31]:54147 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab1JCNYB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 09:24:01 -0400
Date: Mon, 03 Oct 2011 15:18:28 +0200
From: "Issa Gorissen" <flop.m@usa.net>
To: <o.endriss@gmx.de>,
	=?ISO-8859-1?Q?S=E9bastien=20RAILLARD=20?= <sr@coexsi.fr>
Subject: Re: [DVB] CXD2099 - Question about the CAM clock
CC: "Linux Media Mailing List" <linux-media@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <356PJcNRC7216S01.1317647908@web01.cms.usa.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Dear Oliver,
> 
> I’ve done some tests with the CAM reader from Digital Devices based on
Sony
> CXD2099 chip and I noticed some issues with some CAM:
> * SMIT CAM    : working fine
> * ASTON CAM   : working fine, except that it's crashing quite regularly
> * NEOTION CAM : no stream going out but access to the CAM menu is ok
> 
> When looking at the CXD2099 driver code, I noticed the CAM clock (fMCLKI)
is
> fixed at 9MHz using the 27MHz onboard oscillator and using the integer
> divider set to 3 (as MCLKI_FREQ=2).
> 
> I was wondering if some CAM were not able to work correctly at such high
> clock frequency.
> 
> So, I've tried to enable the NCO (numeric controlled oscillator) in order
to
> setup a lower frequency for the CAM clock, but I wasn't successful, it's
> looking like the frequency must be around the 9MHz or I can't get any
> stream.
> 
> Do you know a way to decrease this CAM clock frequency to do some testing?
> 
> Best regards,
> Sebastien.

Weird that the frequency would pose a problem for those CAMs. The CI spec [1]
explains that the minimum byte transfer clock period must be 111ns. This gives
us a frequency of ~9MHz.

Anyway, wouldn't it be wiser to base MCLKI on TICLK ?

--
Issa

[1] http://www.dvb.org/technology/standards/En50221.V1.pdf

