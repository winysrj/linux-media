Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34617 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbbEQLzZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2015 07:55:25 -0400
Received: by pdbnk13 with SMTP id nk13so8914418pdb.1
        for <linux-media@vger.kernel.org>; Sun, 17 May 2015 04:55:24 -0700 (PDT)
Date: Sun, 17 May 2015 21:55:16 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-media@vger.kernel.org, crope@iki.fi
Subject: Re: rtl28xx Leadtek
Message-ID: <20150517115514.GA42191@shambles.windy>
References: <20150516032301.GA41435@shambles.windy>
 <5556E5BB.5070009@eyal.emu.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5556E5BB.5070009@eyal.emu.id.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 16, 2015 at 04:37:47PM +1000, Eyal Lebedinsky wrote:
> On 16/05/15 13:23, Vincent McIntyre wrote:
> >Hi,
> >
> >I have been trying to get support going for a
> >Leadtek WinFast DTV2000DS Plus (usbid 0413:6f12)
> 
> In case it matters here, I have these cards and am using the driver
> built from
> 	git clone git://linuxtv.org/media_build.git
> 	git clone git@github.com:jaredquinn/DVB-Realtek-RTL2832U.git
> 
> I get rather reliable tuning with hardly any of the old problems of
> zero length recordings of fails to tune  some channels.
> 
> I run old fedora 19 though, and things may have deteriorated since?
> Last time I needed to build was Jan 31 for kernel 3.14.27-100.fc19.x86_64.
> Is this driver included with the kernel these days?

Thanks for your reply Eyal.
There is certainly an in-kernel driver, which I am trying to use.
I don't know what relation it has to the github code, which looks
to have useful information on registers and other magic numbers
that might be needed for proper operation.

Antti, would you care to comment on whether the github code
linked above is useful at all for your work on the realtek drivers?

Cheers
Vince
