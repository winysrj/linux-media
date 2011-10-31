Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43473 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689Ab1JaKYj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 06:24:39 -0400
Received: by eye27 with SMTP id 27so5139015eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 03:24:38 -0700 (PDT)
Message-ID: <4EAE7763.4060306@gmail.com>
Date: Mon, 31 Oct 2011 11:24:35 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Piotr Chmura <chmooreck@poczta.onet.pl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: Re: [RESEND PATCH 1/14] staging/media/as102: initial import from
 Abilis
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com> <4E7FF0A0.7060004@gmail.com> <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com> <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein> <4E999733.2010802@poczta.onet.pl> <4E99F2FC.5030200@poczta.onet.pl> <20111016105731.09d66f03@stein> <CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com> <4E9ADFAE.8050208@redhat.com> <20111018094647.d4982eb2.chmooreck@poczta.onet.pl> <20111018111134.8482d1f8.chmooreck@poczta.onet.pl> <20111018214634.544344cc@darkstar> <4EADBBB7.7070802@poczta.onet.pl>
In-Reply-To: <4EADBBB7.7070802@poczta.onet.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/30/2011 10:03 PM, Piotr Chmura wrote:
> W dniu 18.10.2011 21:46, Piotr Chmura pisze:
>> Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
>>
>> Changes made by me:
>> 1. Driver moved from media/dvb to staging/media
>> 2. Removed Makefile/Kconfig - it doesn't compile in current tree
> (...)
>> +
>> +/*
>> + * Note:
>> + * - in AS102 SNR=MER
>> + * - the SNR will be returned in linear terms, i.e. not in dB
>> + * - the accuracy equals Â±2dB for a SNR range from 4dB to 30dB
>> + * - the accuracy is>2dB for SNR values outside this range
>> + */
> 
> I found another issue here.
> In this comment "±" is from upper ASCII (0xF1). Should I change it into sth. 
> like "+/-" in this patch (1/14) or leave it and just resend without "Â" 
> (wasn't there in original patch, don't know where it came from) ?

I collected all your patches (1..14/14, as we agreed in private), did a bit of
cleanup myself, re-edited the changelogs and I'm going to post the series which
is hopefully ready for initial pull into staging/media. I've also removed that
odd Â character right from the first patch. 

> 
> Peter
> 
> P.S. Thanks to Sylwester Nawrocki for pointing me out, that there is something
> wrong with patch 6/14, which was caused by this comment in 1/14.

---
Regards,
Sylwester
