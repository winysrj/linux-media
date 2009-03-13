Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:39276 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZCMO1H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 10:27:07 -0400
Received: by yx-out-2324.google.com with SMTP id 8so271113yxm.1
        for <linux-media@vger.kernel.org>; Fri, 13 Mar 2009 07:27:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49B9DECC.5090102@nav6.org>
References: <49B9BC93.8060906@nav6.org>
	 <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>
	 <49B9DECC.5090102@nav6.org>
Date: Fri, 13 Mar 2009 10:27:02 -0400
Message-ID: <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
	and BER from HVR 4000 Lite
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Ang Way Chuang <wcang@nav6.org>
Cc: VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 13, 2009 at 12:19 AM, Ang Way Chuang <wcang@nav6.org> wrote:
>
> Yes, please :)

Yeah, Michael Krufky and I were discussing it in more detail yesterday
on the #linuxtv ML.  Essentially there are a few issues:

1.  Getting everyone to agree on the definition of "SNR", and what
units to represent it in.  It seems like everybody I have talked to
has no issue with doing in 0.1 dB increments, so for example an SNR of
25.3 would be presented as 0x00FD.

2.  Getting everyone to agree on the definition of "Strength".  Is
this the field strength?  Is this some coefficient of the SNR compared
to an arbitrary scale?  Is it a percentage?  If it's a percentage, is
it 0-100 or 0-65535?

3.  Deciding on what return codes to use for "device does not support
SNR info", "device cannot provide SNR currently" (such as occurs for
some devices if there is no lock).  Right now, devices return zero if
not supported, and it would be good for apps to know the difference
between "no signal" and the various reasons a chip cannot provide the
information.

4.  Converting all the drivers to use the same representation.  How
difficult this is varies by chip, since for some chips we know exactly
how SNR is represented and for some chips it is completely reverse
engineered.

After the discussion I had yesterday, I have some renewed energy for
this.  My plan is to put together a formal definition of the two API
calls (SNR and Strength) and solicit comments.  If I get some
agreement, I will start converting all the ATSC devices to support the
API (and submit patches to Kaffeine).

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
