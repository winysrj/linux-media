Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f46.google.com ([209.85.221.46]:34136 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387437AbeKVH4m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 02:56:42 -0500
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        stakanov <stakanov@eclipso.eu>
Cc: Takashi Iwai <tiwai@suse.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <4e0356d6303c128a3e6d0bcc453ba1be@mail.eclipso.de>
 <20181120104217.5b487bcd@coco.lan> <1593929.t9Y74Rdlh1@roadrunner.suse>
 <20181120140855.29f5dc3f@coco.lan>
From: Malcolm Priestley <tvboxspy@gmail.com>
Message-ID: <96849b97-3abb-b879-ed05-35bcd58b5e43@gmail.com>
Date: Wed, 21 Nov 2018 21:20:35 +0000
MIME-Version: 1.0
In-Reply-To: <20181120140855.29f5dc3f@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20/11/2018 16:08, Mauro Carvalho Chehab wrote:
> Em Tue, 20 Nov 2018 14:20:01 +0100
<snip>

> Ok. Now, min/max frequencies are at the same scale. For DVB-S, 
> dvb_frontend_get_frequency_limits() returns both in kHz, so the frequency
> range is now OK.
> 
> The tuning frequency is wrong through. 10,719,000 kHz - e. g. 10,719 MHz
> seems to be the transponder frequency you're trying to tune, and not the
> intermediate frequency used at the DVB-S board.
> 
> That sounds to me either a wrong LNBf setting or a bug at libdvbv5 or
> at Kaffeine's side. What happens is that the typical European LNBFs are:
> 
> 1) the "old" universal one:
> 
> UNIVERSAL
> 	Universal, Europe
> 	Freqs     : 10800 to 11800 MHz, LO: 9750 MHz
> 	Freqs     : 11600 to 12700 MHz, LO: 10600 MHz
I am pretty certain this type is obsolete it doesn't look right for 9750Mhz oscillator.

I am sure it was 10000Mhz or 96?? or something like that for old analogue transmissions of 
20 years ago

> 
> 2) the "new" universal one, with seems to be used by most modern
> satellite dishes in Europe nowadays:
> 
> EXTENDED
> 	Astra 1E, European Universal Ku (extended)
This needs renaming as 1E has long gone.

Certainly this type is used for Astra 19.2 and 28.2.

Ideally we should use a default LNB type for each Satellite either in libdvbv5, Kaffeine or respective tables.

Regards


Malcolm
