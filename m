Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:21661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab1ACVDI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jan 2011 16:03:08 -0500
Message-ID: <4D223964.4060107@redhat.com>
Date: Mon, 03 Jan 2011 19:02:28 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Marcos Alejandro Saldivia Delgado <marcos.saldivia@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Problem with em28xx driver in Gumstix Overo
References: <AANLkTinPEYyLrTWqt1r0QgoYmsv2Xg16qGKo5yTqu9FO@mail.gmail.com> <AANLkTinimPHSRXfWtu+eiv3Y4WZ6PGrbB3sZKBvw2Muy@mail.gmail.com> <AANLkTi=AVjhEbsqZOWJbwkYRo+HLoHfdWxuFO7Bs_a7H@mail.gmail.com>
In-Reply-To: <AANLkTi=AVjhEbsqZOWJbwkYRo+HLoHfdWxuFO7Bs_a7H@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Marcos,

Em 03-01-2011 18:13, Linus Torvalds escreveu:
> Hi Marcos,
> 
> [ full email quoted for new cc's ]
> 
> you really would be much better off sending a diff rather than trying
> to explain what changes you did, but quite frankly, even if you did
> that, I'd still want this to go through the actual maintainers of the
> em28xx driver.

As I explained to the email you sent me in priv, It seems that
there's a bug at the scaling function. Not sure why this but doesn't 
show on x86. 

I intend to do some tests with em28xx and fix the issue, but I can't 
do it this week. I have a few arm boards, and I'll test on them with
some em28xx devices.

> The USB error sounds like some independent unrelated issue, I have no
> ideas on it.

Yes, it seems to be unrelated. Those video drivers generate a lot of ISOC
traffic at the USB bus. I suspect that the hardware have some problems
to keep that high bandwidth rate.  Maybe one of the ARM maintainers could
give us some light around this issue, as this driver doesn't suffer any
known issue of this kind on x86 arch. We even did a large stress test on 
em28xx driver in the past, in order to fix a memory leak there.

Cheers,
Mauro.
