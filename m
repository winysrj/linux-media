Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB2NJnbN013970
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 18:19:49 -0500
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net
	[151.189.21.50])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB2NJUMO013564
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 18:19:31 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Tanguy Pruvot <tanguy.pruvot@gmail.com>
In-Reply-To: <116652354.20081202092655@gmail.com>
References: <116652354.20081202092655@gmail.com>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 00:15:27 +0100
Message-Id: <1228259727.2588.67.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [TUA6030] Infineon TUA6030 driver available... =)
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

Hello!

Am Dienstag, den 02.12.2008, 09:26 +0100 schrieb Tanguy Pruvot:
> Hi,
> 
>    You can find the configuration needed for this multi tuner on this page :
> 
>    This tuner can do everything analog (PAL (including SECAM)/ NTSC / FM))
> 
>       http://tanguy.ath.cx/index.php?q=SAA7130
> 
> 
>    Full PC-Basic SAA7130/TUA6030 card driver will follow soon (Graphics)
>    when IR remote control will be configured correctly... GPIOs
> 
> 
>    Hope this code could be included in v4l kernel sources !
>    Cheers
> 

These tuners have been seen at first on Hauppauge products as
replacement for the Philips FM1216ME/I H-3 (MK-3) and a member of the
video4linux-list in the UK had confirmation from Hauppauge's user
support there, that they are compatible with the prior tuner=38.

This was for a MFPE05-2. (PE = PAL/Europe)
http://tuner.tcl.com/English/html/enewsproopen.asp?proname=107&url=product
I think a MFPE05-3-E was reported on some device too.

Since then this tuner is mapped to tuner=38 in media/video/tveeprom.c
and is on several Hauppauge devices, but also on others. No complaints
so far.

The layout of the tuner PCB of your MFPE05-2-E and the FM1216ME MK3
seems to be identical. The most visible difference is, that the on your
tuner just unused tuner pins 7 and 8 are not present at the Philips at
all. Means 12 against 14 visible tuner pins according to your
photograph.

Else only the color of some of the coils differs and instead of TUA 6032
marked on the pll chip, on the pll used by Philips is only printed B2
and 230, but both have 38pins connected to the obviously same layout.

You might even have the same original EPCOS SAW filters, but your tuner
will not support NTSC, needs different filter equipment.
NTSC is covered by the MFNM05. (NM = NTSC N/M)
http://tuner.tcl.com/English/html/enewsproopen.asp?proname=108&url=product
This also causes the different bandswitch takeover frequencies.

On a first look at the main programming table all write and read bytes
are identical up to every single bit. You can find the datasheet of the
Philips FM1216ME MK3 we have these days at ivtvdriver.org.
http://dl.ivtvdriver.org/datasheets/tuners

If we find details not covered by tuner=38, you can get a new tuner
entry, but the patch must be against recent v4l-dvb. The radio should be
treated like on the other MK3 tuners in tuner-simple.c I guess.
IIRC, we have reports for radio working well with port1=1, inactive, FM
high sensitivity.

We would need a valid signed-off-by line from you as well.

Thanks, especially for the picture of the opened tuner. We did not have
any further details previously. Just testing results and the Hauppauge
hint. 

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
