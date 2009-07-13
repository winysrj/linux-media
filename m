Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:51806 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbZGMOgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2009 10:36:11 -0400
Received: by fg-out-1718.google.com with SMTP id e21so672097fga.17
        for <linux-media@vger.kernel.org>; Mon, 13 Jul 2009 07:36:10 -0700 (PDT)
Date: Mon, 13 Jul 2009 16:36:15 +0200
To: "hermann pitton" <hermann-pitton@arcor.de>
Subject: Re: Report: Compro Videomate Vista T750F
From: Samuel Rakitnican <semirocket@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; format=flowed; delsp=yes; charset=windows-1250
MIME-Version: 1.0
References: <op.uwycxowt80yj81@localhost>
 <1247434386.5152.28.camel@pc07.localdom.local>
Content-Transfer-Encoding: 7bit
Message-ID: <op.uw0f6php80yj81@localhost>
In-Reply-To: <1247434386.5152.28.camel@pc07.localdom.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hi Hermann,

  On Sun, 12 Jul 2009 23:33:06 +0200, hermann pitton
  <hermann-pitton@arcor.de> wrote:

  [snip]
> Hm, if I get it right, without using windows previously the XCeive at
> 0x61 is not found and then it is tried in vain to use the qt1010 at
> 0x62.
>
> Also, after using windows gpio20 seems to be high.
> Maybe that is the gpio to get the tuner out of reset.
>
> Please try the attached patch as a shot into the dark.
>
  [snip]

No, I pay attention when I test for channel that XCeive gets recognized
as 0x61. When I do cold boot, or windows reboot its always gets
recognized at 0x61. Sometimes (I don't know exactly what triggers that)
the 0x61 gets omitted, and the result is that XCeive get recognized as
0x62. The result is that channel is not showing any more, apparently.

I think that xc2028-27.fw file load failures triggers that behavior,
because when I reboot linux with loading firmware failures, that
behavior is showing (from what I have noticed).

Sorry for the gpio alert, but I did some logging, and the gpio value
varies, and depends on computer state. But it seems that is same in both
cases after all. (details http://pastebin.com/f4c511dfc)

I tried your patch, too, and it's not working. Thank you for trying.
