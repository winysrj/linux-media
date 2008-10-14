Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1Kpjeu-00057P-Am
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 15:09:59 +0200
Received: by ey-out-2122.google.com with SMTP id 25so758040eya.17
	for <linux-dvb@linuxtv.org>; Tue, 14 Oct 2008 06:09:52 -0700 (PDT)
Message-ID: <412bdbff0810140609n27da7d62xa7fd453005fb4b8f@mail.gmail.com>
Date: Tue, 14 Oct 2008 09:09:52 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Paul Guzowski" <guzowskip@linuxmail.org>
In-Reply-To: <20081014115855.1E8D37BD4F@ws5-10.us4.outblaze.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20081014115855.1E8D37BD4F@ws5-10.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Ubuntu 8.10 and Pinnacle HDTV Pro usb stick
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

On Tue, Oct 14, 2008 at 7:58 AM, Paul Guzowski <guzowskip@linuxmail.org> wrote:
> Greetings,
>
> I'm trying to use a Pinnacle HDTV Pro USB stick to take an RF-out (US channel 3) from my cable company's set-top box to allow me to watch TV in a window on my computer which is running Ubuntu Linux.  I found several ways to get video but was missing audio then finally found a way to get both with MPlayer using the following command:
>
> mplayer -vo xv tv:// -tv driver=v4l2:alsa:immediatemode=0:adevice=hw.1,0:norm=ntsc:chanlist=us-cable
>
> I was running Ubuntu 8.04 (Hardy Heron) then I upgraded to the Beta for Ubuntu 8.10.  MPlayer TV with video and sound worked for a while but, as with all Beta releases, the updates were coming hot and heavy and now I'm right back where I started with video and no audio. Now when I run that command, I get the following error messages regarding audio:
>
> v4l2: current audio mode is : MONO
> ALSA lib pcm_hw.c:1429:(_snd_pcm_hw_open) Invalid value for card
> Error opening audio: No such file or directory
> ALSA lib pcm_hw.c:1429:(_snd_pcm_hw_open) Invalid value for card
> Error opening audio: No such file or directory
> ALSA lib pcm_hw.c:1429:(_snd_pcm_hw_open) Invalid value for card
> Error opening audio: No such file or directory
> v4l2: 0 frames successfully processed, 0 frames dropped.
>
> Results of cat /proc/asound/cards:
>
> paul@Kris-desktop:~/Desktop$ cat /proc/asound/cards
> 0 [SI7012 ]: ICH - SiS SI7012
> SiS SI7012 with YMF753 at irq 18
> 1 [Em28xx Audio ]: Empia Em28xx AudEm28xx Audio - Em28xx Audio
> Empia Em28xx Audio
>
> Can anyone give me any idea why this was working and has now stopped or what I need to do to get audio back? I'm not tied to MPlayer so TvTime should work OK but the base Ubuntu package has no sound and I cannot get the source to compile on my system. I'm open to any/all suggestions and am willing to try any other software packages. Thanks in advance.
>
> Polo
>
>
> =
> The New Yorker Online
> An Intelligent Approach to the Business Report. Read Now.
> http://a8-asy.a8ww.net/a8-ads/adftrclick?redirectid=072b6a986f0b98b481fa5f50993a47ad
>
>
> --
> Powered by Outblaze
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

Hello Paul,

Is this the 800e or the 801e version of the Pinnacle PCTV HD Pro?

You're using http://linuxtv.org/hg/v4l-dvb, right?

If so, do a fresh checkout and rebuild.

Unbuntu ships its own version of em28xx, and when they update the
modules it can cause the to get out of sync with the sources you
compiled.  Doing a fresh checkout ensures that you're building against
the right version of the linux kernel headers.

Cheers,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
