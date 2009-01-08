Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+6fe81ee853252f17f9b7+1964+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1LKjU7-0005hV-AF
	for linux-dvb@linuxtv.org; Thu, 08 Jan 2009 02:14:55 +0100
Date: Wed, 7 Jan 2009 23:14:18 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Nicola Soranzo <nsoranzo@tiscali.it>
Message-ID: <20090107231418.6210d264@pedra.chehab.org>
In-Reply-To: <200901072031.27852.nsoranzo@tiscali.it>
References: <200901072031.27852.nsoranzo@tiscali.it>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] No audio with Hauppauge WinTV-HVR-900 (R2)
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

On Wed, 7 Jan 2009 20:31:27 +0100
Nicola Soranzo <nsoranzo@tiscali.it> wrote:

> Hi everybody,
> I have a Hauppauge WinTV-HVR-900 (R2) USB stick, model 65018, which has 
> Empiatech Em2880 chip, Xceive XC3028 tuner and Micronas drx397x DVB-T 
> demodulator.
> On the same laptop I have an Intel High Definition Audio soundcard and a Syntek 
> DC-1125 webcam.
> 
> Both analog and DVB-T work under Windows.
> I'm using v4l-dvb from hg repo over Fedora 10 kernel 2.6.27.9 and I have 
> correctly installed xc3028-v27.fw firmware.
> I know that DVB-T chip is not yet supported, so I tried with analog TV.
> I can see analog video, but no audio with any program I used (tvtime, xawtv, 
> MythTV).
> I'm attaching the part of /var/log/messages after the stick attach and the 
> output of the following commands:
> aplay -l
> arecord -l
> cat /proc/asound/cards
> cat /proc/asound/devices
> cat /proc/asound/modules
> cat /proc/asound/pcm
> 
> If any other information may be useful, just ask.
> Thanks in advance for your help,
> Nicola

For you to listen on audio, you need to get the audio from the digital em28xx input and write it on your sound card output. Unfortunately, most programs don't do this. The only one that does is mplayer, if you pass the proper parameters for it. Something like (for PAL-M std):

mplayer -tv driver=v4l2:device=/dev/video0:norm=PAL-M:chanlist=us-bcast:alsa=1:adevice=hw.1:audiorate=48000:forceaudio=1:immediatemode=0:amode=1 tv://

Assuming that em28xx is detected as hw:1 and your audio as hw:0. You can check the wiki for more help about this subject.

Cheers,
Mauro

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
