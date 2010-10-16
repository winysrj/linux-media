Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:40851 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab0JPM4X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 08:56:23 -0400
Message-ID: <4CB9A0DB.6060203@infradead.org>
Date: Sat, 16 Oct 2010 09:55:55 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] ov7670: disable QVGA mode
References: <20101008210418.2B1809D401C@zog.reactivated.net>	<20101008151305.68f3897a@bike.lwn.net> <AANLkTi=G_k6CSy9wUTiXNK9DHPwk4FTqPWRReRC7DO24@mail.gmail.com>
In-Reply-To: <AANLkTi=G_k6CSy9wUTiXNK9DHPwk4FTqPWRReRC7DO24@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 08-10-2010 18:18, Daniel Drake escreveu:
> On 8 October 2010 22:13, Jonathan Corbet <corbet@lwn.net> wrote:
>> A problem like that will be at the controller level, not the sensor
>> level.  Given that this is an XO-1 report, I'd assume something
>> requires tweaking in the cafe_ccic driver.  I wasn't aware of this; I
>> know it worked once upon a time.
> 
> I reported it 3 months ago
> http://dev.laptop.org/ticket/10231
> 
> Are you interested in working on this?
> I'd have no idea where to start.

It maybe at one or at the other. What happens is that, in general, both the controller
and the sensor discards the initial/final parts of a line. The visible area of the image
is (generally) configurable on both. If the visible area doesn't match, you'll see a vertical
or a horizontal line.

This is configured by hstart and hstop, in the case of ov sensors. If you wanna try to fix, all 
you need to do is do move the start/stop window, for example, subtracting 2 on both hstart/hstop. 
If this doesn't fix, try 3, 4, ...

Yet, as Jon mentioned, if this works on XO-1, the better fix would be to adjust the screen visible
area at XO-2 visible area setup (sometimes called "crop area" at datasheets).


> 
> I'm not so convinced that it's a controller problem rather than a
> sensor one, given that it says the sensor register values were
> determined empirically rather than from docs.
> 
> Thanks,
> Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

