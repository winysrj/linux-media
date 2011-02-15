Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab1BPQ1y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 11:27:54 -0500
Date: Tue, 15 Feb 2011 17:18:57 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Fernando Laudares Camargos <fernando.laudares.camargos@gmail.com>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: IR for remote control not working for Hauppauge WinTV-HVR-1150
 (SAA7134)
Message-ID: <20110215221857.GB3327@redhat.com>
References: <AANLkTi=jkLGgZDH6XytL1MEE7w5SckZjXoGPhFSCo40b@mail.gmail.com>
 <20110215220433.GA3327@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215220433.GA3327@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Feb 15, 2011 at 05:04:33PM -0500, Jarod Wilson wrote:
> First off, video4linux-list is dead, you want linux-media (added to cc).
> 
> On Tue, Feb 15, 2011 at 06:27:29PM -0200, Fernando Laudares Camargos wrote:
> > Hello,
> > 
> > I have a Hauppauge WinTV-HVR-1150 (model 67201) pci tv tuner working
> > (video and audio) under Ubuntu 10.10 and kernel 2.6.35-25. But the IR
> > sensor is not being detected and no input device is being created at
> > /proc/bus/input.

Reading over the code some more, I don't see dev->has_remote set for the
HVR1150, so it appears the IR receiver on that hardware isn't actually yet
supported, so the patch I was thinking of may not help here. I failed to
notice the part where you said no input device was being created, that
patch only mattered if you were getting an rc input device created.

-- 
Jarod Wilson
jarod@redhat.com

