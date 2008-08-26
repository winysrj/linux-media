Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n76.bullet.mail.sp1.yahoo.com ([98.136.44.48])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KXxGR-0007nc-5M
	for linux-dvb@linuxtv.org; Tue, 26 Aug 2008 14:03:13 +0200
Date: Tue, 26 Aug 2008 05:00:18 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <1219733348.3846.8.camel@suse.site>
MIME-Version: 1.0
Message-ID: <709924.7684.qm@web46108.mail.sp1.yahoo.com>
Subject: Re: [linux-dvb] How to convert MPEG-TS to MPEG-PS on the fly?
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

--- On Tue, 8/26/08, Nico Sabbi <nicola.sabbi@poste.it> wrote:

> dvb-mpegtools, like mplex, demuxes the TS and loses all informations
> about timestamps => very likely the output will be out of sync.

I wondered about this, as I had used `something' to convert a
TS to a file that I could play on a standalone DVD-player with
card/USB slots.

It turns out I used `replex'; unfortunately, the source material
wasn't something for which timestamps were too critical -- stop-
motion animation from Nick Park/Aardman Animations, broadcast
with a typical fraction of a second offset betweem audio and
video PTSen in real-time:

-rwxr-xr-x 1 root root 188704772 2007-05-25 16:34 /selinux/misc/Shaun_the_Sheep-Shape_Up_With_Shaun-replex-mpeg2.mpg
-rwxr-xr-x 1 root root 193982464 2007-05-25 17:11 /selinux/misc/Shaun_the_Sheep-Bathtime-replex-dvd.mpg

In these files, I no longer see any useable timestamps (those I
do see start around 0 and work up), and as noted, if there were
to be loss of sync, I'd be unlikely to notice with this source.


For laughs, I now converted a short BBC-Four TS I had recorded as
a test with `ts2ps', and there, the PTS/DTS are present in the PS
and match those seen in the TS...

     ==> system_clock_reference_base: 859961626 (0x3341f91a)  [= 90 kHz-Timestamp: 2:39:15.1291]
         ==> PTS: 5154932522 (0x13342072a)  [= 90 kHz-Timestamp: 15:54:37.0280]
         ==> DTS: 5154921721 (0x13341dcf9)  [= 90 kHz-Timestamp: 15:54:36.9080]
         ==> PTS: 5154925321 (0x13341eb09)  [= 90 kHz-Timestamp: 15:54:36.9480]
         ==> PTS: 5154928921 (0x13341f919)  [= 90 kHz-Timestamp: 15:54:36.9880]
     ==> system_clock_reference_base: 859937348 (0x33419a44)  [= 90 kHz-Timestamp: 2:39:14.8594]
         ==> PTS: 5154908244 (0x13341a854)  [= 90 kHz-Timestamp: 15:54:36.7582]
         ==> PTS: 5154943322 (0x13342315a)  [= 90 kHz-Timestamp: 15:54:37.1480]
         ==> DTS: 5154932521 (0x133420729)  [= 90 kHz-Timestamp: 15:54:37.0280]
         ==> PTS: 5154936121 (0x133421539)  [= 90 kHz-Timestamp: 15:54:37.0680]
         ==> PTS: 5154939721 (0x133422349)  [= 90 kHz-Timestamp: 15:54:37.1080]
         ==> PTS: 5154954122 (0x133425b8a)  [= 90 kHz-Timestamp: 15:54:37.2680]

If I had lots of time to kill, I'd separate the audio stream PTSen
from the video (they have a couple tenths-of-second offset relative
to each other)...


barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
