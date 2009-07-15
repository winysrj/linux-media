Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:45341 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755581AbZGOBBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2009 21:01:03 -0400
Subject: Re: Report: Compro Videomate Vista T750F
From: hermann pitton <hermann-pitton@arcor.de>
To: Samuel Rakitnican <semirocket@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <op.uw0f6php80yj81@localhost>
References: <op.uwycxowt80yj81@localhost>
	 <1247434386.5152.28.camel@pc07.localdom.local>
	 <op.uw0f6php80yj81@localhost>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 02:51:39 +0200
Message-Id: <1247619099.3188.8.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Montag, den 13.07.2009, 16:36 +0200 schrieb Samuel Rakitnican:
> Hi Hermann,
> 
>   On Sun, 12 Jul 2009 23:33:06 +0200, hermann pitton
>   <hermann-pitton@arcor.de> wrote:
> 
>   [snip]
> > Hm, if I get it right, without using windows previously the XCeive at
> > 0x61 is not found and then it is tried in vain to use the qt1010 at
> > 0x62.
> >
> > Also, after using windows gpio20 seems to be high.
> > Maybe that is the gpio to get the tuner out of reset.
> >
> > Please try the attached patch as a shot into the dark.
> >
>   [snip]
> 
> No, I pay attention when I test for channel that XCeive gets recognized
> as 0x61. When I do cold boot, or windows reboot its always gets
> recognized at 0x61. Sometimes (I don't know exactly what triggers that)
> the 0x61 gets omitted, and the result is that XCeive get recognized as
> 0x62. The result is that channel is not showing any more, apparently.
> 
> I think that xc2028-27.fw file load failures triggers that behavior,
> because when I reboot linux with loading firmware failures, that
> behavior is showing (from what I have noticed).
> 
> Sorry for the gpio alert, but I did some logging, and the gpio value
> varies, and depends on computer state. But it seems that is same in both
> cases after all. (details http://pastebin.com/f4c511dfc)
> 
> I tried your patch, too, and it's not working. Thank you for trying.

Hi Samuel,

thanks for that clarification.

I don't know, if Markus has something better in his binary blob
meanwhile, he was initially interested at least, but how to comment on
stuff not shown anymore ...

At least, the remote will be operable for cheap.

Does anybody know, why Compro doesn't clear the eeprom byte for the
analog demodulator since years (0x86)? F* it.

Cheers,
Hermann





