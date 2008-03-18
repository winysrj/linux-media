Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f9.mail.ru ([194.67.57.39])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JbUh3-0006iW-RR
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 06:49:22 +0100
From: Igor <goga777@bk.ru>
To: Claes Lindblom <claesl@gmail.com>
Mime-Version: 1.0
Date: Tue, 18 Mar 2008 08:48:27 +0300
In-Reply-To: <47DEDA99.8060703@gmail.com>
References: <47DEDA99.8060703@gmail.com>
Message-Id: <E1JbUgV-000A7p-00.goga777-bk-ru@f9.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?QXp1cmVXYXZlIFZQIDEwNDEgRFZCLVMyIHByb2Js?=
	=?koi8-r?b?ZW0=?=
Reply-To: Igor <goga777@bk.ru>
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

> > try please 
> > dvbsnoop -s ts -b -tsraw > YOUR.file.name
> >
> >   
> Ok, now I have tested dvbsnoop -s -ts -tsraw > svt_hd.ts
> and got the following output from mplayer.
> 
> TS file format detected.
> VIDEO MPEG2(pid=512) AUDIO A52(pid=641) NO SUBS (yet)!  PROGRAM N. 0
> TS_PARSE: COULDN'T SYNC
> MPEG: FATAL: EOF while searching for sequence header.
> Video: Cannot read properties.
> ==========================================================================
> Opening audio decoder: [liba52] AC3 decoding with liba52
> Using SSE optimized IMDCT transform
> Using MMX optimized resampler
> AUDIO: 48000 Hz, 2 ch, s16le, 640.0 kbit/41.67% (ratio: 80000->192000)
> Selected audio codec: [a52] afm: liba52 (AC3-liba52)
> ==========================================================================
> AO: [oss] 48000Hz 2ch s16le (2 bytes per sample)
> Video: no video
> Starting playback...
> A:69923.4 (19:25:23.4) of 198.0 (03:18.0)  0.7%
> 
> Exiting... (End of file)
> 
> The file is about 16MB and audio seems to be working but it detects 
> video as MPEG2 for some reason.


How long (seconds, minutes...) this file ? 
please, update your MPlayer - take the svn version.
and finally please try to use dvbstream

./dvbstream -o 8192 > your.file

Igor


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
