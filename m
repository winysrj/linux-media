Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:43218 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab2F3JoH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 05:44:07 -0400
Message-ID: <4FEECA65.9090205@kolumbus.fi>
Date: Sat, 30 Jun 2012 12:44:05 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	htl10@users.sourceforge.net
Subject: Re: DVB core enhancements - comments please?
References: <4FEBA656.7060608@iki.fi>
In-Reply-To: <4FEBA656.7060608@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Antti.

My suspend / resume patch implemented "Kaffeine continues viewing channel after resume".
Some of the ideas could be still useful: http://www.spinics.net/lists/linux-dvb/msg19651.html

Rest of this email has a more thorough description.

Regards,
Marko Ristola

On 06/28/2012 03:33 AM, Antti Palosaari wrote:
> Here is my list of needed DVB core related changes. Feel free to comment - what are not needed or what you would like to see instead. I will try to implement what I can (and what I like most interesting :).
>
...
> suspend / resume support
> --------------------------------------------------
> * support is currently quite missing, all what is done is on interface drivers
> * needs power management
> * streaming makes it hard
> * quite a lot work to get it working in case of straming is ongoing


I've implemented Suspend/Resume for Mantis cu1216 in 2007 (PCI DVB-C device):
Kaffeine continued viewing the channel after resume.
When Tuner was idle too long, it was powered off too.

According to Manu Abraham at that time, somewhat smaller patch would have sufficed.
That patch contais nonrelated fixes too, and won't compile now.

Here is the reference (with Manu's answer):
Start of the thread: http://www.spinics.net/lists/linux-dvb/msg19532.html
The patch: http://www.spinics.net/lists/linux-dvb/msg19651.html
Manu's answer: http://www.spinics.net/lists/linux-dvb/msg19668.html

Thoughts about up-to-date implementation
- Bridge (PCI) device must implement suspend/resume callbacks.
- Frontend might need some change (power off / power on callbacks)?
- "save Tuner / DMA transfer state to memory" might be addable to dvb_core.
- Bridge device supporting suspend/resume needs to have a (non-regression)
   fallback for (frontend) devices that don't have a full tested "Kaffeine works"
   suspend/resume implementation yet.
- What changes encrypted channels need?

Marko
