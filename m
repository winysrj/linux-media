Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab0GEQMC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jul 2010 12:12:02 -0400
Message-ID: <4C32044C.3060007@redhat.com>
Date: Mon, 05 Jul 2010 13:11:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>
Subject: Re: [PATCH] xc5000, rework xc_write_reg
References: <20100518173011.5d9c7f2c@glory.loctelecom.ru>	<AANLkTilL60q2PrBGagobWK99dV9OMKldxLiKZafn1oYb@mail.gmail.com> <20100525114939.067404eb@glory.loctelecom.ru>
In-Reply-To: <20100525114939.067404eb@glory.loctelecom.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-05-2010 22:49, Dmitri Belimov escreveu:
> Hi Devin
> 
>> On Tue, May 18, 2010 at 3:30 AM, Dmitri Belimov <d.belimov@gmail.com>
>> wrote:
>>> Hi
>>>
>>> Rework xc_write_reg function for correct read register of the
>>> xc5000. It is very useful for tm6000.
>>>
>>> Tested for tm6000 and for saa7134 works well.
>>
>> Hi Dmitri,
>>
>> I've put this on my list of patches to review.  My concern is that the
>> xc_wait logic is pretty nasty since it's related to timing of the bus
>> (it took several weeks as well as a dozen emails with the people at
>> Xceive), and hence I am loathed to change it since it took quite a bit
>> of time to test against all the different cards that use xc5000 (and
>> in some cases there were bugs exposed in various bridge's i2c
>> implementations).
>>
>> That said, I think I actually did attempt to implement a patch
>> comparable to what you did here, but I backed it out for some reason.
>> I will need to review my trees and my notes to see what the rationale
>> was for doing such.
> 
> Ok. I can test your solution on our hardware.
> XC5000+SAA7134
> XC5000+TM6010

Devin/Dmitri,

Any progress about this patch?

Cheers,
Mauro
