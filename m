Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n68.bullet.mail.sp1.yahoo.com ([98.136.44.44])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KWT5C-0001ga-4B
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 11:37:27 +0200
Date: Fri, 22 Aug 2008 02:36:49 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org, Kristo Czaja <kc0@wp.pl>
In-Reply-To: <48AE7777.3050106@wp.pl>
MIME-Version: 1.0
Message-ID: <297718.19837.qm@web46115.mail.sp1.yahoo.com>
Subject: Re: [linux-dvb] DVB-T DiBcom STK7070P: no video
Reply-To: free_beer_for_all@yahoo.com
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

--- On Fri, 8/22/08, Kristo Czaja <kc0@wp.pl> wrote:

> dvbscan pl-Warsaw:
> TVP1:690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:104:1
> TVP2:690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:204:2

Google shows me that apparently the DVB-T signal is using the
H.264 video codec, plus AC3 audio.  Apparently you're getting
an mp2 audio stream on PID 204 for TVP2, but your `dvbscan'
is failing to recognize the video stream as AVC and it shows
up above as `0'.


> Odtwarzam /dev/dvb/adapter0/dvr0.
> Wykryto format pliku TS.
> VIDEO MPEG2(pid=102) AUDIO A52(pid=103) NO SUBS (yet)! 

In the absence of the PID which includes the info about the
H.264 AVC video stream, `mplayer' defaults to the incorrect
MPEG2 video.  I have a hack which can override this (needed
for, say, ITV-HD at 28E, or other AVC streams recorded without
all the needed PIDs) but you would be better off to use the
correct PID for that service.


> /usr/bin/dvbtraffic:
> 0066  1857 p/s   340 kb/s  2793 kbit
PID 102 decimal, AVC video
> 0067   306 p/s    56 kb/s   460 kbit
PID 103, AC3 audio
> 0068   109 p/s    20 kb/s   164 kbit
I'll guess an alternate mp2 audio seen above as PID 104

You'll either need to write a stream with PIDs 0, as well as
the PID for Service ID 2 (TVP2), which mplayer can parse and
detect the video as AVC, or, well, um, somehow mplayer needs
to be able to read PIDs 0 plus that for service ID 2 (or any
other service you wish to see).  No personal experience there
as none of my machines can come close to realtime playback, so
I always write to a file...


barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
