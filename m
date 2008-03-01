Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.nielsen@shikadi.net>) id 1JVLGT-00058Y-GC
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 07:32:09 +0100
Received: from berkeloid.vlook.shikadi.net ([192.168.4.11])
	by vitalin.sorra.shikadi.net with esmtp (Exim 4.62)
	(envelope-from <a.nielsen@shikadi.net>) id 1JVLGN-0003uf-7D
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 16:32:03 +1000
Received: from korath.teln.shikadi.net ([192.168.0.14])
	by berkeloid.teln.shikadi.net with esmtp (Exim 4.62)
	(envelope-from <a.nielsen@shikadi.net>) id 1JVLGK-00026k-4O
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 16:32:00 +1000
Message-ID: <47C8F860.70604@shikadi.net>
Date: Sat, 01 Mar 2008 16:32:00 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <47BFD5F4.3030805@shikadi.net>	<7543B999-C26B-46A9-929D-C5CA625A131A@pobox.com>
	<47C005D6.10202@shikadi.net>
In-Reply-To: <47C005D6.10202@shikadi.net>
Subject: Re: [linux-dvb] Is there a daemon style program for scheduled DVB
 recording?
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

Hi again,

Thanks for all the replies!  I've checked out a few programs and decided
to use dvbstream as Tim Hewett suggested.

>> Obviously, you seem to have never actually tried VDR. It's
>> extremely lean and clean and it don't need to run with any output.
>> You can telnet into it and schedule recordings and it's easy to
>> view recordings over NFS, or use a streaming media client directly
>> towards VDR with a suitable streaming plugin.

I installed VDR after reading your message but that's about as far as I
got.  I couldn't work out how to do a scan to pick up all the channels,
and I may have been willing to create a channel config file manually
except that there were a number of other issues.  For a start, the
telnet syntax was rather cumbersome - crontabs may be just as bad but at
least you can copy and paste :-)

Also I couldn't see where you control the name of the files that VDR
outputs - I want a single file for each show (>4GB if need be) with the
name of the show and the time it was recorded, but I don't think VDR can
do that.

Don't get me wrong, I'm not complaining about VDR, I just think that
it's not suitable for the very specific purpose I'm after.

I do appreciate the suggestion though!

> Tim Hewett wrote:
> I just use dvbstream, scheduled using cron. To work with that I wrote
>  a utility to work out which is the next schedule in the crontab and 
> set the hardware alarm clock time to have the computer boot a few 
> minutes in advance of the recording time, run it just before shutting
>  down (it shuts it down for you) and the PC then wakes at the right
> time. I also modified dvbstream to allow the DVB device name to be
> used instead of its adaptor number, to cater for the devices changing
> numbers between bootups. Some initial changes were made to dvbstream
> to specify a programme name to be monitored in the now/next programme
> info, to try to cater for early programme starts or overruns, but I
> can't say that it is reliable as it hasn't been used much.

Wow, that seems quite elaborate!  Luckily my set up is a server that
runs 24/7 anyway, so I don't need to worry about any power scheduling.
Plus here in Australia most of our TV stations don't run to the times
listed in the now/next info anyway (to influence ratings or some such)
so I have to resort to the low-tech method of starting early and
finishing late.

I've experimented with dvbstream and now that it can work with Program
IDs instead of bare PIDs I think it will do the job nicely.

Again, thanks for the suggestions!

Cheers,
Adam.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
