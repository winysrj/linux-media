Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:55625 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305AbZDWXhd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2009 19:37:33 -0400
Subject: Re: Kernel 2.6.29 breaks DVB-T ASUSTeK Tiger LNA Hybrid Capture
	Device
From: hermann pitton <hermann-pitton@arcor.de>
To: David Wong <davidtlwong@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, ramsoft@virgilio.it,
	linux-media@vger.kernel.org
In-Reply-To: <15ed362e0904140230j5116e527p64afc9a1a47fb9bc@mail.gmail.com>
References: <loom.20090403T201901-786@post.gmane.org>
	 <1238805912.3498.18.camel@pc07.localdom.local>
	 <1238806956.3498.26.camel@pc07.localdom.local>
	 <49D77ACC.9050606@virgilio.it>
	 <1238955753.6627.29.camel@pc07.localdom.local>
	 <20090414002341.48b6d974@pedra.chehab.org>
	 <15ed362e0904140230j5116e527p64afc9a1a47fb9bc@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 24 Apr 2009 01:37:29 +0200
Message-Id: <1240529849.3776.61.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David and all interested,

[snip]
> 
> Sorry for interrupt.
> Would your saa7134 i2c problem is due to the i2c quirk?
> I have problem on the saa7134 i2c quirk that I have to totally disable
> it on my work-in-progress card.
> Just a little suggestion that trying disable the i2c quirk like this change set:
> http://linuxtv.org/hg/~mkrufky/dmbth/rev/781ffa6c43d3
> 
> David.

I cross post this in for the record.

Commenting the i2c quirk does not help at all on these card, as already
assumed.

And I also can't see any pattern yet, which should cause this from
within v4l-dvb.

At least, but who has hardware to test on all cases, the i2c quirk Gerd
needed for the first saa7134 DVB card ever, the Pinnacle 300i, seems not
to be needed for a few other cards I could test on only for now with
saa7134 and saa7131e.

So, Jean likely is right, that we should have it the other way round and
this might help you and Mike with a decision still to make.

Since 2.6.28 did work for those cards and 2.6.30-rc2-git4 seems to work
within limited usability in my user environment, it seems to be
something in between and might not even be the same.

Cheers,
Hermann


