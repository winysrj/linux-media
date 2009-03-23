Return-path: <linux-media-owner@vger.kernel.org>
Received: from web56908.mail.re3.yahoo.com ([66.196.97.97]:23808 "HELO
	web56908.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750822AbZCWNwG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 09:52:06 -0400
Message-ID: <871136.15243.qm@web56908.mail.re3.yahoo.com>
References: <164695.77575.qm@web56903.mail.re3.yahoo.com>  <412bdbff0903161118o2d038bdetc4d52851e35451df@mail.gmail.com>  <63160.21731.qm@web56906.mail.re3.yahoo.com>  <1237251478.3303.37.camel@palomino.walls.org>  <954486.20343.qm@web56908.mail.re3.yahoo.com>  <1237425168.3303.94.camel@palomino.walls.org> <de8cad4d0903220853v4b871e91x7de6efebfb376034@mail.gmail.com>
Date: Mon, 23 Mar 2009 06:52:01 -0700 (PDT)
From: Corey Taylor <johnfivealive@yahoo.com>
Subject: Re: Problems with Hauppauge HVR 1600 and cx18 driver
To: Brandon Jenkins <bcjenkins@tvwhere.com>,
	Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org
In-Reply-To: <de8cad4d0903220853v4b871e91x7de6efebfb376034@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Andy,

> I am noticing an improvement in pixelation by setting the bufsize to
> 64k. I will monitor over the next week and report back. I am running 3
> HVR-1600s and the IRQs are coming up shared with the USB which also
> supports my HD PVR capture device. Monday nights are usually one of
> the busier nights for recording so I will know how well this holds up.

> Thanks for the tip!

> Brandon

Hi Andy and Brandon, I too tried various different bufsizes as suggested and I still see very noticeable pixelation/tearing regardless of the setting.

I even upgraded my motherboard this past weekend to an Asus AM2+ board with
Phenon II X3 CPU. Still the same problems with the card in a brand new
setup.

I also tried modifying the cx18 source code as Andy suggested and that made more debug warning show up in my syslog, but still did not resolve the issue. Haven't tried this yet with the new motherboard though.

Is it possible that this card is more sensitive to hiccups in the signal coming from the cable line? Or interference from other close-by cables and electronic equipment?

When recording/watching Live TV through MythTV, I see that ffmpeg is constantly outputting various errors related to the video stream. I can post those here if you think it's relevant.

Shoud I just return this card and get one with a different chipset? Or do you think driver updates can solve the issue?

I'm happy to hold on to this card if it means I can contribute in some way to fixing the problem, if it's fixable : )


      
