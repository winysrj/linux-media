Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [217.10.138.207] (helo=server30.ukservers.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stephen@rowles.org.uk>) id 1JvwkT-0001G6-QL
	for linux-dvb@linuxtv.org; Tue, 13 May 2008 17:49:27 +0200
Message-ID: <17428.81.144.130.125.1210692335.squirrel@manicminer.homeip.net>
In-Reply-To: <48299D88.3060608@cis.strath.ac.uk>
References: <48299D88.3060608@cis.strath.ac.uk>
Date: Tue, 13 May 2008 16:25:35 +0100 (BST)
From: "Stephen Rowles" <stephen@rowles.org.uk>
To: "Gary Napier" <gnapier@cis.strath.ac.uk>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-3000
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> The problem.
> The tv is very slow to update and impossible to watch. I would like to
> know if this is a driver/software issue or
> a hardware issue. During TV playback the processor maxs out at 100%
>
> 1. Am i right in assuming that the output from the HVR-3000 (DVB-T) is
> an MPEG stream, and as such needs very little CPU resources?
> 2. Am i right in assuming that with the Hardware MPEG decoding ability
> of the Via C7, very little CPU resources are needed for playback?
> 3. What tools are available for me to get a measure of signal strength
> and quality of broadcast, which i believe may be the issue (although
> dedicated Set Top boxes seem to work fine)?
> 4. Please share any other comments that may be useful to the setup.
>
> Cheers
> Gary

I run a via SP13000 to watch DVB-T in the UK. But you have to use
accelerated playback to get a decent system running rather than relying on
the CPU. For this to work you will need the openchrome packages installed
(note Fedora 9 this should work out of the box):

http://wiki.openchrome.org/tikiwiki/tiki-index.php?page=Collection+of+contributed+binary+packages

For playback I then use the standard xine rpm from the livna repository,
then I use that to "play" a DVB channel using the following:

/usr/bin/xine -V xxmc dvb://BBC ONE

The key here is using -V xxmc to enable the hardware accelerated playback,
there are similar options to mplayer to achieve the same effect.

(note in reality I don't do anything on the command line, I just use
Freevo with the appropriate setup: http://freevo.sourceforge.net/)

>From my experience you MUST get the accelerated playback via XvMC working
to stand a chance of playing mpeg content on a small via system. And you
won't get anything working for h.264 high-def content. Your 100% cpu usage
indicates that the lack of acceleration support is the problem.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
