Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm13.bullet.mail.ird.yahoo.com ([77.238.189.66]:43385 "HELO
	nm13.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751102Ab2GGKKq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jul 2012 06:10:46 -0400
Message-ID: <1341655844.10317.YahooMailClassic@web29406.mail.ird.yahoo.com>
Date: Sat, 7 Jul 2012 11:10:44 +0100 (BST)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: unload/unplugging (Re: success! (Re: media_build and Terratec Cinergy T Black.))
To: Antti Palosaari <crope@iki.fi>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <4FF80499.4010808@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Sat, 7/7/12, Antti Palosaari <crope@iki.fi> wrote:

<snipped>
> > I also have quite a few :
> > 
> > [224773.229293] DVB: adapter 0 frontend 0 frequency 2
> out of range (174000000..862000000)
> > 
> > This seems to come from running w_scan.
> 
> yes, those warnings are coming when application request
> illegal frequency. Setting frequency as a 2 Hz is something
> totally wrong, wild guess, it is some other value set
> accidentally as frequency.

I am thinking either w_scan is doing something it should not, in which case we should inform its author to have this looked at, or the message does not need to be there?

> > The kernel seems happy while having the device
> physically pulled out. But the kernel module does not like
> to be unloaded (modprobe -r) while mplayer is running, so we
> need to fix that.
> 
> Yep, seems to refuse unload. I suspect it is refused since
> there is ongoing USB transmission as it streams video. But
> should we allow that? And is removing open device nodes OK
> as applications holds those?

I am thinking about suspend/resume, the poorman's way, which is to unload/reload. One interesting thing to try would be to pause but not quit the application - either just press pause, or say, 'gdb <mplayerbinary> <pid>', and see if 'modprobe -r' can be made to work under that sort of condition, if it isn't already.
