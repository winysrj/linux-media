Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail1.perspektivbredband.net ([81.186.254.13])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <p.blomqvist@lsn.se>) id 1JNdaH-0006hZ-Rb
	for linux-dvb@linuxtv.org; Sat, 09 Feb 2008 01:28:45 +0100
Message-ID: <47ACF3AF.40201@lsn.se>
Date: Sat, 09 Feb 2008 01:28:31 +0100
From: Per Blomqvist <p.blomqvist@lsn.se>
MIME-Version: 1.0
To: CityK <CityK@rogers.com>
References: <47AB7865.5090008@lsn.se> <47AC7925.8050709@rogers.com>
In-Reply-To: <47AC7925.8050709@rogers.com>
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

The channel isn't encrypted.
(I have tested with many public chanels, that I know isnt encrypted. =

Cant get any video out)

Im Debian-tesing user, and this is a freshly installed system. On a amd64..
(as I mentioned, in previous email)

Turns out "/dev/dvb/adapter0/dvr0" isnt the only device that doesnt work.
(framebuffer didnt work ether, "/dev/fd0" are missing totaly, regardless =

of bootloader vga=3D791 options or so).

I removed (by now mistake) older kernels when I distupgraded, cant =

nerrow down the error search, by testing other linux-kernels.
(since I only have one, the 2.6.22-3-amd64)

And snapshot.debian.net didnt record any older.. Only option left, to =

start compilling by myslef.
(but to rough)

Probably testing another distro (Ubunto) next week.


CityK wrote:
> Per Blomqvist wrote:
>> I just signed up for this mailing-list ( I hope this is the right =

>> forum..   =

>
> Hi, yes, you're in the right place.
>
>> I can "dvbscan" and  "tzap", and gets indication of a good signal. =

>> BUT, I cant view the video!
>> (from the dvb device)
>>
>> Also "dvbdate" command works (that returns time and date from the =

>> air, I presume). But not a command as "dvbsnoop" (that need =

>> "/dev/dvb/adapter0/dvr").
>>
>> A sample: ( Its step by step of your guide:
>> http://www.linuxtv.org/wiki/index.php/Testing_your_DVB_device )
>>
>> In one console I run: /.tzap# tzap -r -c channels.conf "TV4 =D6resund" =

>> ( and are getting lines as:
>> status 1f | signal c3c3 | snr ffff | ber 0000004a | unc 00000000 | =

>> FE_HAS_LOCK
>> status 1f | signal c3c3 | snr ffff | ber 0000004e | unc 00000000 | =

>> FE_HAS_LOCK
>> ...
>> AND in another console:
>> mplayer -v /dev/dvb/adapter0/dvr0
>> (thats basically halts without any further information)
>>
>> ALSO if I type: "cat /dev/dvb/adapter0/dvr0 > afile.txt"
>> (But then again, "afile.txt" remains empty)
>>
>> Conclusion, /dev/dvb/adapter0/dvr0 never returns anything. This =

>> "/dev/dvb/adapter0/dvr" isnt proper. Must be a Linux-kernel/module =

>> problem..
>>   =

>
> Not so fast! If the channel is encrypted, this is precisely what you =

> will observe ... though, because this is over-the-air that we're =

> talking about, this seems less likely to be the case (but you will =

> have to confirm nonetheless).  =

> I'm more inclined to think that this is related to an issue with =

> stream identifiers.  Is Sweden using MP4 now? Some further questions, =

> what drivers are you using (distro or recent LinuxTV)?
> What dvb-apps ... Christophe had updated the dvb-apps not to long ago =

> with some changes in regards to MP4 streams (can't remember the exact =

> nature, but perhaps you should grab a new copy from LinuxTV and try =

> with those).
>
Whatever frontend I test, it will not work.
The device, never stream anything.

I can tune, but not view the video.
(thats it)


-- =

Mvh, *Per **Blomqvist*
Web: http://phoohb.shellkonto.se
Telnr: +46 70-3355632

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
