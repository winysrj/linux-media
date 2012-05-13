Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34691 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab2EMU4j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 16:56:39 -0400
Received: by bkcji2 with SMTP id ji2so3306976bkc.19
        for <linux-media@vger.kernel.org>; Sun, 13 May 2012 13:56:38 -0700 (PDT)
Message-ID: <4FB02003.3060305@googlemail.com>
Date: Sun, 13 May 2012 22:56:35 +0200
From: Thomas Mair <thomas.mair86@googlemail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] rtl2832 ver 0.3: suport for RTL2832 demodulator revised
 version
References: <1336846109-30070-1-git-send-email-thomas.mair86@googlemail.com> <1336846109-30070-2-git-send-email-thomas.mair86@googlemail.com> <4FB0033A.4090104@iki.fi>
In-Reply-To: <4FB0033A.4090104@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.05.2012 20:53, Antti Palosaari wrote:
> On 12.05.2012 21:08, Thomas Mair wrote:
>> Changes compared to version 0.2:
>> - removed reading of signal strength for tuners FC0012,FC0013 (is now supported by fc0012,fc0013 driver)
>> - moved definition of register names to rtl2832_priv.h
>> - cleaned up demod private structure
>> - replaced rtl2832_log2 function with intlog2 from dvb_math
>>
>> Signed-off-by: Thomas Mair<thomas.mair86@googlemail.com>
> 
> Testing shows UCB counter is totally broken. It does that all the time, 64 => <some number> => 64
> 
> status SCVYL | signal 2b2b | snr b08c | ber 00000024 | unc 00000064 | FE_HAS_LOCK
> status SCVYL | signal 2b2b | snr a7b8 | ber 0000007d | unc 0000005e | FE_HAS_LOCK
> status SCVYL | signal 2b2b | snr b08c | ber 0000002c | unc 00000064 | FE_HAS_LOCK
> 

Ok. I will have a look into that. When I test it the count is always 64. 

status SCVYL | signal 4545 | snr ffff | ber 00000000 | unc 00000064 | FE_HAS_LOCK
status SCVYL | signal 4545 | snr ffff | ber 00000000 | unc 00000064 | FE_HAS_LOCK
status SCVYL | signal 4545 | snr ffff | ber 00000000 | unc 00000064 | FE_HAS_LOCK



> Also other small issue. You have added new line to the log writings provided by DVB USB. DVB USB log writing has already new line! That is 2nd time I point out line errors. Did you use some special set-up during the development ?
> 
> May 13 21:33:06 localhost kernel: [204738.354039] rtl28xxu: rtl2832u_frontend_attach: FC0012 tuner found
> May 13 21:33:06 localhost kernel: [204738.354040]
> May 13 21:33:06 localhost kernel: [204738.361304] DVB: registering adapter 0 frontend 0 (Realtek RTL2832 (DVB-T))...
> 

I missed that one. I really tried to get rid of all of them. I'll fix that soon.

> I quickly looked patches through and those looked very good. I will try to review those tonight.
> 
> And here is whole set (tuner+rtl2832u) if someone else would like to test:
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/rtl2832u
> 
> regards
> Antti

Regrads
Thomas
