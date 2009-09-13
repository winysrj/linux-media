Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:38322 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753790AbZIMX1N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 19:27:13 -0400
Subject: Re: Pinnacle PCTV 310i active antenna
From: hermann pitton <hermann-pitton@arcor.de>
To: Martin Konopka <martin.konopka@mknetz.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200909131637.12483.martin.konopka@mknetz.de>
References: <200907011701.43079.martin.konopka@mknetz.de>
	 <200908281827.58036.martin.konopka@mknetz.de>
	 <1251589115.26402.11.camel@pc07.localdom.local>
	 <200909131637.12483.martin.konopka@mknetz.de>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 01:22:51 +0200
Message-Id: <1252884171.4318.58.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

Am Sonntag, den 13.09.2009, 16:37 +0200 schrieb Martin Konopka:
> Hi Hermann,
> 
> thank you, the patch for the antenna power is working for me with the latest 
> mercurial tree. I'm now able to receive additional weak channels. On the 
> contrary a channel close by with a very strong signal disappeared. The 
> stand-alone receiver with antenna power that I have can receive both channels 
> at the same time.

thanks for your testing!

On many demods it is already reported, that a too strong signal might
need attenuation. 

With the mix of different transmitters we now have, more established by
means to serve federal states instead of having an over all concept, I
don't wonder to get such a report now too the first time.

It likely needs some RFC to think about all possible combinations of
LNAs and active antenna support and how best to deal with it.

Cheers,
Hermann


> Am Sonntag, 30. August 2009 01:38:35 schrieb hermann pitton:
> > A testhack, not a clean implementation, is attached and should give you
> > voltage to the active antenna when using DVB-T.
> >
> > BTW, the radio seems to be broken since some weeks.
> > It is not by that patch here.
> >
> > Cheers,
> > Hermann
> >
> 
> 
> Cheers,
> 
> Martin

