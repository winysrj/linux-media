Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57026 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab3LYFUm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Dec 2013 00:20:42 -0500
Message-ID: <52BA6B27.2040401@iki.fi>
Date: Wed, 25 Dec 2013 07:20:39 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] si2165: Add first driver version
References: <1386918133-21628-1-git-send-email-zzam@gentoo.org> <1386918133-21628-3-git-send-email-zzam@gentoo.org>
In-Reply-To: <1386918133-21628-3-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi Matthias

On 13.12.2013 09:02, Matthias Schwarzott wrote:
> DVB-T: works with 8MHz BW channels in germany
> DVB-C: works with QAM256

I didn't tested with a modulator, but only live signals. DVB-T seems to 
work. DVB-C didn't find any channels. Symbol rate is 6875000 and both 
QAM128 and QAM256 modulations. I suspect symbol rate... Symbol rate is 
like a bandwidth in case of DVB-T (bw could be calculated easily from sr 
just adding rolloff factor).

> TODO:
> - Extract firmware into file
Check from windows driver how it is there. There is many tricks to do 
that, but I prefer hexdump.
hexdump -C WinDriver.sys | grep "AA BB CC"
hexdump -s 0x27588 -n 20000 -e '63/1 "%02x "' -e '"\n"'  WinDriver.sys

After that implement extractor to get_dvb_firmware script.

> - Verify lock is correctly detected
> - Strength and Noise reporting

Statistics are not mandatory, you could implement later. Signal strength 
is difficult task for demod. That could be done using RF and IF AGC 
feedbacks, but it is still very rough estimate. AGC feedbacks are also 
very much RF tuner dependent.

> - Set correct bandwidth / qam parameters

That was likely reason DVB-C didn't worked :)

> - what dvb-c standard is to be announced

Annex A is normal DVB-C, with 8 MHz BW.

There is also Annex B and C, another was 6 MHz BW and the other has a 
little bit different rolloff factor. IIRC B is 6MHz and C is like A, but 
different rolloff.

> - Compiler warnings

yeah, tons of those. Kernel has also tool for checking style etc. issues 
scripts/checkpatch.pl. You must use it too.


You have put all logic to single file. It looks like that chips has 
integrated two physically rather separately demods, one for DVB-T and 
one for DVB-C. If there is not much registers that are programmed just 
similarly in both cases, please consider splitting DVB-C and DVB-T to 
own files (and maybe one file for general stuff and select weather to 
call T or C). Driver is even now quite big, almost 3000 LOC in that 
single file.


regards
Antti

-- 
http://palosaari.fi/
