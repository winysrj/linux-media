Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1EB6xwd026998
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 06:07:00 -0500
Received: from mail-in-02.arcor-online.net (mail-in-02.arcor-online.net
	[151.189.21.42])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1EB6cfQ022750
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 06:06:38 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <47B392A5.2030908@t-online.de>
References: <47B392A5.2030908@t-online.de>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 12:01:53 +0100
Message-Id: <1202986913.5036.3.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	LInux DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Mdeion / Creatix CTX948 DVB-S driver is ready for
	testing
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

Am Donnerstag, den 14.02.2008, 02:00 +0100 schrieb Hartmut Hackmann: 
> Hi, folks
> 
> In my personal repository:
>   http://linuxtv.org/hg/~hhackmann/v4l-dvb-experimental/
> you will find a driver that supports this card, DVB-T and DVB-S
> 
> It might also work for
> - one section of the MD8800
> - similar boards based on saa713x, tda10086, tda826x, isl6405
> 
> The board will show up as MD8800. According to Hermann, the configurations
> for analog TV and DVB-T are identical.
> If you want to use the board with DVB-S, you will need to load the
> saa7134-dvb module with the option "use_frontend=1". The default 0 is
> DVB-T. For those who got the board from a second source: don't forget
> to connect the 12v (the floppy supply) connector.
> 
> I don't have a dish, so i depend on your reports. To get the MD8800
> running, i need a volunteer who does the testing for me. He should be able
> to apply patches, compile the driver and read kernel logs.
> 
> Good luck
>   Hartmut
> 

Hartmut,

great job, thank you very much!

Can't wait, result of a first voltage measurement on the md8800 Quad.

The upper LNB connector associated to the second saa7134 16be:0008
device has correct voltage.

Since my stuff is not in the original green PCI slot and I have only the
first 16be:0007 device active, can't test much more for now here.

People with the card in the original Medion PC could set
"options saa7134-dvb use_frontend=1 debug=1"
in /etc/modprobe.conf and then do "depmod -a".

The Syntek v4l usb stkwebcam still produces a compilation error and
needs to be disabled in "make xconfig" or something else.

After "make" it is best to do "make rmmod" on top of your
v4l-dvb-experimental first. Those new to the v4l-dvb development stuff
might do also "make rminstall" and then check that no *.ko is left
in /lib/modules/kernel_in_use/kernel/drivers/media/*
Especially the old video_buf.ko in the video dir needs to be removed.
Check with "ls -R |grep .ko" and then "make install".

Now I suggest to "modprobe saa7134 card=117,96"
In that case DVB-T is supported on the lower antenna connector and first
adapter and DVB-S on the upper LNB connector and second adapter.

Or to have it simple, it is safe to "make rmmod" and
"modprobe saa7134 card=5,96 tuner=54,54"
This way on the first device is only analog TV enabled, don't forget to
use it first to have good DVB-T reception later anyway, and the only
frontend is the DVB-S one in question for testing.

On the CTX948 voltage is OK

AND

Tuning to: Camera Deputati / autocount: 22
Using DVB device 0:0 "Philips TDA10086 DVB-S"
tuning DVB-S to 11804000 v 27500000
inv:2 fecH:2
DiSEqC: switch pos 0, 13V, hiband (index 2)
DiSEqC: e0 10 38 f1 00 00
. LOCKED.
NOUT: 1
dvbEvents 0:0 started
Tuning delay: 373 ms
pipe opened
xine pipe opened /root/.kaxtv.ts
Asked to stop
pipe closed
Live stopped
dvbstream::run() end
dvbEvents 0:0 ended
fdDvr closed
Frontend closed
Tuning to: Dubai Sports-1 / autocount: 23
Using DVB device 0:0 "Philips TDA10086 DVB-S"
tuning DVB-S to 11747000 h 27500000
inv:2 fecH:3
DiSEqC: switch pos 0, 18V, hiband (index 3)
DiSEqC: e0 10 38 f3 00 00
. LOCKED.
NOUT: 1
dvbEvents 0:0 started
Tuning delay: 374 ms
xine pipe opened /root/.kaxtv1.ts
pipe opened
Asked to stop
pipe closed
Live stopped
dvbstream::run() end
dvbEvents 0:0 ended
fdDvr closed
Frontend closed
Tuning to: ARD "Das Erste" / autocount: 24
Using DVB device 0:0 "Philips TDA10086 DVB-S"
tuning DVB-S to 11604000 h 27500000
inv:2 fecH:5
DiSEqC: switch pos 0, 18V, loband (index 1)
DiSEqC: e0 10 38 f2 00 00
. LOCKED.
NOUT: 1
dvbEvents 0:0 started
Tuning delay: 379 ms
xine pipe opened /root/.kaxtv.ts
pipe opened
Asked to stop
pipe closed
Live stopped
dvbstream::run() end
dvbEvents 0:0 ended
fdDvr closed
Frontend closed
Tuning to: Abu Dhabi Sport / autocount: 25
Using DVB device 0:0 "Philips TDA10086 DVB-S"
tuning DVB-S to 12577000 h 27500000
inv:2 fecH:3
DiSEqC: switch pos 0, 18V, hiband (index 3)
DiSEqC: e0 10 38 f3 00 00
. LOCKED.
NOUT: 1
dvbEvents 0:0 started
Tuning delay: 379 ms
xine pipe opened /root/.kaxtv1.ts
pipe opened
Asked to stop
pipe closed
Live stopped
dvbstream::run() end
dvbEvents 0:0 ended
fdDvr closed
Frontend closed
Tuning to: BBC World / autocount: 26
Using DVB device 0:0 "Philips TDA10086 DVB-S"
tuning DVB-S to 12596000 v 27500000
inv:2 fecH:3
DiSEqC: switch pos 0, 13V, hiband (index 2)
DiSEqC: e0 10 38 f1 00 00
... LOCKED.
NOUT: 1
dvbEvents 0:0 started
Tuning delay: 560 ms
pipe opened
xine pipe opened /root/.kaxtv.ts

 pipe opened
Asked to stop
pipe closed
Live stopped
dvbstream::run() end
dvbEvents 0:0 ended
fdDvr closed
Frontend closed
Tuning to: All Music / autocount: 38
Using DVB device 0:0 "Philips TDA10086 DVB-S"
tuning DVB-S to 10949000 v 27500000
inv:2 fecH:3
DiSEqC: switch pos 0, 13V, loband (index 0)
DiSEqC: e0 10 38 f0 00 00
. LOCKED.
NOUT: 1
dvbEvents 0:0 started
Tuning delay: 378 ms
xine pipe opened /root/.kaxtv.ts
pipe opened
                           
Congratulations!

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
