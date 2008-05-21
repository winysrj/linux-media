Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vps1.tull.net ([66.180.172.116])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <nick-linuxtv@nick-andrew.net>) id 1JyoLD-0004av-SF
	for linux-dvb@linuxtv.org; Wed, 21 May 2008 15:26:54 +0200
Date: Wed, 21 May 2008 23:26:19 +1000
From: Nick Andrew <nick-linuxtv@nick-andrew.net>
To: Christian Hack <christianh@edmi.com.au>
Message-ID: <20080521132619.GA27716@tull.net>
References: <000f01c8b98e$c88e6950$07000100@edmi.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <000f01c8b98e$c88e6950$07000100@edmi.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] LifeView TV Walker Twin DVB-T (LR540) Problem
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

On Mon, May 19, 2008 at 07:00:27PM +1000, Christian Hack wrote:
> Hi guys,
> 
> I've got one of these that has been successfully working on my MythDora
> (based on Fedora 8) machine for the past few months. It didn't ever scan
> properly though. I was able to use my other cards to populate the channel
> list. Once the channels were set up, it worked perfectly.
> 
> All of sudden it seems to have stopped working.

What changed? If it's not a hardware problem, then something must have
changed. Kernel upgraded, USB cable intermittent, firmware file removed
or renamed, antenna blown off roof, etc...

I'm suspicious about when you say "didn't ever scan properly". Mine
didn't scan either. Then I connected it to a proper antenna, and it
scanned fine.

> Using dvbtune it is unable
> to lock on to a signal. In MythTV I just get a garbled mess like a very bad
> signal. The audio is almost intelligble, video is a mess.

Have you tried tzap? Please post output from tzap and also the kernel
log messages generated using debug=1 and while tzap is running.

Mine are still working - at least they were the last time we watched TV
which must have been a few weeks ago :-)

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
