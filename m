Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:36286 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab2EMQHw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 12:07:52 -0400
Message-ID: <4FAFDC55.9030703@ukfsn.org>
Date: Sun, 13 May 2012 17:07:49 +0100
From: Andy Furniss <andyqos@ukfsn.org>
MIME-Version: 1.0
To: Russel Winder <russel@winder.org.uk>
CC: Mark Purcell <mark@purcell.id.au>, linux-media@vger.kernel.org,
	Darren Salt <linux@youmustbejoking.demon.co.uk>,
	669715-forwarded@bugs.debian.org
Subject: Re: Fwd: Bug#669715: dvb-apps: Channel/frequency/etc. data needs
 updating for London transmitters
References: <201205132005.47858.mark@purcell.id.au>   <4FAF89DB.9020004@ukfsn.org>  <1336906328.19220.277.camel@launcelot.winder.org.uk>  <4FAFC3CA.7070008@ukfsn.org> <1336921909.9715.3.camel@anglides.winder.org.uk>
In-Reply-To: <1336921909.9715.3.camel@anglides.winder.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Russel Winder wrote:
> On Sun, 2012-05-13 at 15:23 +0100, Andy Furniss wrote:
> [...]
>>> Should that be 545833000 instead of 545833330, and 529833000 instead of 529833330?
>>>
>> Possibly - I think if you calculate by hand from channel number and add
>> or take the offset if it it<channel>+ or - then you do get the extra 33.
>
> If I remember correctly the OfCom documentation states the +/- offset is
> 0.166.  Certainly that is what I used for my manual calculation.

I was told when asking on uk.tech.broadcast that the offset was 167000, 
perhaps, if that's rounded up, then 166670 may also be valid and would 
give the extra 330.

I don't know about ofcom docs but you can get other info if you check 
the "I am in the trade" box and enter your postcode here -

http://www.digitaluk.co.uk/postcodechecker/

for the details you have to hover mouse over channel numbers, and of 
course convert channels to freq. The formula I was told was -

(306 + (N x 8)) x 1000000 then if required +/- 167000

>
>> I don't live in London, but using a slightly newer w_scan for my
>> transmitter gave different output from that, with the 330 ->  000.
>
> Where did you get this w_scan command from, I don't seem to have one.

wirbel.htpc-forum.de/w_scan/index_en.html

To download there is a link at the bottom of the German page which is 
linked to from that page.


>
> [...]
>> T2 0 16417 802000000 8MHz AUTO AUTO     AUTO AUTO AUTO AUTO     # East
>
> I wonder if the 0 and 16417 can be ascertained from OfCom documents?

  I don't have a clue about that.




