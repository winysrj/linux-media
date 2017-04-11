Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60483 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752232AbdDKFGn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 01:06:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Daniel Roschka <danielroschka@phoenitydawn.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Quirk for webcam in MacBook Pro 2016
Date: Tue, 11 Apr 2017 08:07:35 +0300
Message-ID: <2893913.1LRtBbgXDi@avalon>
In-Reply-To: <3400997.bXbnOMutrN@buzzard>
References: <4643839.ui0SUBUoba@buzzard> <9504811.tIhrXQ8rYn@avalon> <3400997.bXbnOMutrN@buzzard>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

On Monday 10 Apr 2017 20:01:18 Daniel Roschka wrote:
> Hi Laurent,
> 
> I'm really sorry for all the wrong formatting. I already took measures so it
> won't happen again.

Don't worry, I've seen worse :-)

> > Your patch is now in my git tree, and I will push it upstream for v4.13
> > (v4.11 will be released very soon, and given the pending pull requests for
> > v4.12 in the Linux media tree I don't think I can add another one).
> 
> Thanks a lot. Highly appreciated.
> 
> > I collect USB descriptors for UVC devices. Could you please send me the
> > output of
> > 
> > lsusb -d 05ac:8600
> 
> I guess you want the verbose output of lsusb. You'll find it in the attached
> file. It might contain more than than you expect as the iBridge device is a
> custom ARM processor (probably very similar to the one in the Apple Watch),
> not just connecting the webcam to the rest of the system, but also the
> Touch Bar and the Touch ID sensor.

Thank you very much for the information.

-- 
Regards,

Laurent Pinchart
