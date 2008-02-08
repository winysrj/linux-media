Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from smtp109.rog.mail.re2.yahoo.com ([68.142.225.207])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <CityK@rogers.com>) id 1JNVQg-0005qG-8S
	for linux-dvb@linuxtv.org; Fri, 08 Feb 2008 16:46:18 +0100
Message-ID: <47AC7925.8050709@rogers.com>
Date: Fri, 08 Feb 2008 10:45:41 -0500
From: CityK <CityK@rogers.com>
MIME-Version: 1.0
To: Per Blomqvist <p.blomqvist@lsn.se>
References: <47AB7865.5090008@lsn.se>
In-Reply-To: <47AB7865.5090008@lsn.se>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help! I cant view video. BUT I can scan!!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Per Blomqvist wrote:
> I just signed up for this mailing-list ( I hope this is the right =

> forum.. =

>   =


Hi, yes, you're in the right place.

> I can "dvbscan" and  "tzap", and gets indication of a good signal. BUT, =

> I cant view the video!
> (from the dvb device)
>
> Also "dvbdate" command works (that returns time and date from the air, I =

> presume). But not a command as "dvbsnoop" (that need =

> "/dev/dvb/adapter0/dvr").
>
> A sample: ( Its step by step of your guide:
> http://www.linuxtv.org/wiki/index.php/Testing_your_DVB_device )
>
> In one console I run: /.tzap# tzap -r -c channels.conf "TV4 =D6resund" ( =

> and are getting lines as:
> status 1f | signal c3c3 | snr ffff | ber 0000004a | unc 00000000 | =

> FE_HAS_LOCK
> status 1f | signal c3c3 | snr ffff | ber 0000004e | unc 00000000 | =

> FE_HAS_LOCK
> ...
> AND in another console:
> mplayer -v /dev/dvb/adapter0/dvr0
> (thats basically halts without any further information)
>
> ALSO if I type: "cat /dev/dvb/adapter0/dvr0 > afile.txt"
> (But then again, "afile.txt" remains empty)
>
> Conclusion, /dev/dvb/adapter0/dvr0 never returns anything. This =

> "/dev/dvb/adapter0/dvr" isnt proper. Must be a Linux-kernel/module =

> problem..
>   =


Not so fast! If the channel is encrypted, this is precisely what you =

will observe ... though, because this is over-the-air that we're talking =

about, this seems less likely to be the case (but you will have to =

confirm nonetheless).   =


I'm more inclined to think that this is related to an issue with stream =

identifiers.  Is Sweden using MP4 now? =

Some further questions, what drivers are you using (distro or recent =

LinuxTV)?
What dvb-apps ... Christophe had updated the dvb-apps not to long ago =

with some changes in regards to MP4 streams (can't remember the exact =

nature, but perhaps you should grab a new copy from LinuxTV and try with =

those).

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
