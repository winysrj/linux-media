Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:55488 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933664Ab0BQC6p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2010 21:58:45 -0500
Subject: Re: Remote control at Zolid Hybrid TV Tuner
From: hermann pitton <hermann-pitton@arcor.de>
To: Sander Pientka <cumulus0007@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <db09c9681002161116k52278916ob68884ddc989044@mail.gmail.com>
References: <db09c9681002161116k52278916ob68884ddc989044@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 17 Feb 2010 03:56:25 +0100
Message-Id: <1266375385.3176.5.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sander,

Am Dienstag, den 16.02.2010, 20:16 +0100 schrieb Sander Pientka:
> Hi,
> 
> my Zolid Hybrid TV Tuner has been working like a charm for over two
> months now. The remote control is not working though, which is a
> showstopper. I don't have experience with remote controls in any kind,
> I've heard of LIRC but I would rather choose a more elegant solution,
> for instance evdev in X11.
> 
> It's wiki page: http://www.linuxtv.org/wiki/index.php/Zolid_Hybrid_TV_Tuner

gpio init of your board is reported as 0x240000.

So gpio18/0x40000 is high.

Assuming the IR receiver is plugged during that, unplug it on next boot
and see if gpio init is now only 0x200000.

Cheers,
Hermann


