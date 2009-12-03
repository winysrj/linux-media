Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 2.mail-out.ovh.net ([91.121.26.226])
	by mail.linuxtv.org with smtp (Exim 4.69)
	(envelope-from <luca@ventoso.org>) id 1NG7RK-00020R-NR
	for linux-dvb@linuxtv.org; Thu, 03 Dec 2009 09:53:32 +0100
Message-ID: <4B177C81.5030900@ventoso.org>
Date: Thu, 03 Dec 2009 09:53:21 +0100
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
References: <4B14CC1E.7030102@ventoso.org>
	<alpine.DEB.2.01.0912030540570.4548@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.2.01.0912030540570.4548@ybpnyubfg.ybpnyqbznva>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

En/na BOUWSMA Barry ha escrit:
> Sorry for not composing this reply sooner...

Thank you for replying, no need to be sorry, I've been trying to send 
the message for ~1 month, so I'm not really in a hurry ;-)

> 
> I have the following in a source directory:
> 
> ls -lart  /home/beer/src/siano/firmware/
> total 428
> -rw-rw-r-- 1 beer besoffen 84164 2008-12-31 16:22 isdbt_nova_12mhz_b0.inp
> -rw-rw-r-- 1 beer besoffen 71428 2008-12-31 16:22 tdmb_nova_12mhz_b0.inp
> -rw-rw-r-- 1 beer besoffen 93624 2008-12-31 16:22 dvb_nova_12mhz_b0.inp
> -rw-rw-r-- 1 beer besoffen 38428 2008-12-31 16:26 tdmb_stellar_usb_12mhz_downld.inp
> -rw-rw-r-- 1 beer besoffen 38720 2008-12-31 16:26 tdmb_stellar_usb_12mhz_eeprom_a2.brn
> -rw-rw-r-- 1 beer besoffen 40348 2008-12-31 16:28 dvbh_stellar_usb_12mhz_downld.inp
> -rw-rw-r-- 1 beer besoffen 39676 2008-12-31 16:28 dvbt_stellar_usb_12mhz_downld.inp
> 
> This is from a URL provided by Siano in the archives of this list
> which can probably be found by searching for keywords like DAB
> or their host library.

Ah, ok, I got my sources from linuxtv and there's no firmware there.
In fact, one of the search results for "siano firmware" was a message 
from Mauro asking Uri (who doesn't work for siano any more) for 
permission to distribute the firmware, with no follow-ups.

> 
> In looking at the sms-cards.c source file, these Hauppauge
> rebrandings seem to be a change of the USB IDs, but the
> same firmwares are listed as are used by the Siano-sourced
> devices.
> 
> In other words, there shouldn't be a problem, and they may well
> be identical.  However, to set your mind at ease, I'd have to
> dig out my other copy of the firmwares to list file sizes and
> md5sums in order that you can see whether they match.

Don't worry, there's been no harm to the device (though it hasn't seen 
too much use).

> 
> 
> 
>> Oh, when I turn off the pc the stick is attached to (a vdr machine), it
>> still supplies 5v to the usb ports, and when I turn it on again the
>> stick fails. I have to unplug and replug it to make it work.
> 
> As I managed to kill off my workstation, more than once, I
> see the same problem with other USB devices that get power
> through other means.  I'd be inclined to believe this may be
> a problem in the USB stack, where it's not issuing a proper
> reset to restore the devices -- if this is possible with
> power supplied.

I found a something here

http://marc.info/?l=linux-usb-users&m=116827193506484&w=2

that purportedly resets an usb device.
What I tried was, before powering off:

1) unload the drivers
2) use the above to reset the stick
3) power off

and, before loading the drivers, issue a reset again.
Sometimes it works, sometimes it doesn't, the end result is that I 
cannot leave the device plugged-in if I want to use it.
Not to mention the annoying blue led constantly on :-D


> Those are just my observations -- as to whether this is a
> more general USB stack problem, or whether each driver for
> all these devices needs to be rewritten to handle this case
> of a device in a warm state, I don't know as I'm unfamiliar
> with the internal workings of USB or the devices.  But this
> seems to be a common enough problem, particularly annoying
> with my USB WLAN sticks, that it should be tackled -- either
> a complete power cycle or re-plug cycle is needed after a
> normal reboot, which is painful.  Particularly if done
> remotely.

Oh, it's a pain even if done locally, though you could say that doing it 
from the couch is actually doing it remotely ;-)

Thank you for your time.

Bye
-- 
Luca

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
