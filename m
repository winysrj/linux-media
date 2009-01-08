Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <redtux1@googlemail.com>) id 1LKjgW-0006gv-7b
	for linux-dvb@linuxtv.org; Thu, 08 Jan 2009 02:27:47 +0100
Received: by bwz11 with SMTP id 11so18972605bwz.17
	for <linux-dvb@linuxtv.org>; Wed, 07 Jan 2009 17:27:10 -0800 (PST)
Message-ID: <ecc841d80901071727g7330dfecw14f7ef1943d2221e@mail.gmail.com>
Date: Thu, 8 Jan 2009 01:27:10 +0000
From: "Mike Martin" <redtux1@googlemail.com>
To: "Nicola Soranzo" <nsoranzo@tiscali.it>
In-Reply-To: <200901072031.27852.nsoranzo@tiscali.it>
MIME-Version: 1.0
Content-Disposition: inline
References: <200901072031.27852.nsoranzo@tiscali.it>
Cc: linux-dvb@linuxtv.org
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

On 07/01/2009, Nicola Soranzo <nsoranzo@tiscali.it> wrote:
> Hi everybody,
> I have a Hauppauge WinTV-HVR-900 (R2) USB stick, model 65018, which has
> Empiatech Em2880 chip, Xceive XC3028 tuner and Micronas drx397x DVB-T
> demodulator.
> On the same laptop I have an Intel High Definition Audio soundcard and a
> Syntek
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
>


you need a different driver Markuses em2880_new from here

http://mcentral.de/hg/~mrec/em28xx-new

mailing list

http://mcentral.de/mailman/listinfo/em28xx

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
