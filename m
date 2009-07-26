Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:54737 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755028AbZGZXvA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jul 2009 19:51:00 -0400
Subject: Re: Problem with My Tuner card
From: hermann pitton <hermann-pitton@arcor.de>
To: unni krishnan <unnikrishnan.a@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1f8bbe3c0907260841p2b7f94c7i109f1b9597fc9783@mail.gmail.com>
References: <1f8bbe3c0907232102t5c658d66o571571707ecdb1f4@mail.gmail.com>
	 <1248411383.3247.18.camel@pc07.localdom.local>
	 <1f8bbe3c0907232218g45c89eeapc4b86e9d07217037@mail.gmail.com>
	 <1248415576.3245.16.camel@pc07.localdom.local>
	 <1f8bbe3c0907250856h6c059658m6caa838a0ac6f9c2@mail.gmail.com>
	 <1248558423.3341.115.camel@pc07.localdom.local>
	 <1f8bbe3c0907260841p2b7f94c7i109f1b9597fc9783@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 01:44:25 +0200
Message-Id: <1248651865.3342.19.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Unni,

Am Sonntag, den 26.07.2009, 21:11 +0530 schrieb unni krishnan:
> Hi,
> 
> 
> > It seems to me we have to add a new entry for your card.
> > Does it have a unique name they sell it, do you know the manufacturer?
> 
> Yes, card is called SSD-TV-675 (
> http://www.techcomindia.com/home.php?vaction=showprodd&cat=102&catt=TV%20Tuners&subcat=&subcatt=&prodid=501
> )

good.

> > Is there a website or did you investigate all the printings on the PCB
> > already.
> > The tuner type label is often hidden under a OEM vendor label.
> > Sometimes a drop of salad oil is enough to make the upper sticker
> > transparent. Tuner factory label underneath is in most cases close to
> > the antenna connector.
> 
> I got that :
> 
> QSD-MT-S73 BD . I think this is the site
> http://www.szqsd.cn/en/product_show.asp?id=89

Very good. You digged out another new tuner manufacturing conglomerate
there. Unless they provide internals, we can only run in compatible
mode.

> > Since 0x8000 does not work for mute on your card, you can try 0x4000 and
> > 0x2000 in the mute section.
> 
> Note sure how I can do that. Need more help :-)

The FV2K mutes on 0x8000 high. Yours not.
Just try with 0x2000 and 0x4000 in the mute section of the card entry.

If it should be true, that either or the other pin is needed to be low,
that should work. Else, you can change it to LINE1 to get it calm.

> > For example, if you have missing channels between 450 and 471.25 MHz,
> > you can try with tuner=69 again.
> 
> It was my problem. The tvtime chooses the default frequency as
> us-cable network. I used --frequency=custom to fix that. Its working
> now.

Even better. We must look out for others failing for some frequencies
close to the takeovers globally, but looks good.

> > Is for that card FM radio support announced?
> 
> Not sure about that. Its not working I think.

That tuner you pointed to has no radio support.
Also, it is mostly that the driver becomes better over times.

There is no indication yet, that there could be a separate radio tuner
on a different valid address yet.

> Again, thanks for all your help. You are a genius :-)

For sure not.

But I know, looking at the full moon from southern India compared to my
place, really makes a difference. With a cup of tea or not.

Cheers,
Hermann


