Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo09.poczta.onet.pl ([213.180.142.140]:32795 "EHLO
	smtpo09.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab1J3VDz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Oct 2011 17:03:55 -0400
Message-ID: <4EADBBB7.7070802@poczta.onet.pl>
Date: Sun, 30 Oct 2011 22:03:51 +0100
From: Piotr Chmura <chmooreck@poczta.onet.pl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [RESEND PATCH 1/14] staging/media/as102: initial import from
 Abilis
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com> <4E7FF0A0.7060004@gmail.com> <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com> <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein> <4E999733.2010802@poczta.onet.pl> <4E99F2FC.5030200@poczta.onet.pl> <20111016105731.09d66f03@stein> <CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com> <4E9ADFAE.8050208@redhat.com> <20111018094647.d4982eb2.chmooreck@poczta.onet.pl> <20111018111134.8482d1f8.chmooreck@poczta.onet.pl> <20111018214634.544344cc@darkstar>
In-Reply-To: <20111018214634.544344cc@darkstar>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 18.10.2011 21:46, Piotr Chmura pisze:
> Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
>
> Changes made by me:
> 1. Driver moved from media/dvb to staging/media
> 2. Removed Makefile/Kconfig - it doesn't compile in current tree
(...)
> +
> +/*
> + * Note:
> + * - in AS102 SNR=MER
> + *   - the SNR will be returned in linear terms, i.e. not in dB
> + *   - the accuracy equals Â±2dB for a SNR range from 4dB to 30dB
> + *   - the accuracy is>2dB for SNR values outside this range
> + */

I found another issue here.
In this comment "±" is from upper ASCII (0xF1). Should I change it into 
sth. like "+/-" in this patch (1/14) or leave it and just resend without 
"Â" (wasn't there in original patch, don't know where it came from) ?

Peter

P.S. Thanks to Sylwester Nawrocki for pointing me out, that there is 
something wrong with patch 6/14, which was caused by this comment in 1/14.
