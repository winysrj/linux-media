Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1L19G8-0006nT-PO
	for linux-dvb@linuxtv.org; Sat, 15 Nov 2008 01:43:34 +0100
From: Andy Walls <awalls@radix.net>
To: Jon Bishop <jon.the.wise.gdrive@gmail.com>
In-Reply-To: <5314D9F8-88CC-4FD4-9369-B44E5E5C7733@gmail.com>
References: <5314D9F8-88CC-4FD4-9369-B44E5E5C7733@gmail.com>
Date: Fri, 14 Nov 2008 19:44:21 -0500
Message-Id: <1226709861.3107.22.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Tuning Problems
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

On Fri, 2008-11-14 at 12:47 -0800, Jon Bishop wrote:
> I'm having trouble with a pvr150 card that I just added to my system.  
> I don't know if I should post it here, or what, but I've been using  
> the dvb drivers for months with no problems, so I figured it's a good  
> place to start.

For devices supported by the ivtv driver, such as a PVR-150, you can
also try the wiki at

http://www.ivtvdriver.org/

and the ivtv-users list mentioned at that site.


> My system is opensuse 10.3 with kernel 2.6.24.3 compiled by me. I just  
> downloaded the latest v4l sources a half hour ago and compiled and  
> installed those. Everything appears to be working on my pinnacle PCTV  
> 800i cards. The hauppage appears to be detected right, but it's not  
> working properly.

What does 

$ v4l2-ctl -d /dev/video0 --log-status

report?



>  When I attempt to use tvtime I can connect to the  
> analogue side of the pinnacle cards at /dev/video1 and /dev/video2,  
> but I can't open /dev/video0, which is my hauppage.

I'm not a tvtime user, but I would guess that it can't decode an MPEG2
PS which is the default stream type output on /dev/video0 for the
PVR-150.

You can do

$ mplayer /dev/video0

which should work or

$ cat /dev/video0 > foo.mpg

to create an MPEG2 PS file to playback with an app that can handle an
MPEG2 PS.



>  When using mythtv,  
> it connects, and tunes, and reports no issues, but it only seems to  
> tune channels 3-13. I have connected the coax to the tv set, and can  
> tune most of 3-70, but myth just shows snow for channels 14 and up.

This sounds like maybe you might have the wrong channel-freq table set
up in MythTV: us-cable vs us-bcast (your card has an NTSC(M) tuner so
I'm assuming US freqs).

Again, just to take MythTV out of the loop to have some fine grain
control over the steps:

$ ivtv-tune -L
Frequency Maps:
us-bcast
us-cable
us-cable-hrc
us-cable-irc
japan-bcast
....

$ ivtv-tune -d /dev/video0 -t us-bcast -c 20
(just an example)

$ v4l2-ctl -d /dev/video0 --log-status
(look for the right freq and video signal present status)

$ mplayer /dev/video0


>  My  
> pinnacle cards are hooked up to rabbit ears, and tune ATSC just fine.  
> Anybody know what I'm doing wrong?

Tuning to channels 14 and above requires a UHF antenna element for OTA
signals in the US. US NTSC channels 2-4 & 5-6 are low VHF and 7-13 are
high VHF, and they all use the same set of freq's for cable and OTA in
the US.  The difference in OTA vs Cable channel-frequency tables starts
at channel 14.

Regards,
Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
