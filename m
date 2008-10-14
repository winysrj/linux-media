Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <guzowskip@linuxmail.org>) id 1KpiYJ-0000YF-F0
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 13:59:06 +0200
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	2E950180013C
	for <linux-dvb@linuxtv.org>; Tue, 14 Oct 2008 11:58:55 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: "Paul Guzowski" <guzowskip@linuxmail.org>
To: linux-dvb@linuxtv.org
Date: Tue, 14 Oct 2008 05:58:55 -0600
Message-Id: <20081014115855.1E8D37BD4F@ws5-10.us4.outblaze.com>
Subject: [linux-dvb] Ubuntu 8.10 and Pinnacle HDTV Pro usb stick
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Greetings,

I'm trying to use a Pinnacle HDTV Pro USB stick to take an RF-out (US chann=
el 3) from my cable company's set-top box to allow me to watch TV in a wind=
ow on my computer which is running Ubuntu Linux.  I found several ways to g=
et video but was missing audio then finally found a way to get both with MP=
layer using the following command:

mplayer -vo xv tv:// -tv driver=3Dv4l2:alsa:immediatemode=3D0:adevice=3Dhw.=
1,0:norm=3Dntsc:chanlist=3Dus-cable

I was running Ubuntu 8.04 (Hardy Heron) then I upgraded to the Beta for Ubu=
ntu 8.10.  MPlayer TV with video and sound worked for a while but, as with =
all Beta releases, the updates were coming hot and heavy and now I=92m righ=
t back where I started with video and no audio. Now when I run that command=
, I get the following error messages regarding audio:

v4l2: current audio mode is : MONO
ALSA lib pcm_hw.c:1429:(_snd_pcm_hw_open) Invalid value for card
Error opening audio: No such file or directory
ALSA lib pcm_hw.c:1429:(_snd_pcm_hw_open) Invalid value for card
Error opening audio: No such file or directory
ALSA lib pcm_hw.c:1429:(_snd_pcm_hw_open) Invalid value for card
Error opening audio: No such file or directory
v4l2: 0 frames successfully processed, 0 frames dropped.

Results of cat /proc/asound/cards:

paul@Kris-desktop:~/Desktop$ cat /proc/asound/cards
0 [SI7012 ]: ICH - SiS SI7012
SiS SI7012 with YMF753 at irq 18
1 [Em28xx Audio ]: Empia Em28xx AudEm28xx Audio - Em28xx Audio
Empia Em28xx Audio

Can anyone give me any idea why this was working and has now stopped or wha=
t I need to do to get audio back? I'm not tied to MPlayer so TvTime should =
work OK but the base Ubuntu package has no sound and I cannot get the sourc=
e to compile on my system. I'm open to any/all suggestions and am willing t=
o try any other software packages. Thanks in advance.

Polo


=3D
The New Yorker Online
An Intelligent Approach to the Business Report. Read Now.
http://a8-asy.a8ww.net/a8-ads/adftrclick?redirectid=3D072b6a986f0b98b481fa5=
f50993a47ad


-- =

Powered by Outblaze

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
