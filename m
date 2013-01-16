Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1.mo5.mail-out.ovh.net ([188.165.57.91]:41664 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755116Ab3APSrf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 13:47:35 -0500
Received: from mail178.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo5.mail-out.ovh.net (Postfix) with SMTP id 3027AFFAE03
	for <linux-media@vger.kernel.org>; Wed, 16 Jan 2013 12:50:58 +0100 (CET)
Message-ID: <50F691DC.2090806@ventoso.org>
Date: Wed, 16 Jan 2013 12:41:16 +0100
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com> <50F522AD.8000109@iki.fi> <20130115111041.6b78a935@redhat.com> <50F56C63.7010503@iki.fi> <50F57519.5060402@iki.fi> <20130115151203.7221b1db@redhat.com> <50F5BE14.9000705@iki.fi> <CAHFNz9L9Lg-uttCVOk90UghM_WVbge44Ascxv4qrag3GvWetnQ@mail.gmail.com>
In-Reply-To: <CAHFNz9L9Lg-uttCVOk90UghM_WVbge44Ascxv4qrag3GvWetnQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Al 16/01/2013 5:26, En/na Manu Abraham ha escrit:

> The simplest and easiest way to achieve commonality between the various
> demodulators is to use the existing API and scale whatever documented
> demodulators to that scacle, to best possible way, rather than adding more
> ambiguity and breakage.

Note that an older version of the linux dvb api documentation clearly 
specified the scale to use, i.e. see

http://linuxtv.org/downloads/legacy/old/linux_dvb_api-20020304.pdf

"The bit error rate, as a multiple of 10E-9 , is stored into
*ber. Example: a value of 2500 corresponds to a bit error rate
of 2.5 * 10E-6 or 1 error in 400000 bits."

"The signal-to-noise ratio, as a multiple of 10E-6 dB, is
stored into *snr. Example: a value of 12,300,000 corresponds to a 
signal-to-noise ratio of 12.3 dB."

"The signal strength value, as a multiple of 10E-6 dBm, is
stored into *strength. Example: a value of -12,500,000 corresponds to a 
signalstrength value of -12.5 dBm."

but for some reason later revisions of the api don't include the scale

Bye
-- 
Luca
