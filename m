Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:45521 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab2EMQzt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 12:55:49 -0400
Message-ID: <4FAFE78E.4070506@ukfsn.org>
Date: Sun, 13 May 2012 17:55:42 +0100
From: Andy Furniss <andyqos@ukfsn.org>
MIME-Version: 1.0
To: Russel Winder <russel@winder.org.uk>
CC: Mark Purcell <mark@purcell.id.au>, linux-media@vger.kernel.org,
	Darren Salt <linux@youmustbejoking.demon.co.uk>,
	669715-forwarded@bugs.debian.org
Subject: Re: Fwd: Bug#669715: dvb-apps: Channel/frequency/etc. data needs
 updating for London transmitters
References: <201205132005.47858.mark@purcell.id.au>   <4FAF89DB.9020004@ukfsn.org>  <1336906328.19220.277.camel@launcelot.winder.org.uk>  <4FAFC3CA.7070008@ukfsn.org> <1336921909.9715.3.camel@anglides.winder.org.uk> <4FAFDC55.9030703@ukfsn.org>
In-Reply-To: <4FAFDC55.9030703@ukfsn.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Furniss wrote:
> Russel Winder wrote:
>> On Sun, 2012-05-13 at 15:23 +0100, Andy Furniss wrote:
>> [...]
>>>> Should that be 545833000 instead of 545833330, and 529833000 instead
>>>> of 529833330?
>>>>
>>> Possibly - I think if you calculate by hand from channel number and add
>>> or take the offset if it it<channel>+ or - then you do get the extra 33.
>>
>> If I remember correctly the OfCom documentation states the +/- offset is
>> 0.166. Certainly that is what I used for my manual calculation.

I've searched some of my defunct old scan created files and it seems 
that whatever card I used to do that scan generated freqs that ended 330 
- so maybe it's down to the hardware.
