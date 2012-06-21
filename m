Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56370 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460Ab2FUCMy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 22:12:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1ShWt8-0004Hc-G7
	for linux-media@vger.kernel.org; Thu, 21 Jun 2012 04:12:50 +0200
Received: from 183.62.57.5 ([183.62.57.5])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 04:12:50 +0200
Received: from julia.cheung723 by 183.62.57.5 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 04:12:50 +0200
To: linux-media@vger.kernel.org
From: Julia <julia.cheung723@gmail.com>
Subject: Re: em28xx : can work on ARM beagleboard ?
Date: Thu, 21 Jun 2012 02:12:37 +0000 (UTC)
Message-ID: <loom.20120621T040939-677@post.gmane.org>
References: <4FA96365.3090705@yahoo.fr> <4FA964E8.8080209@iki.fi> <CAGoCfiy4qkVQwy+zPH+r8jMxMX7heJk6BLPnOMJxF73FnBms+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller <dheitmueller <at> kernellabs.com> writes:

> 
> On Tue, May 8, 2012 at 2:24 PM, Antti Palosaari <crope <at> iki.fi> wrote:
> > It should work as I know one person ran PCTV NanoStick T2 290e using
> > Pandaboard which is rather similar ARM hw.
> > http://www.youtube.com/watch?v=Wuwyuw0y1Fo
> 
> I ran into a couple of issues related to em28xx analog on ARM.
> Haven't had a chance to submit patches yet.  To answer the question
> though:  yes, analog support for the em28xx is known to be broken on
> ARM right now.
> 
> Devin
> 


hi Devin,
i don't understand what you mean when you say "analog support for the em28xx is
known to be broken on ARM right now'', I hope you can give me some advice.

I use Pinnacle DVC100 capture card on cm-t3530 card to capture analog images.
cm-t3530 uses linux 2.6.32 kernel. at first the card can be correctly detected
and by the cm-t3530 and generated as the device file /dev/video1.


but when I use some application to capture the images by use of v4l2,there is
something wrong and the strace of the application shows the error message is
"ioctl(3, VIDIOC_DQBUF, 0xbeeb4a00)      = ? ERESTARTSYS (To be restarted)". The
same application can correctly capture my usb-camera images.
 does the problem can be solved?  I am yearning for  your advice.

Best regards
Julia

