Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946041Ab3BHPRu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Feb 2013 10:17:50 -0500
Date: Fri, 8 Feb 2013 13:17:42 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Cc: linux-media@vger.kernel.org
Subject: Re: terratec h5 rev. 3?
Message-ID: <20130208131742.32ab0750@redhat.com>
In-Reply-To: <510668E3.8060603@hispeed.ch>
References: <50D3F5A8.5010903@hispeed.ch>
	<510668E3.8060603@hispeed.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 28 Jan 2013 13:02:43 +0100
Roland Scheidegger <rscheidegger_lists@hispeed.ch> escreveu:

> From: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
> To: linux-media@vger.kernel.org
> Subject: Re: terratec h5 rev. 3?
> Date: Mon, 28 Jan 2013 13:02:43 +0100
> Sender: linux-media-owner@vger.kernel.org
> User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
> 
> Am 21.12.2012 06:38, schrieb linux-media-owner@vger.kernel.org:
> > Hi,
> > 
> > I've recently got a terratec h5 for dvb-c and thought it would be
> > supported but it looks like it's a newer revision not recognized by em28xx.
> > After using the new_id hack it gets recognized and using various htc
> > cards (notably h5 or cinergy htc stick, cards 79 and 82 respectively) it
> > seems to _nearly_ work but not quite (I was using h5 firmware for the
> > older version). Tuning, channel scan works however tv (or dvb radio)
> > does not, since it appears the error rate is going through the roof
> > (with some imagination it is possible to see some parts of the picture
> > sometimes and hear some audio pieces).  
> 
> Ok I have received a replacement now and I can confirm this stick in
> fact just works like the same as the older versions (I guess maybe the
> first one had bad solder point?). I can't judge signal sensitivity or
> anything like that (the snr values are rather humorous) but it's
> definitely good enough now with no reception issues. The IR receiver is
> another matter and I was unsuccesful in making it work for now (I guess
> noone got it working with the old versions neither as it lacks the ir
> entries).
> So could this card be added? I've added the trivial patch.

Could you please add your Signed-of-by: to the patch?

Thanks,
Mauro
> 
> Roland
> 
> 
> 
> [h5rev3.diff  text/x-patch (549 bytes)] 

-- 

Cheers,
Mauro
