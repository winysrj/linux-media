Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54680 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab2KDUuq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Nov 2012 15:50:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TV79h-0005NX-5W
	for linux-media@vger.kernel.org; Sun, 04 Nov 2012 21:50:53 +0100
Received: from c-24-63-250-56.hsd1.ma.comcast.net ([24.63.250.56])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 04 Nov 2012 21:50:53 +0100
Received: from dataclue by c-24-63-250-56.hsd1.ma.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 04 Nov 2012 21:50:53 +0100
To: linux-media@vger.kernel.org
From: Gene K <dataclue@yahoo.com>
Subject: Re: Please help me with cx88 audio
Date: Sun, 4 Nov 2012 20:50:33 +0000 (UTC)
Message-ID: <loom.20121104T214730-641@post.gmane.org>
References: <loom.20121028T011532-70@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Gene K <dataclue <at> yahoo.com> writes:

> 
> I can't get the cx88-alsa driver to produce anything but loud noise (white 
noise 
> or pink noise) from my FusionHDTV 5 Gold card. This problem has been reported 
on 
> this list and elsewhere, but seemingly with no resolution, despite a LOT of 
RTFM 
> and Googling. I have tried a variety of tools and settings, but the result is 
> always the same. Video works. Audio in digital mode works. This is for "line 
in" 
> inputs on the card.
> 
> This is on 3.6.1.fc17.x86_64. 
> 
> Disturbingly, dmesg has a lot of this
> 
> [ 2754.810011] cx88[0]: irq aud [0x1001] dn_risci1* dn_sync*



Can anyone help? It is probably something simple, like the audio-mux/GPIO 
settings, but I just can't find enough information to fix it myself or even 
experiment! 

Is there a way to control audio mux or GPIO explicitly from userspace, so I can 
try to poke around to see if it's that? 

Thanks again. 





