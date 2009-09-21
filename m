Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f216.google.com ([209.85.220.216]:55333 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbZIUIT0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 04:19:26 -0400
Received: by fxm12 with SMTP id 12so1999147fxm.18
        for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 01:19:29 -0700 (PDT)
Date: Mon, 21 Sep 2009 11:19:33 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: Roman <lists@hasnoname.de>
Cc: linux-media@vger.kernel.org
Subject: Re: MSI Digivox mini III Remote Control
Message-ID: <20090921081933.GA29884@moon>
References: <200909202026.27086.lists@hasnoname.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909202026.27086.lists@hasnoname.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Well, it seems there is a patch for Digivox mini III remote control at
http://linuxtv.org/hg/~anttip/af9015-digivox3_remote/, perhaps Antti
can tell you more about it.

I got this tuner, and no, IR receiver doesn't work for me, it doesn't
even work in WinXP with bundled drivers and software, tested with
USB snoop, no reaction to keypresses. Maybe a hardware defect at
receiver part, maybe something is missing in a firmware, no idea.

So check it on some Windows system first, then try patch..


On Sun, Sep 20, 2009 at 08:26:26PM +0200, Roman wrote:
> hi,
> 
> after my previous failure with the hvr-900h and another Digivox micro hd, i am 
> finally able to watch dvb-tv with the Digivox mini III.
> Has anyone gotten the IR working? The wiki-entry says it is not supported 
> yet.... on the other hand MSI provides linux-drivers that don't seem to work 
> on recent kernels...
> 
> greetings,
> Roman
> -- 
> Leave no stone unturned.
> 		-- Euripides
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
