Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:40110 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbZBAKbL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2009 05:31:11 -0500
Message-ID: <49857A09.9020302@free.fr>
Date: Sun, 01 Feb 2009 11:31:37 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Jason Harvey <softdevice@jasonline.co.uk>
CC: linux-media@vger.kernel.org
Subject: Re: CinergyT2 not working with newer alternative driver
References: <4984E50D.8000506@jasonline.co.uk>
In-Reply-To: <4984E50D.8000506@jasonline.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jason,
Jason Harvey wrote:
> I have been successfully using VDR with two CinergyT2s for 18 months.
> After adding a Hauppage NOVA-S2-HD I updated my v4l-dvb drivers hoping
> to get S2 capability and test a newer VDR for HD reception.
> 
> The CinergyT2s stopped working. The kernel module loads, the blue leds
> flash as expected but they don't lock on to a signal for long.
> Signal strength shown in femon is erratic and a lock only rarely achieved.
> 
> I checked through the mercurial tree to see what had changed.
> It looks like the following change is the one that stops the CinergyT2s
> working on my system.
> http://git.kernel.org/?p=linux/kernel/git/mchehab/devel.git;a=commit;h=986bd1e58b18c09b753f797df19251804bfe3e84
> 
> 
> I deleted the newer version of the module and replace it with the
> previous deleted code.
> Make'd and installed the old version works as expected.
> 
> Machine they're plugged into is running Fedora 10,
> 2.6.27.12-170.2.5.fc10.i686
> I downloaded the current v4l-dvb today (31Jan2009) and tried it all
> again before posting this message.
> 
> Not sure where to look next, I did start to capture the USB traffic to
> see if I could spot the difference...
>
Please take a look at the message logs (dmesg).
You can follow the instructions described here http://www.linuxtv.org/wiki/index.php/Testing_your_DVB_device
and report where it fails.

I use tzap like this: tzap -c $HOME/.tzap/channels.conf -s -t 120 -r -o output.mpg "SomeChannel"
I am able to play with mplayer too.
Regards,
Thierry
