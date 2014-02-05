Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55258 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaBENQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 08:16:54 -0500
Received: by mail-wi0-f174.google.com with SMTP id f8so556011wiw.7
        for <linux-media@vger.kernel.org>; Wed, 05 Feb 2014 05:16:52 -0800 (PST)
Received: from [192.168.254.97] (host81-159-51-114.range81-159.btcentralplus.com. [81.159.51.114])
        by mx.google.com with ESMTPSA id ua8sm61365285wjc.4.2014.02.05.05.16.51
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 05 Feb 2014 05:16:51 -0800 (PST)
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
References: <20140122135036.GA14871@minime.bse> <52E00AD0.2020402@googlemail.com> <20140123132741.GA15756@minime.bse> <52E1273F.90207@googlemail.com> <20140125152339.GA18168@minime.bse> <52E4EFBB.7070504@googlemail.com> <20140126125552.GA26918@minime.bse> <52E5366A.807@googlemail.com> <20140127032044.GA27541@minime.bse> <52E6C7A4.8050708@googlemail.com> <20140128020242.GA31019@minime.bse>
From: Robert Longbottom <rongblor@googlemail.com>
Content-Type: text/plain;
	charset=utf-8
In-Reply-To: <20140128020242.GA31019@minime.bse>
Message-Id: <5679652F-05AC-44B8-AE0B-A107E38F2433@googlemail.com>
Date: Wed, 5 Feb 2014 13:16:53 +0000
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (1.0)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 28 Jan 2014, at 02:02 AM, Daniel Glöckner <daniel-gl@gmx.net> wrote:

> On Mon, Jan 27, 2014 at 08:55:00PM +0000, Robert Longbottom wrote:
>>> As for the CPLD, there is not much we can do. I count 23 GPIOs going
>>> to that chip. And we don't know if some of these are outputs of the
>>> CPLD, making it a bit risky to just randomly drive values on those
>>> pins.
>> 
>> Is that because it might do some damage to the card, or to the host
>> computer, or both?
> 
> If there is damage, it will most likely be restricted to the card.
> 
>> Or is it just too hard to make random guesses at
>> what it should be doing?
> 
> When we cycle through all combinations in one minute, there are about
> a hundred PCI cycles per combination left for the chip to be granted
> access to the bus. I expect most of the pins to provide a priority
> or weighting value for each BT878A, so there should be many combinations
> that do something.

How difficult is it for me to do this?  And is it obvious when it works? I have an old pc that I can put the card in that doesn't matter. And given I can't get the card to work in windows or Linux its not much use to me as it is, so if it breaks then so be it. 

I've not done any Linux driver development, but I'm happy enough compiling stuff for the most part. 

> Maybe the seller is nice person and provides the contents of the CD for
> free.

I tried contacting the seller via eBay, but no response so far, so I'm guessing he's not interested, which is a shame. 

Cheers,
Rob. 

