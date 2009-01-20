Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39320 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756251AbZATWqg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 17:46:36 -0500
Message-ID: <49765448.8060108@iki.fi>
Date: Wed, 21 Jan 2009 00:46:32 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] getting started with msi tv card
References: <20090120091952.GB6792@debian-hp.lan> <4975B5F1.7000306@iki.fi> <20090120220701.GB4150@debian-hp.lan>
In-Reply-To: <20090120220701.GB4150@debian-hp.lan>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Daniel Dalton wrote:
> On Tue, Jan 20, 2009 at 01:30:57PM +0200, Antti Palosaari wrote:
>> Daniel Dalton wrote:
>>> Could someone please let me know what I have to do to get my msi 5580
>>> usb digital tv tuner working with linux?
>>> What drivers do I need? What software, what should I do to test it and
>>> is it possible to use the remote once it is up and running?
>> It should work with v4l-dvb / Kernel newer than about two years. 
> 
> So... My 2.6.26-1 kernel out of aptitude (debian lenny), should work?

Yes, should work out of the box. No need to install any driver, driver 
is included in your Kernel.

There is two versions of MSI Megasky 580. Both looks similar, but have 
still different USB-bridge chip inside. Both are supported. The older 
one uses m9206 chip and newer gl861 chip. Older needs also firmware. 
Sometimes older is called as 5580 and newer 5581, number goes from 
USB-product ID.

>> However, tuner performance is not very good. With weak signal it works 
>> better than strong. All remote keys are not working because driver does 
>> not upload IR-table to the chip.
> 
> ok

I have newer one, gl861 5581, and this is the version which have remote 
problem. I think older Megasky have all remote buttons functional.

>>> Finally, I'm vission impared, so are there any programs for controling
>>> the tv either command line based or gtk? I can't use qt applications.
>>> If qt is my only option it's fine, I'll figure out a way for handling
>>> this once the card is working.
>> Totem, Me-TV, Kaffeine, mplayer, Xine.
> 
> Mplayer works with this card? Great!
> 
> How would I begin configuring it for mplayer then?

I think mplayer is not very user friendly, try Kaffeine or Me-TV 
instead. Kaffeine have own channel scanner so it is very easy to 
configure. Otherwise you will need initial tuning file and then scan to 
get channels.conf. Try google for more info.

regards
Antti
