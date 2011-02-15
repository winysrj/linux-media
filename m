Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx12.extmail.prod.ext.phx2.redhat.com
	[10.5.110.17])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p1F8rnSf002556
	for <video4linux-list@redhat.com>; Tue, 15 Feb 2011 03:53:49 -0500
Received: from web30304.mail.mud.yahoo.com (web30304.mail.mud.yahoo.com
	[209.191.69.66])
	by mx1.redhat.com (8.14.4/8.14.4) with SMTP id p1F8rfQA010624
	for <video4linux-list@redhat.com>; Tue, 15 Feb 2011 03:53:41 -0500
Message-ID: <607153.4126.qm@web30304.mail.mud.yahoo.com>
Date: Tue, 15 Feb 2011 00:53:40 -0800 (PST)
From: AW <arne_woerner@yahoo.com>
Subject: USB TV device / usbaudio / loud hum
To: video4linux-list@redhat.com
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hi!

When I try to use my new USB TV tuner (Pinnacle PCTV USB2 PAL) on Fedora 14 (log 
messages: in the end) 
with this:
mplayer -tv 
driver=v4l2:input=0:width=768:height=576:device=/dev/video2:norm=5:chanlist=europe-west:freq=224.25
 tv://

I hear nothing, but I c good pictures...

When I use this command simultaneously:
parec --device=alsa_input.hw_1 > bla.raw
I get correct audio with strong noise:
http://www.wgboome.de./bla.wav
(it is from input=1 for copyright reasons... so there is silence plus noise)

according to "amixer -c1"
(card 0 is the audio device on the mainboard and
is handled by pulseaudio)
the PCTV audio device has mono audio:
Simple mixer control 'Line',0
  Capabilities: cvolume cvolume-joined cswitch cswitch-joined penum
  Capture channels: Mono
  Limits: Capture 0 - 16
  Mono: Capture 8 [50%] [0.00dB] [on]

but arecord wants "-c2"...

someone on linux media mailing list thinks,
that somehow YUV data might get into the audio stream...

Why is that?

Thx.

Bye
Arne

appendix:
https://bugzilla.redhat.com/show_bug.cgi?id=677290
http://www.spinics.net/lists/linux-media/msg28889.html



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
