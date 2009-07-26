Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.221.181]:44691 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbZGZPsq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jul 2009 11:48:46 -0400
Received: by qyk11 with SMTP id 11so94432qyk.33
        for <linux-media@vger.kernel.org>; Sun, 26 Jul 2009 08:48:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248558423.3341.115.camel@pc07.localdom.local>
References: <1f8bbe3c0907232102t5c658d66o571571707ecdb1f4@mail.gmail.com>
	 <1248411383.3247.18.camel@pc07.localdom.local>
	 <1f8bbe3c0907232218g45c89eeapc4b86e9d07217037@mail.gmail.com>
	 <1248415576.3245.16.camel@pc07.localdom.local>
	 <1f8bbe3c0907250856h6c059658m6caa838a0ac6f9c2@mail.gmail.com>
	 <1248558423.3341.115.camel@pc07.localdom.local>
Date: Sun, 26 Jul 2009 21:11:46 +0530
Message-ID: <1f8bbe3c0907260841p2b7f94c7i109f1b9597fc9783@mail.gmail.com>
Subject: Re: Problem with My Tuner card
From: unni krishnan <unnikrishnan.a@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


> It seems to me we have to add a new entry for your card.
> Does it have a unique name they sell it, do you know the manufacturer?

Yes, card is called SSD-TV-675 (
http://www.techcomindia.com/home.php?vaction=showprodd&cat=102&catt=TV%20Tuners&subcat=&subcatt=&prodid=501
)

> Is there a website or did you investigate all the printings on the PCB
> already.
> The tuner type label is often hidden under a OEM vendor label.
> Sometimes a drop of salad oil is enough to make the upper sticker
> transparent. Tuner factory label underneath is in most cases close to
> the antenna connector.

I got that :

QSD-MT-S73 BD . I think this is the site
http://www.szqsd.cn/en/product_show.asp?id=89

> Since 0x8000 does not work for mute on your card, you can try 0x4000 and
> 0x2000 in the mute section.

Note sure how I can do that. Need more help :-)

> For example, if you have missing channels between 450 and 471.25 MHz,
> you can try with tuner=69 again.

It was my problem. The tvtime chooses the default frequency as
us-cable network. I used --frequency=custom to fix that. Its working
now.

> Is for that card FM radio support announced?

Not sure about that. Its not working I think.

Again, thanks for all your help. You are a genius :-)

---------------------
With regards,
Unni

"A candle loses nothing by lighting another candle"
