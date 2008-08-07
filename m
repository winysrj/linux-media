Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt2.poste.it ([62.241.5.253])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1KR5Fu-0007ko-Nk
	for linux-dvb@linuxtv.org; Thu, 07 Aug 2008 15:10:16 +0200
Received: from nico2.od.loc (89.97.249.170) by relay-pt2.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 489A2D39000057DB for linux-dvb@linuxtv.org;
	Thu, 7 Aug 2008 15:10:10 +0200
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Thu, 7 Aug 2008 15:11:34 +0200
References: <227547.48274.qm@web36101.mail.mud.yahoo.com>
In-Reply-To: <227547.48274.qm@web36101.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808071511.34548.Nicola.Sabbi@poste.it>
Subject: Re: [linux-dvb] help with dvbstream network streaming
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

On Thursday 07 August 2008 14:51:46 Jody Gugelhupf wrote:
> Hi people,
>
> I have a dvb-s card, I got it working finally in ubuntu :) (more
> information about my hardware at the end of the mail, in case it is
> needed). I have been looking around for a good dvbstream tutorial,
> but haven't really found one, also the man page does not seem to be
> complete. I would like to stream from my some the machine with the
> dvb-s card to clients in the network and maybe also on the
> internet.
>
> I don't get how to specify the command I have tried several things,
> e.g.: dvbstream -f 11567 -p v -s 22000 -D 0 -i 192.168.2.23 -r 1237
>
> -f is the frequency in what? hz, mhz, ghz??

Mhz (it's a bit more tolerant than that, but always yse Mhz)

> -p polarization, ok that's clear either horizontal or vertical
> -s symbolrate also not clear on that,

Ksym/sec

> -D inidcated which LNB to use, no problem here

-D 0 means nothing: 1..4 or A or B

> -i to what ip to send the stream?
> -r the port on to send the stream

use -net ip:port instead

>
> and what about 22khz tone how can i specify in dvbstream to turn it
> on or off

it's generated according to diseqc, frequency and polarization

>
> Here what I get when I execute the command above:
>
> dvbstream -f 11567 -p v -s 22000 -D 0


and what pids or programs?

> dvbstream v0.6 - (C) Dave Chapman 2001-2004

old, use an fresh cvs checkout

> Why isn't it able to lock to the signal? I can watch the station on
> kaffeine or mplayer or xine...

you didn't tell dvbstream what to do

>
> I also don't understand the channels.conf file syntax completly, if
> someon could explain that as well, e.g.:
>
> ARTE:11567:v:1:22000:167:136:9019     (same as the dvbstream
> command above)
>
> channelname:frequency:polarization:???:symbolrate:???:???:????
>
> I guess one is for the audio pid and one for video pid, but which
> ones and what about the other 2 remaining entries?

frequency:polarization:sat_position(diseqc):video_pid:audio_pid:service_id

>
> Also can I stream just one channel or more at the same time?

as many as you stream, see at the bottom

>
> And I was wondering about my CI module, it is connected to the
> dvb-s card, can I check somehow that it is recognized and working?
> I don't have yet a cam or card...

there's no support for decryption in dvbstream

>
> OK that's it would be happy about some help or pointers to some
> tutorials or something, thx in advance,
>
> from here on it's just hardware info about my machine...
> thx jody :)
>
>


example:
dvbstream -f 11800 -p V -s 22500 -udp -net 224.0.0.1:5000 0 512 
650 -prog -net 224.0.0.1:5001 TV1 TV2 -net 192.168.0.11:3000 TV1 TV3 

and so on. In short, you can select the streams to transmit by name or
by pid and mix them as you want, eventually repeated

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
