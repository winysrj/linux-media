Return-path: <linux-media-owner@vger.kernel.org>
Received: from 87-127-199-35.static.enta.net ([87.127.199.35]:51821 "EHLO
	ion.jimbocorp.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933117Ab2AJX3N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 18:29:13 -0500
Message-ID: <4F0CC81A.6010301@gmail.com>
Date: Tue, 10 Jan 2012 23:22:02 +0000
From: Jim Darby <uberscubajim@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: uberscubajim@gmail.com, stoth@kernellabs.com
Subject: Re: Possible regression in 3.2 kernel with PCTV Nanostick T2 (em28xx,
 cxd2820r and tda18271)
References: <4F0C3D1B.2010904@gmail.com> <CALzAhNVo4Aar7YbF1f6BU7Fp9Uceb5Nq5-JSb2tP0aNYiEra6A@mail.gmail.com>
In-Reply-To: <CALzAhNVo4Aar7YbF1f6BU7Fp9Uceb5Nq5-JSb2tP0aNYiEra6A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/01/12 13:54, Steven Toth wrote:
>> The Nanostick works fine for between 5 and 25 minutes and then without any
>> error messages cuts out. The TS drops to a tiny stream of non-TS data. It
>> seems to contain a lot of 0x00s and 0xffs.
> What does femon show for demodulator statistics?
>
Well... I downloaded the latest dvb-apps via mecurial from linuxtv.org 
and the following happened at the start while it was working:

status SCVYL | signal ffff | snr 00ef | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status SCVYL | signal ffff | snr 00f1 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status SCVYL | signal ffff | snr 00ee | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status SCVYL | signal ffff | snr 00f0 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status SCVYL | signal ffff | snr 00f2 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status SCVYL | signal ffff | snr 00ee | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status SCVYL | signal ffff | snr 00f0 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK

and when it stopped working, this time an hour later, nothing had 
changed. In fact, it looks like the driver keeps lock even when it's not 
recording at all.

Any ideas anyone? Looks like the tuner is OK....

The thing that's really confusing me is the totally random amounts of 
time it takes before it fails. This time it was over an hour. For 
reference though this was the first time I'd tried it with standard 
definition transmissions. Not only lower data rate but also DVB-T rather 
than DVB-T2.

Many thanks,

Jim.
