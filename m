Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1NGAjK-0002L3-Tg
	for linux-dvb@linuxtv.org; Thu, 03 Dec 2009 13:24:20 +0100
Received: by ewy7 with SMTP id 7so340982ewy.12
	for <linux-dvb@linuxtv.org>; Thu, 03 Dec 2009 04:23:45 -0800 (PST)
Date: Thu, 3 Dec 2009 13:23:37 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Luca Olivetti <luca@ventoso.org>
In-Reply-To: <4B177C81.5030900@ventoso.org>
Message-ID: <alpine.DEB.2.01.0912031303050.4548@ybpnyubfg.ybpnyqbznva>
References: <4B14CC1E.7030102@ventoso.org>
	<alpine.DEB.2.01.0912030540570.4548@ybpnyubfg.ybpnyqbznva>
	<4B177C81.5030900@ventoso.org>
MIME-Version: 1.0
Cc: Linux DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] siano firmware and behaviour after resuming power
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

On Thu, 3 Dec 2009, Luca Olivetti wrote:

> > This is from a URL provided by Siano in the archives of this list
> > which can probably be found by searching for keywords like DAB
> > or their host library.
> 
> Ah, ok, I got my sources from linuxtv and there's no firmware there.
> In fact, one of the search results for "siano firmware" was a message from
> Mauro asking Uri (who doesn't work for siano any more) for permission to
> distribute the firmware, with no follow-ups.

Oh, in case it would be helpful (meaning that either the previous,
now snipped, filesizes would match your firmware, or these which
I quote now match), here's what I dug out of the musty depths of
the machine hidden away -- these are likely to be the files for
the firmware as extracted from the CD-ROM that came with my 
device, if not downloaded elsewhere, based on the timestamps.

[13:00:05]beer@charlie:/tmp$ ls -lart /tmp/server/usr/lib/hotplug/firmware/
total 928
-r-xr-xr-x 1 beer besoffen  40324 2007-03-21 21:48 dvbh_stellar_usb.inp
-r-xr-xr-x 1 beer besoffen  38144 2007-05-17 14:35 dvbt_stellar_usb.inp
-r-xr-xr-x 1 beer besoffen  38144 2007-05-17 14:35 dvbt_bda_stellar_usb.inp
-r-xr-xr-x 1 beer besoffen  40096 2007-05-17 14:38 tdmb_stellar_usb.inp

Sorry I only saved those corresponding to my device.  As you can
see, the file sizes differ between the two sources, but perhaps
you can match them against the tarballs from Steven Toth, to
determine whether your firmware is the same as either of these
manufacturer- or vendor-supplied sources.

This is all going from memory, but if it helps set your mind at
ease, then I'm happy to help.



> > As I managed to kill off my workstation, more than once, I
> > see the same problem with other USB devices that get power
> > through other means.  I'd be inclined to believe this may be
> > a problem in the USB stack, where it's not issuing a proper
> > reset to restore the devices -- if this is possible with
> > power supplied.
> 
> I found a something here
> 
> http://marc.info/?l=linux-usb-users&m=116827193506484&w=2
> 
> that purportedly resets an usb device.
> What I tried was, before powering off:
> 
> 1) unload the drivers
> 2) use the above to reset the stick
> 3) power off
> 
> and, before loading the drivers, issue a reset again.
> Sometimes it works, sometimes it doesn't, the end result is that I cannot
> leave the device plugged-in if I want to use it.

That might work for a planned reboot -- my reboots are 
occasionally unplanned, and the devices are in part hanging
at boot time.  I guess if I had had the patience to watch and
see if the wait eventually timed out, I could test just how
the system came up and reset anything not present (and then
configure it as needed). Too much work for a non-critical
system, when I'd rather it Just Work.

I am lazy.  So sue me  :-)


barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
