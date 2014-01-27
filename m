Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:59180 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbaA0UzE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jan 2014 15:55:04 -0500
Received: by mail-wg0-f43.google.com with SMTP id y10so6076209wgg.34
        for <linux-media@vger.kernel.org>; Mon, 27 Jan 2014 12:55:03 -0800 (PST)
Received: from [192.168.0.104] (host86-142-106-19.range86-142.btcentralplus.com. [86.142.106.19])
        by mx.google.com with ESMTPSA id r1sm20743106wia.5.2014.01.27.12.55.02
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 27 Jan 2014 12:55:02 -0800 (PST)
Message-ID: <52E6C7A4.8050708@googlemail.com>
Date: Mon, 27 Jan 2014 20:55:00 +0000
From: Robert Longbottom <rongblor@googlemail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
References: <20140122115334.GA14710@minime.bse> <52DFC300.8010508@googlemail.com> <20140122135036.GA14871@minime.bse> <52E00AD0.2020402@googlemail.com> <20140123132741.GA15756@minime.bse> <52E1273F.90207@googlemail.com> <20140125152339.GA18168@minime.bse> <52E4EFBB.7070504@googlemail.com> <20140126125552.GA26918@minime.bse> <52E5366A.807@googlemail.com> <20140127032044.GA27541@minime.bse>
In-Reply-To: <20140127032044.GA27541@minime.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/01/14 03:20, Daniel Glöckner wrote:
> On Sun, Jan 26, 2014 at 04:23:06PM +0000, Robert Longbottom wrote:
>> 000 000000D7 DSTATUS
>> 114 32734000 RISC_STRT_ADD
>> 120 32734000 RISC_COUNT
>
> Video is present and locked but the RISC counter is stuck at the start
> address. My best guess is that the CPLD is not forwarding the REQ signal
> to the PCI bridge, so the BT878A can't fetch the RISC instructions.
> But then there is also this persistent ADC overflow...
>
> As for the CPLD, there is not much we can do. I count 23 GPIOs going
> to that chip. And we don't know if some of these are outputs of the
> CPLD, making it a bit risky to just randomly drive values on those
> pins.

Is that because it might do some damage to the card, or to the host 
computer, or both?  Or is it just too hard to make random guesses at 
what it should be doing?

> If we had the original software, we could analyze what it is doing.
> There is someone on ebay.com selling two of those cards and a cd
> labled "Rescue Disk Version 1.14 for Linux DVR".

Ah yes, I've just found that, it seems a little pricey!  There is also a 
listing for an "Avermedia 4 Eyes Pro Capture Card PCI 8604" which looks 
pretty much the same, but it doesn't have any software with it and 
searching around for any more information on that hasn't got me anywhere.

I've just been trying to make my card work under Windows, but no luck 
there either.  I didn't get a driver CD with it, Windows 7 doesn't 
autodetect anything for the video chips and when I tried to frig some 
drivers I found earlier today for a similar looking card they did 
install, but then didn't work - the not very helpful "device failed to 
start" error you get in Windows.  Which I guess means it's just not the 
right driver.

Shame, but I think I'll just have to chalk it up to experience - it 
wouldn't be my first duff purchase in the video-capture-device-for-linux 
area :-)

Thanks for all your efforts.
Cheers,
Rob.

