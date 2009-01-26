Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0Q8Ksg8020036
	for <video4linux-list@redhat.com>; Mon, 26 Jan 2009 03:20:54 -0500
Received: from aneto.bordeaux.inserm.fr (aneto.bordeaux.inserm.fr
	[195.221.150.9])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0Q8KZvt006282
	for <video4linux-list@redhat.com>; Mon, 26 Jan 2009 03:20:36 -0500
Message-ID: <497D71BB.4050306@inserm.fr>
Date: Mon, 26 Jan 2009 09:18:03 +0100
From: Yves Le Feuvre <yves.lefeuvre@inserm.fr>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <497979FF.5090600@inserm.fr>
	<1232755686.5451.7.camel@pc10.localdom.local>
In-Reply-To: <1232755686.5451.7.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Hello,

[...]
 > Please try as root "modprobe -vr saa7134-dvb saa7134-alsa"
 > and "modprobe -v saa7134".
 >
 > Is the tda9887 detected now and the card usable again?

This doesn't change anything. I still have the parity error and the card 
is unsusable.
If I remember well (I'll check when I'm back home this evening),
lsmod  reports that tda9887 is loaded, but used by cx88 or cx88_dvb, and 
not by any of the saa7134 modules.


 > If your hardware is unchanged compared to Fedora 7 and you have some
 > time for it, you might try to prove if you get the parity errors also on
 > a vanilla 2.6.27 with the same kernel config.

on fedora 10, with gcc-4.3.2-7
with vanilla kernel 2.6.25
both cards are working: Nova-T DVB-T [card=18], and  Asus Europa2 OEM 
[card=100]

with vanilla kernel 2.6.28.1
Asus Europa2 OEM does not work anymore (parity error)

(however, there may be some differences in kernel configs, as 
config-2.6.25 comes from an
updated fedora 7 kernel config (make oldconfig), and 2.6.28.1 comes rom 
installed fedora 10 kernel.

I'll try 2.6.26 and 2.6.27 tonight, with same config as 2.6.25, unless 
you estimate there are better other things to test before
I also tested v4l-dvb git tree with vanilla-2.6.28.1, but the card 
doesn't work either.

Yves

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
