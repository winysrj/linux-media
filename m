Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0SLmbEd022586
	for <video4linux-list@redhat.com>; Wed, 28 Jan 2009 16:48:37 -0500
Received: from mail-in-01.arcor-online.net (mail-in-01.arcor-online.net
	[151.189.21.41])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0SLmHwb027564
	for <video4linux-list@redhat.com>; Wed, 28 Jan 2009 16:48:17 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Yves Le Feuvre <yves.lefeuvre@inserm.fr>
In-Reply-To: <497D71BB.4050306@inserm.fr>
References: <497979FF.5090600@inserm.fr>
	<1232755686.5451.7.camel@pc10.localdom.local>
	<497D71BB.4050306@inserm.fr>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 22:48:47 +0100
Message-Id: <1233179327.4396.42.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: asus Europa2 OEM regression ?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

Am Montag, den 26.01.2009, 09:18 +0100 schrieb Yves Le Feuvre:
> Hello,
> 
> [...]
>  > Please try as root "modprobe -vr saa7134-dvb saa7134-alsa"
>  > and "modprobe -v saa7134".
>  >
>  > Is the tda9887 detected now and the card usable again?
> 
> This doesn't change anything. I still have the parity error and the card 
> is unsusable.
> If I remember well (I'll check when I'm back home this evening),
> lsmod  reports that tda9887 is loaded, but used by cx88 or cx88_dvb, and 
> not by any of the saa7134 modules.

it belongs to saa7134[0] and the FMD1216ME MK3 hybrid tuner there.
I don't have your card, but the tda9887 is the analog demodulator and it
has two ports which can be used for switching.

You need it in any case for analog TV from the tuner.
Try "modinfo tda9887". With tda9887 debug=2 it becomes quite verbose.
It was on the older kernels integrated in the tuner module and becomes
there verbose with tuner debug=2.

If it is not present in dmesg after a cold boot, prior to 2.6.27
reloading the tuner module does activate it, since then reloading the
saa7134 driver like above should make it visible and functional.

For your card Hartmut added some special initialization code to make the
tuner visible behind the extra i2c bridge of the tda10046, but it is
detected and only the tda9887 fails for now like on other cards with
that tuner. 

>  > If your hardware is unchanged compared to Fedora 7 and you have some
>  > time for it, you might try to prove if you get the parity errors also on
>  > a vanilla 2.6.27 with the same kernel config.
> 
> on fedora 10, with gcc-4.3.2-7
> with vanilla kernel 2.6.25
> both cards are working: Nova-T DVB-T [card=18], and  Asus Europa2 OEM 
> [card=100]
> 
> with vanilla kernel 2.6.28.1
> Asus Europa2 OEM does not work anymore (parity error)
> 
> (however, there may be some differences in kernel configs, as 
> config-2.6.25 comes from an
> updated fedora 7 kernel config (make oldconfig), and 2.6.28.1 comes rom 
> installed fedora 10 kernel.

That is why I'm late on it, but I now have a vanilla 2.6.28.2 on Fedora
10 with the Fedora config of a recent 2.6.27 x86_64.
No issues for me, but I don't have your card.

> I'll try 2.6.26 and 2.6.27 tonight, with same config as 2.6.25, unless 
> you estimate there are better other things to test before
> I also tested v4l-dvb git tree with vanilla-2.6.28.1, but the card 
> doesn't work either.
> 

According to your latest posting only 2.6.25 works for you and 2.6.26,
2.6.27 and 2.6.28 "fail" including latest git or v4l-dvb from the
mercurial repo at linuxtv.org.

Hmm, does that mean that in all cases the parity errors are that heavy,
that you can't access the device for any tuning of DVB-T, because you
are flooded by errors or are there also tuning issues?

Dmesg looked ok for DVB-T tuning including firmware upload.

Anything changed on "cat /proc/interrupts" ?
Maybe sharing the interrupt with the display driver now?

I don't know what should be going on.
Please try to activate the tda9887.

Most strange is that you can use Composite without problems.
Needs to look closer and/or more debug enabled. No clue yet.

Cheers,
Hermann



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
