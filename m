Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:33744 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbcAQK1e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2016 05:27:34 -0500
Received: by mail-wm0-f50.google.com with SMTP id 123so19729284wmz.0
        for <linux-media@vger.kernel.org>; Sun, 17 Jan 2016 02:27:34 -0800 (PST)
Subject: Re: Pinnacle PCTV DVB-S2 Stick (461e) - HD Streams with artefacts
To: Rainer Dorsch <ml@bokomoko.de>
Cc: linux-media@vger.kernel.org
References: <13463113.ozc26Vzdzi@blackbox> <569ACF59.7090700@gmail.com>
 <2761448.7zDNhWqk2x@blackbox>
From: Andy Furniss <adf.lists@gmail.com>
Message-ID: <569B6C83.5080104@gmail.com>
Date: Sun, 17 Jan 2016 10:27:15 +0000
MIME-Version: 1.0
In-Reply-To: <2761448.7zDNhWqk2x@blackbox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rainer Dorsch wrote:

>>> Certainly any hint how to solve this issue is welcome.
>>
>> I added a comment on the tvh forum - will paste here as well in
>> case anyone is interested -
>>
>> You could try spinning up you cpu(s) with
>>
>> nice -19 dd if=/dev/urandom of=/dev/null
>
> I added four of these, but if at all then there was only a minor
> impact.

Oh, OK it was worth a try.

>> If you have multiple cores maybe start more than one.
>>
>> I have a couple of DVB-T2 PCTV sticks and got some usb/power
>> save/xhci issues on my h/w.
>>
>> Above would mostly fix. Rather than do that I found that the issue
>> was far less if I disabled USB3 in bios to avoid using the xhci
>> driver.
>
> The cubox-i has no USB 3 port and no bios :-/

Ahh, quite different h/w then. Mine was a quad core baytrail DC board.

>> Of course your issue may be totally different - but it's worth a
>> try.
>
>> Your symptoms do point to ts packet loss - which I know from my
>> experience can be at usb level. There are posts on here from the
>> past where people with PCIE cards also had to do similar.
>
> Sounds reasonable. Can I enable logs which would make these drops
> explicit?

Not that I know of at kernel level. The only way really is to infer loss
from the continuity counters, which TVH already logs.
