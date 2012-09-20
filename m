Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:36671 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409Ab2ITSyZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 14:54:25 -0400
Message-ID: <505B665D.4080004@schinagl.nl>
Date: Thu, 20 Sep 2012 20:54:21 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org, crope@iki.fi
Subject: Re: [PATCH] Support for Asus MyCinema U3100Mini Plus
References: <1348080243-3818-1-git-send-email-oliver+list@schinagl.nl> <CAGoCfizA_wEcJdcXHfN1xA4MTMUJy4vCX4YpN8vpei9=wFZg-w@mail.gmail.com>
In-Reply-To: <CAGoCfizA_wEcJdcXHfN1xA4MTMUJy4vCX4YpN8vpei9=wFZg-w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19-09-12 22:52, Devin Heitmueller wrote:
> On Wed, Sep 19, 2012 at 2:44 PM,  <oliver@schinagl.nl> wrote:
>> From: Oliver Schinagl <oliver@schinagl.nl>
>>
>> This is initial support for the Asus MyCinema U3100Mini Plus. The driver
>> in its current form gets detected and loads properly.
>>
>> Scanning using dvbscan works without problems, Locking onto a channel
>> using tzap also works fine. Only playback using tzap -r + mplayer was
>> tested and was fully functional.
> Hi Oliver,
>
> The previous thread suggested that this driver didn't work with
> dvbv5-scan and w_scan.  Is that still the case?  If so, do we really
> want a "half working" driver upstream?  Seems like this is more likely
> to cause support headaches than the device not being supported at all
> (since users will "think" it's supported but it's actually broken in
> some pretty common use cases).
After working in antti's changes.
dvbscan: works
dvbv5-scan: works
w_scan -X: works
w_scan -x: works
tzap: works (only tested the 3 available FTA channels)
dvbv5-zap: couldn't figure out how to work it :) It says: Usage: 
dvbv5-zap [OPTION...] <initial file> but probably means <Channel name>? 
I tried several combinations, with both a regular channels.conf file and 
a dvb_channels.conf file. I will play more with it when I find some 
extra time.

dvbscan and dvbv5-scan does constantly say 'tuning failed' but it does 
say that on my terratec too. It does work fine however, so probably a 
bug in driver/tool unrelated to this patch.
>
> Or perhaps I'm mistaken and the issues have been addressed and now it
> works with all the common applications.
>
> Devin
>

