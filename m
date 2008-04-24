Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anluoma@gmail.com>) id 1Jp39L-0008HF-OD
	for linux-dvb@linuxtv.org; Thu, 24 Apr 2008 17:14:22 +0200
Received: by rn-out-0910.google.com with SMTP id i6so1377648rng.2
	for <linux-dvb@linuxtv.org>; Thu, 24 Apr 2008 08:14:01 -0700 (PDT)
Message-ID: <754a11be0804240813k36301454nb92097727190ea0@mail.gmail.com>
Date: Thu, 24 Apr 2008 18:13:53 +0300
From: "Antti Luoma" <anluoma@gmail.com>
To: "Bert Haverkamp" <bert@bertenselena.net>, linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1e68a10b0804230739x2789db28s95ed5aeefe640374@mail.gmail.com>
MIME-Version: 1.0
References: <754a11be0803171553p63ac231aicbaeaee4c91b2a2d@mail.gmail.com>
	<754a11be0803181023p42945cf7ka3acc99975aa638c@mail.gmail.com>
	<ea4209750803181030ge4fb4c3o6fd885d57744d9e0@mail.gmail.com>
	<754a11be0803181052i6b80ece7o81921dcf142db4e@mail.gmail.com>
	<ea4209750803181053n19acbb1eg7d0528486ee03cc6@mail.gmail.com>
	<754a11be0803181058r1864c075y60f976c692169a3b@mail.gmail.com>
	<754a11be0803191408j7e6b40e0nc9242604f64622a3@mail.gmail.com>
	<ea4209750803191655xfadfb03vc9323b6f45cbef1f@mail.gmail.com>
	<754a11be0803311247n6921217agfa0d9ada055b76a6@mail.gmail.com>
	<1e68a10b0804230739x2789db28s95ed5aeefe640374@mail.gmail.com>
Subject: Re: [linux-dvb] TNT Pinnacle PCTV DVB-T 72e
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0764829434=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0764829434==
Content-Type: multipart/alternative;
	boundary="----=_Part_1256_32466013.1209050033674"

------=_Part_1256_32466013.1209050033674
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Well I think it working but I'm having some issues with my mainboards
integrated graphics card (amd 690g / radeon x1250). First when I got it
working with 2.6.25 kernel I didn't managed to compile drivers for the for
radeon. Then I waited a while for ubuntu guys to fix the problem from kernel
2.6.24 ( so that radeon drivers worked) -> Finally after that I managed to
view the tv first time and the picture quality was ok (I really dont know
what to compare on)... BUT there is some strange problem because if tune to
a some channel it only show some different colors for a second and after
that X or whole computer crashes (And only on some channels, some work ok,
this is something that I could not understant..)! This happened few times
and with my  poor luck it jammed my box so badly that it trashed my whole
ext3 filesystem..

After that I tried with different release (Fedora 8) and same thing
continues. I also have been quite busy with other stuff and been waiting for
a Hardy Hardon release day so that I can make clean install and try with
that, I also borrowed GeForce display card to try with. I'm now downloading
hardy so mayby I can try this at weekend and also I noticed that amd
released new version from their drivers.

But what comes to 72e stick I think it is NOW easy to install because
v4l-dvb provides drivers that work with it ok (you need to get them from
mercurial and compile, but nothing really amazing..).


-Antti-

2008/4/23 Bert Haverkamp <bert@bertenselena.net>:

> Hello Antii,
>
> How is the 72e working now? I am thinking of buying it. The local
> store has a special offer on it. Is it any good under linux?
>
> Regards,
>
> Bert
>
> 2008/3/31, Antti Luoma <anluoma@gmail.com>:
> > Hi,
> >
> > This was a linux kernel issue, same issue that many others have faced...
> I
> > compiled 2.6.25-rc7 from kernel.org and now it seem to scan channels!
> >
> >
> >
> > 2008/3/20, Albert Comerma <albert.comerma@gmail.com>:
> > > Perhaps try an other computer?
> > >
> > >
> > > 2008/3/19, Antti Luoma <anluoma@gmail.com>:
> > >
> > > > Hi again,
> > > >
> > > > I borrowed Targus 7-port powered usb hub from work today and tried
> it.
> > At first it hang when I issued the scan -> had to reboot (usb was gone).
> > > >
> > > > After that same usb error keeps bothering me and I can't get nothing
> out
> > of the tuner.
> > > >
> > > > 84.977573] dvb_frontend_add_event
> > > > [   84.977663] dvb_frontend_swzigzag_autotune: drift:0 inversion:0
> > auto_step:0 auto_sub_step:0 started_auto_step:0
> > > > [   85.057760] dvb_frontend_ioctl
> > > > [   85.399118] hub 6-3:1.0: port 3 disabled by hub (EMI?),
> > re-enabling...
> > > > [   85.399171] usb 6-3.3: USB disconnect, address 4
> > > > [   85.399436] dvb_unregister_frontend
> > > > [   85.399438] dvb_frontend_stop
> > > > [   91.622120] dvb-usb: error while stopping stream.
> > > >
> > > > I think it disconnects the usb after the tuner finds correct
> > signal/stream because it doesn't reset the usb if it didn't find any
> > channels..
> > > >
> > > > Anyone has more ideas to try? (they are starting to be very welcome)
> > > >
> > > >
> > > > -antti-
> > > >
> > > >
> > > >
> > > > 2008/3/18, Antti Luoma <anluoma@gmail.com>:
> > > > > I have get one from somewhere (hmm, maybe at work tomorrow)..
> > > > >
> > > > > btw I'm not alone it seemm , See
> > http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29988.html
> > > > >
> > > > >
> > > > >
> > > > > -Antti-
> > > > >
> > > > >
> > > > > 2008/3/18, Albert Comerma <albert.comerma@gmail.com>:
> > > > > > Yes I think so... try a hub if you have one near...
> > > > > >
> > > > > >
> > > > > >
> > > > > > 2008/3/18, Antti Luoma <anluoma@gmail.com>:
> > > > > > > Hmm dmesg says:
> > > > > > >
> > > > > > > [15046.955374] <<< 14 07
> > > > > > > [15046.955380] >>> 03 80 00 17 01 38
> > > > > > > [15046.955914] >>> 03 80 00 18 14 07
> > > > > > > [15046.956420] >>> 03 80 00 17 01 38
> > > > > > > [15046.956985] >>> 03 80 00 18 14 07
> > > > > > > [15046.955931] >>> 02 81 01 fd
> > > > > > > [15046.956511] <<< 7f fe
> > > > > > > [15046.956590] >>> 0f 10 11 00
> > > > > > > [15046.959466] hub 6-0:1.0: port 1 disabled by hub (EMI?),
> > re-enabling...
> > > > > > > [15046.959470] usb 6-1: USB disconnect, address 17
> > > > > > > [15046.959655] dvb_unregister_frontend
> > > > > > > [15046.959656] dvb_frontend_stop
> > > > > > > [15046.961260] >>> 02 81 04 05
> > > > > > > [15046.961267] <<< 00 00
> > > > > > > [15046.961269] >>> 03 80 04 05 00 00
> > > > > > > [15046.961272] ep 0 write error (status = -19, len: 6)
> > > > > > > [15046.961273] >>> 02 81 04 06
> > > > > > > [15046.961275] <<< 40 00
> > > > > > > [15046.961277] >>> 03 80 04 06 42 00
> > > > > > > [15046.961279] ep 0 write error (status = -19, len: 6)
> > > > > > > [15046.961281] >>> 02 81 00 eb
> > > > > > > [15046.961282] <<< 00 d0
> > > > > > > [15046.961284] >>> 03 80 00 eb 00 32
> > > > > > > [15046.961286] ep 0 write error (status = -19, len: 6)
> > > > > > > [15046.961287] >>> 03 80 00 ec 07 00
> > > > > > >
> > > > > > >
> > > > > > > I think this has to be USB related issue...
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > 2008/3/18, Albert Comerma <albert.comerma@gmail.com>:
> > > > > > > > That's very strange... You can try adding a usb hub, but I
> don't
> > think this should be the problem. Perhaps a kernel crash in some
> function...
> > but I don't see much information in your dmesg...
> > > > > > > >
> > > > > > > >
> > > > > > > > Albert
> > > > > > > >
> > > > > > > >
> > > > > > > > 2008/3/18, Antti Luoma <anluoma@gmail.com>:
> > > > > > > > > Yes I'm sure.
> > > > > > > > >
> > > > > > > > > Could the problem be low power from usb? Though this is the
> > only usb device at the moment.
> > > > > > > > >
> > > > > > > > > I get the following line in the log after issuing scan
> command
> > :
> > > > > > > > >
> > > > > > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.629120]
> > dvb_frontend_open
> > > > > > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.629126]
> > dvb_frontend_start
> > > > > > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.629600]
> > dvb_frontend_ioctl
> > > > > > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.629604]
> > dvb_frontend_thread
> > > > > > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.629605] DVB:
> > initialising frontend 0 (DiBcom 7000PC)...
> > > > > > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.637800]
> > dvb_frontend_ioctl
> > > > > > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.637805]
> > dvb_frontend_add_event
> > > > > > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.637502]
> > dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:0
> > auto_sub_step:0 started_auto_step:0
> > > > > > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.717712]
> > dvb_frontend_ioctl
> > > > > > > > > Mar 18 19:03:10 xenbuntu kernel: [13722.883240] usb 6-1:
> USB
> > disconnect, address 14
> > > > > > > > > Mar 18 19:03:10 xenbuntu kernel: [13722.883432]
> > dvb_unregister_frontend
> > > > > > > > > Mar 18 19:03:10 xenbuntu kernel: [13722.883434]
> > dvb_frontend_stop
> > > > > > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.267824]
> > dvb_frontend_ioctl
> > > > > > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.267859]
> > dvb_frontend_ioctl
> > > > > > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.267876]
> > dvb_frontend_ioctl
> > > > > > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.267893]
> > dvb_frontend_ioctl
> > > > > > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.267897]
> > dvb_frontend_release
> > > > > > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.268363] dvb-usb:
> > Pinnacle PCTV 72e DVB-T successfully deinitialized and disconnected.
> > > > > > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.312499] usb 6-1:
> new
> > high speed USB device using ehci_hcd and address 15
> > > > > > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.365651] usb 6-1:
> > configuration #1 chosen from 1 choice
> > > > > > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.365724] dvb-usb:
> found
> > a 'Pinnacle PCTV 72e DVB-T' in warm state.
> > > > > > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.365841] dvb-usb:
> will
> > pass the complete MPEG2 transport stream to the software demuxer.
> > > > > > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.365926] DVB:
> > registering new adapter (Pinnacle PCTV 72e DVB-T)
> > > > > > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.481923]
> > dvb_register_frontend
> > > > > > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.481930] DVB:
> > registering frontend 0 (DiBcom 7000PC)...
> > > > > > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.600365] DiB0070:
> > successfully identified
> > > > > > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.600376] dvb-usb:
> > Pinnacle PCTV 72e DVB-T successfully initialized and connected.
> > > > > > > > >
> > > > > > > > > It looks that it is disconnecting the device after scan has
> > started...?
> > > > > > > > >
> > > > > > > > > BTW this is Ubuntu 8.04 (RC4):
> > > > > > > > > Linux xenbuntu 2.6.24-12-generic #1 SMP Wed Mar 12 22:31:43
> > UTC 2008 x86_64 GNU/Linux
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > -Antti-
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > 2008/3/18, Albert Comerma <albert.comerma@gmail.com>:
> > > > > > > > > > Are you sure you tested with the new compiled module?
> Could
> > you verify that in your
> > v4l-dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
> > you have this on the stk7070p_frontend_attach first line;
> > > > > > > > > >
> > > > > > > > > >        dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 0);
> > > > > > > > > >
> > > > > > > > > > Because I remember with 72e that with GPIO6 set to 1 the
> > tunner is disabled.
> > > > > > > > > > Anyway, your dmesg should tell more information after the
> > failed tunning.
> > > > > > > > > >
> > > > > > > > > > Albert
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > 2008/3/18, Antti Luoma <anluoma@gmail.com>:
> > > > > > > > > > > Good morning to everyone,
> > > > > > > > > > >
> > > > > > > > > > > I tested the Stick with windows and it found channels
> ok..
> > So what shall I do next?
> > > > > > > > > > >
> > > > > > > > > > > -antti-
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > 2008/3/18, Antti Luoma <anluoma@gmail.com>:
> > > > > > > > > > >
> > > > > > > > > > > > Hi,
> > > > > > > > > > > >
> > > > > > > > > > > > Tested with same results :( (no channels...)
> > > > > > > > > > > >
> > > > > > > > > > > > Tomorrow I'l (hmm today, its getting late) test this
> > with windows that it works in there...
> > > > > > > > > > > >
> > > > > > > > > > > > -Antti-
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > 2008/3/18, Albert Comerma <albert.comerma@gmail.com
> >:
> > > > > > > > > > > >
> > > > > > > > > > > > > Just as I pointed a few hours ago;
> > > > > > > > > > > > >
> > > > > > > > > > > > > If you speak french you can have a look here;
> > > > > > > > > > > > >
> > > > > > > > > > > > >
> > http://www.louviaux.com-a.googlepages.com/tntpinnaclepctvdvb-t72e
> > > > > > > > > > > > >
> > > > > > > > > > > > > Or if you don't you can go the fast way;
> > > > > > > > > > > > >
> > > > > > > > > > > > > wget
> > http://www.barbak.org/v4l_for_72e_dongle.tar.bz2
> > > > > > > > > > > > > tar xvjf v4l_for_72e_dongle.tar.bz2
> > > > > > > > > > > > > cd v4l-dvb
> > > > > > > > > > > > > sudo cp
> > firmware/dvb-usb-dib0700-1.10.fw /lib/firmware/
> > > > > > > > > > > > > make all
> > > > > > > > > > > > > sudo make install
> > > > > > > > > > > > >
> > > > > > > > > > > > > That should work for you. Please let me know.
> > > > > > > > > > > > >
> > > > > > > > > > > > >
> > > > > > > > > > > > > 2008/3/17, Antti Luoma <anluoma@gmail.com>:
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Hi,
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > I have trying to get Solo Stick (72e) to work for
> > couple of days, but with no luck. So what's the current status of this
> > driver?
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > I did download latest drivers from mercurial
> today,
> > added PCI_ids for card, modified dib0700_devices.c (in
> > stk7070p_frontend_attach), added device to struct
> dvb_usb_device_properties
> > dib0700_devices[] where stk7070p_frontend_attach was called.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > After that it looked promising:
> > > > > > > > > > > > > >
> > > > > > > > > > > > > >  usb 6-4: new high speed USB device using
> ehci_hcd
> > and address 30
> > > > > > > > > > > > > > [ 6722.607546] usb 6-4: configuration #1 chosen
> from
> > 1 choice
> > > > > > > > > > > > > > [ 6722.607622] dvb-usb: found a 'Pinnacle PCTV
> 72e
> > DVB-T' in warm state.
> > > > > > > > > > > > > > [ 6722.607648] dvb-usb: will pass the complete
> MPEG2
> > transport stream to the software demuxer.
> > > > > > > > > > > > > > [ 6722.607724] DVB: registering new adapter
> > (Pinnacle PCTV 72e DVB-T)
> > > > > > > > > > > > > > [ 6722.731734] dvb_register_frontend
> > > > > > > > > > > > > > [ 6722.731742] DVB: registering frontend 0
> (DiBcom
> > 7000PC)...
> > > > > > > > > > > > > > [ 6722.811550] DiB0070: successfully identified
> > > > > > > > > > > > > > [ 6722.811557] dvb-usb: Pinnacle PCTV 72e DVB-T
> > successfully initialized and connected.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > BUT if I do a scan I don't get channels (i
> checked
> > that I have correct frequencies):
> > > > > > > > > > > > > >
> > > > > > > > > > > > > >  #scan -o vdr  fi-Eurajoki
> > > > > > > > > > > > > > scanning fi-Eurajoki
> > > > > > > > > > > > > > using '/dev/dvb/adapter0/frontend0' and
> > '/dev/dvb/adapter0/demux0'
> > > > > > > > > > > > > > initial transponder 610000000 0 2 9 3 1 2 0
> > > > > > > > > > > > > > initial transponder 666000000 0 2 9 3 1 2 0
> > > > > > > > > > > > > > initial transponder 722000000 0 2 9 3 1 2 0
> > > > > > > > > > > > > > >>> tune to:
> > 610000:I999B8C23D999M64T8G8Y0:T:27500:
> > > > > > > > > > > > > > WARNING: filter timeout pid 0x0011
> > > > > > > > > > > > > > WARNING: filter timeout pid 0x0000
> > > > > > > > > > > > > > WARNING: filter timeout pid 0x0010
> > > > > > > > > > > > > > >>> tune to:
> > 666000:I999B8C23D999M64T8G8Y0:T:27500:
> > > > > > > > > > > > > > __tune_to_transponder:1483: ERROR: Setting
> frontend
> > parameters failed: 19 No such device
> > > > > > > > > > > > > > >>> tune to:
> > 666000:I999B8C23D999M64T8G8Y0:T:27500:
> > > > > > > > > > > > > > __tune_to_transponder:1483: ERROR: Setting
> frontend
> > parameters failed: 19 No such device
> > > > > > > > > > > > > > >>> tune to:
> > 722000:I999B8C23D999M64T8G8Y0:T:27500:
> > > > > > > > > > > > > > __tune_to_transponder:1483: ERROR: Setting
> frontend
> > parameters failed: 19 No such device
> > > > > > > > > > > > > > >>> tune to:
> > 722000:I999B8C23D999M64T8G8Y0:T:27500:
> > > > > > > > > > > > > > __tune_to_transponder:1483: ERROR: Setting
> frontend
> > parameters failed: 19 No such device
> > > > > > > > > > > > > > dumping lists (0 services)
> > > > > > > > > > > > > > Done.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Any thoughts??
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > --
> > > > > > > > > > > > > > -Antti-
> > > > > > > > > > > > > >
> > _______________________________________________
> > > > > > > > > > > > > > linux-dvb mailing list
> > > > > > > > > > > > > > linux-dvb@linuxtv.org
> > > > > > > > > > > > > >
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > > > > > > > > > > > > >
> > > > > > > > > > > > >
> > > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > --
> > > > > > > > > > > > -Antti-
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > --
> > > > > > > > > > > -Antti-
> > > > > > > > > > >
> > _______________________________________________
> > > > > > > > > > > linux-dvb mailing list
> > > > > > > > > > > linux-dvb@linuxtv.org
> > > > > > > > > > >
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > --
> > > > > > > > > -Antti-
> > > > > > > >
> > > > > > > >
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > --
> > > > > > > -Antti-
> > > > > >
> > > > > >
> > > > >
> > > > >
> > > > >
> > > > > --
> > > > > -Antti-
> > > >
> > > >
> > > >
> > > > --
> > > > -Antti-
> > >
> > >
> >
> >
> >
> > --
> > -Antti-
> > _______________________________________________
> >  linux-dvb mailing list
> >  linux-dvb@linuxtv.org
> >  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
>
>
> --
> -----------------------------------------------------
> There are 10 kind op people in the world:
> those who understand binary, and those who don't.
>



-- 
-Antti-

------=_Part_1256_32466013.1209050033674
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,<br><br>Well I think it working but I&#39;m having some issues with my mainboards integrated graphics card (amd 690g / radeon x1250). First when I got it working with 2.6.25 kernel I didn&#39;t managed to compile drivers for the for radeon. Then I waited a while for ubuntu guys to fix the problem from kernel 2.6.24 ( so that radeon drivers worked) -&gt; Finally after that I managed to view the tv first time and the picture quality was ok (I really dont know what to compare on)... BUT there is some strange problem because if tune to a some channel it only show some different colors for a second and after that X or whole computer crashes (And only on some channels, some work ok, this is something that I could not understant..)! This happened few times and with my&nbsp; poor luck it jammed my box so badly that it trashed my whole ext3 filesystem.. <br>
<br>After that I tried with different release (Fedora 8) and same thing continues. I also have been quite busy with other stuff and been waiting for a Hardy Hardon release day so that I can make clean install and try with that, I also borrowed GeForce display card to try with. I&#39;m now downloading hardy so mayby I can try this at weekend and also I noticed that amd released new version from their drivers.<br>
<br>But what comes to 72e stick I think it is NOW easy to install because v4l-dvb provides drivers that work with it ok (you need to get them from mercurial and compile, but nothing really amazing..). <br><br><br>-Antti-<br>
<br><div class="gmail_quote">2008/4/23 Bert Haverkamp &lt;<a href="mailto:bert@bertenselena.net">bert@bertenselena.net</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hello Antii,<br>
<br>
How is the 72e working now? I am thinking of buying it. The local<br>
store has a special offer on it. Is it any good under linux?<br>
<br>
Regards,<br>
<br>
Bert<br>
<br>
2008/3/31, Antti Luoma &lt;<a href="mailto:anluoma@gmail.com">anluoma@gmail.com</a>&gt;:<br>
<div><div></div><div class="Wj3C7c">&gt; Hi,<br>
&gt;<br>
&gt; This was a linux kernel issue, same issue that many others have faced... I<br>
&gt; compiled 2.6.25-rc7 from <a href="http://kernel.org" target="_blank">kernel.org</a> and now it seem to scan channels!<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; 2008/3/20, Albert Comerma &lt;<a href="mailto:albert.comerma@gmail.com">albert.comerma@gmail.com</a>&gt;:<br>
&gt; &gt; Perhaps try an other computer?<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; 2008/3/19, Antti Luoma &lt;<a href="mailto:anluoma@gmail.com">anluoma@gmail.com</a>&gt;:<br>
&gt; &gt;<br>
&gt; &gt; &gt; Hi again,<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; I borrowed Targus 7-port powered usb hub from work today and tried it.<br>
&gt; At first it hang when I issued the scan -&gt; had to reboot (usb was gone).<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; After that same usb error keeps bothering me and I can&#39;t get nothing out<br>
&gt; of the tuner.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; 84.977573] dvb_frontend_add_event<br>
&gt; &gt; &gt; [ &nbsp; 84.977663] dvb_frontend_swzigzag_autotune: drift:0 inversion:0<br>
&gt; auto_step:0 auto_sub_step:0 started_auto_step:0<br>
&gt; &gt; &gt; [ &nbsp; 85.057760] dvb_frontend_ioctl<br>
&gt; &gt; &gt; [ &nbsp; 85.399118] hub 6-3:1.0: port 3 disabled by hub (EMI?),<br>
&gt; re-enabling...<br>
&gt; &gt; &gt; [ &nbsp; 85.399171] usb 6-3.3: USB disconnect, address 4<br>
&gt; &gt; &gt; [ &nbsp; 85.399436] dvb_unregister_frontend<br>
&gt; &gt; &gt; [ &nbsp; 85.399438] dvb_frontend_stop<br>
&gt; &gt; &gt; [ &nbsp; 91.622120] dvb-usb: error while stopping stream.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; I think it disconnects the usb after the tuner finds correct<br>
&gt; signal/stream because it doesn&#39;t reset the usb if it didn&#39;t find any<br>
&gt; channels..<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Anyone has more ideas to try? (they are starting to be very welcome)<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; -antti-<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; 2008/3/18, Antti Luoma &lt;<a href="mailto:anluoma@gmail.com">anluoma@gmail.com</a>&gt;:<br>
&gt; &gt; &gt; &gt; I have get one from somewhere (hmm, maybe at work tomorrow)..<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; btw I&#39;m not alone it seemm , See<br>
&gt; <a href="http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29988.html" target="_blank">http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29988.html</a><br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; -Antti-<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; 2008/3/18, Albert Comerma &lt;<a href="mailto:albert.comerma@gmail.com">albert.comerma@gmail.com</a>&gt;:<br>
&gt; &gt; &gt; &gt; &gt; Yes I think so... try a hub if you have one near...<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; 2008/3/18, Antti Luoma &lt;<a href="mailto:anluoma@gmail.com">anluoma@gmail.com</a>&gt;:<br>
&gt; &gt; &gt; &gt; &gt; &gt; Hmm dmesg says:<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.955374] &lt;&lt;&lt; 14 07<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.955380] &gt;&gt;&gt; 03 80 00 17 01 38<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.955914] &gt;&gt;&gt; 03 80 00 18 14 07<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.956420] &gt;&gt;&gt; 03 80 00 17 01 38<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.956985] &gt;&gt;&gt; 03 80 00 18 14 07<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.955931] &gt;&gt;&gt; 02 81 01 fd<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.956511] &lt;&lt;&lt; 7f fe<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.956590] &gt;&gt;&gt; 0f 10 11 00<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.959466] hub 6-0:1.0: port 1 disabled by hub (EMI?),<br>
&gt; re-enabling...<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.959470] usb 6-1: USB disconnect, address 17<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.959655] dvb_unregister_frontend<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.959656] dvb_frontend_stop<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.961260] &gt;&gt;&gt; 02 81 04 05<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.961267] &lt;&lt;&lt; 00 00<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.961269] &gt;&gt;&gt; 03 80 04 05 00 00<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.961272] ep 0 write error (status = -19, len: 6)<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.961273] &gt;&gt;&gt; 02 81 04 06<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.961275] &lt;&lt;&lt; 40 00<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.961277] &gt;&gt;&gt; 03 80 04 06 42 00<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.961279] ep 0 write error (status = -19, len: 6)<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.961281] &gt;&gt;&gt; 02 81 00 eb<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.961282] &lt;&lt;&lt; 00 d0<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.961284] &gt;&gt;&gt; 03 80 00 eb 00 32<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.961286] ep 0 write error (status = -19, len: 6)<br>
&gt; &gt; &gt; &gt; &gt; &gt; [15046.961287] &gt;&gt;&gt; 03 80 00 ec 07 00<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; I think this has to be USB related issue...<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; 2008/3/18, Albert Comerma &lt;<a href="mailto:albert.comerma@gmail.com">albert.comerma@gmail.com</a>&gt;:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; That&#39;s very strange... You can try adding a usb hub, but I don&#39;t<br>
&gt; think this should be the problem. Perhaps a kernel crash in some function...<br>
&gt; but I don&#39;t see much information in your dmesg...<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; Albert<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; 2008/3/18, Antti Luoma &lt;<a href="mailto:anluoma@gmail.com">anluoma@gmail.com</a>&gt;:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Yes I&#39;m sure.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Could the problem be low power from usb? Though this is the<br>
&gt; only usb device at the moment.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; I get the following line in the log after issuing scan command<br>
&gt; :<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:09 xenbuntu kernel: [13722.629120]<br>
&gt; dvb_frontend_open<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:09 xenbuntu kernel: [13722.629126]<br>
&gt; dvb_frontend_start<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:09 xenbuntu kernel: [13722.629600]<br>
&gt; dvb_frontend_ioctl<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:09 xenbuntu kernel: [13722.629604]<br>
&gt; dvb_frontend_thread<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:09 xenbuntu kernel: [13722.629605] DVB:<br>
&gt; initialising frontend 0 (DiBcom 7000PC)...<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:09 xenbuntu kernel: [13722.637800]<br>
&gt; dvb_frontend_ioctl<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:09 xenbuntu kernel: [13722.637805]<br>
&gt; dvb_frontend_add_event<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:09 xenbuntu kernel: [13722.637502]<br>
&gt; dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:0<br>
&gt; auto_sub_step:0 started_auto_step:0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:09 xenbuntu kernel: [13722.717712]<br>
&gt; dvb_frontend_ioctl<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:10 xenbuntu kernel: [13722.883240] usb 6-1: USB<br>
&gt; disconnect, address 14<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:10 xenbuntu kernel: [13722.883432]<br>
&gt; dvb_unregister_frontend<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:10 xenbuntu kernel: [13722.883434]<br>
&gt; dvb_frontend_stop<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:26 xenbuntu kernel: [13729.267824]<br>
&gt; dvb_frontend_ioctl<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:26 xenbuntu kernel: [13729.267859]<br>
&gt; dvb_frontend_ioctl<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:26 xenbuntu kernel: [13729.267876]<br>
&gt; dvb_frontend_ioctl<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:26 xenbuntu kernel: [13729.267893]<br>
&gt; dvb_frontend_ioctl<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:26 xenbuntu kernel: [13729.267897]<br>
&gt; dvb_frontend_release<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:26 xenbuntu kernel: [13729.268363] dvb-usb:<br>
&gt; Pinnacle PCTV 72e DVB-T successfully deinitialized and disconnected.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:26 xenbuntu kernel: [13729.312499] usb 6-1: new<br>
&gt; high speed USB device using ehci_hcd and address 15<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:26 xenbuntu kernel: [13729.365651] usb 6-1:<br>
&gt; configuration #1 chosen from 1 choice<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:26 xenbuntu kernel: [13729.365724] dvb-usb: found<br>
&gt; a &#39;Pinnacle PCTV 72e DVB-T&#39; in warm state.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:26 xenbuntu kernel: [13729.365841] dvb-usb: will<br>
&gt; pass the complete MPEG2 transport stream to the software demuxer.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:26 xenbuntu kernel: [13729.365926] DVB:<br>
&gt; registering new adapter (Pinnacle PCTV 72e DVB-T)<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:26 xenbuntu kernel: [13729.481923]<br>
&gt; dvb_register_frontend<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:26 xenbuntu kernel: [13729.481930] DVB:<br>
&gt; registering frontend 0 (DiBcom 7000PC)...<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:26 xenbuntu kernel: [13729.600365] DiB0070:<br>
&gt; successfully identified<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Mar 18 19:03:26 xenbuntu kernel: [13729.600376] dvb-usb:<br>
&gt; Pinnacle PCTV 72e DVB-T successfully initialized and connected.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; It looks that it is disconnecting the device after scan has<br>
&gt; started...?<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; BTW this is Ubuntu 8.04 (RC4):<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Linux xenbuntu 2.6.24-12-generic #1 SMP Wed Mar 12 22:31:43<br>
&gt; UTC 2008 x86_64 GNU/Linux<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; -Antti-<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; 2008/3/18, Albert Comerma &lt;<a href="mailto:albert.comerma@gmail.com">albert.comerma@gmail.com</a>&gt;:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Are you sure you tested with the new compiled module? Could<br>
&gt; you verify that in your<br>
&gt; v4l-dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c<br>
&gt; you have this on the stk7070p_frontend_attach first line;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp;dib0700_set_gpio(adap-&gt;dev, GPIO6, GPIO_OUT, 0);<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Because I remember with 72e that with GPIO6 set to 1 the<br>
&gt; tunner is disabled.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Anyway, your dmesg should tell more information after the<br>
&gt; failed tunning.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Albert<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; 2008/3/18, Antti Luoma &lt;<a href="mailto:anluoma@gmail.com">anluoma@gmail.com</a>&gt;:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Good morning to everyone,<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; I tested the Stick with windows and it found channels ok..<br>
&gt; So what shall I do next?<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; -antti-<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; 2008/3/18, Antti Luoma &lt;<a href="mailto:anluoma@gmail.com">anluoma@gmail.com</a>&gt;:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Hi,<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Tested with same results :( (no channels...)<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Tomorrow I&#39;l (hmm today, its getting late) test this<br>
&gt; with windows that it works in there...<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; -Antti-<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; 2008/3/18, Albert Comerma &lt;<a href="mailto:albert.comerma@gmail.com">albert.comerma@gmail.com</a>&gt;:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Just as I pointed a few hours ago;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; If you speak french you can have a look here;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; <a href="http://www.louviaux.com-a.googlepages.com/tntpinnaclepctvdvb-t72e" target="_blank">http://www.louviaux.com-a.googlepages.com/tntpinnaclepctvdvb-t72e</a><br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Or if you don&#39;t you can go the fast way;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; wget<br>
&gt; <a href="http://www.barbak.org/v4l_for_72e_dongle.tar.bz2" target="_blank">http://www.barbak.org/v4l_for_72e_dongle.tar.bz2</a><br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; tar xvjf v4l_for_72e_dongle.tar.bz2<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; cd v4l-dvb<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; sudo cp<br>
&gt; firmware/dvb-usb-dib0700-1.10.fw /lib/firmware/<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; make all<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; sudo make install<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; That should work for you. Please let me know.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; 2008/3/17, Antti Luoma &lt;<a href="mailto:anluoma@gmail.com">anluoma@gmail.com</a>&gt;:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Hi,<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; I have trying to get Solo Stick (72e) to work for<br>
&gt; couple of days, but with no luck. So what&#39;s the current status of this<br>
&gt; driver?<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; I did download latest drivers from mercurial today,<br>
&gt; added PCI_ids for card, modified dib0700_devices.c (in<br>
&gt; stk7070p_frontend_attach), added device to struct dvb_usb_device_properties<br>
&gt; dib0700_devices[] where stk7070p_frontend_attach was called.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; After that it looked promising:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &nbsp;usb 6-4: new high speed USB device using ehci_hcd<br>
&gt; and address 30<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; [ 6722.607546] usb 6-4: configuration #1 chosen from<br>
&gt; 1 choice<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; [ 6722.607622] dvb-usb: found a &#39;Pinnacle PCTV 72e<br>
&gt; DVB-T&#39; in warm state.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; [ 6722.607648] dvb-usb: will pass the complete MPEG2<br>
&gt; transport stream to the software demuxer.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; [ 6722.607724] DVB: registering new adapter<br>
&gt; (Pinnacle PCTV 72e DVB-T)<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; [ 6722.731734] dvb_register_frontend<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; [ 6722.731742] DVB: registering frontend 0 (DiBcom<br>
&gt; 7000PC)...<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; [ 6722.811550] DiB0070: successfully identified<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; [ 6722.811557] dvb-usb: Pinnacle PCTV 72e DVB-T<br>
&gt; successfully initialized and connected.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; BUT if I do a scan I don&#39;t get channels (i checked<br>
&gt; that I have correct frequencies):<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &nbsp;#scan -o vdr &nbsp;fi-Eurajoki<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; scanning fi-Eurajoki<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; using &#39;/dev/dvb/adapter0/frontend0&#39; and<br>
&gt; &#39;/dev/dvb/adapter0/demux0&#39;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; initial transponder 610000000 0 2 9 3 1 2 0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; initial transponder 666000000 0 2 9 3 1 2 0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; initial transponder 722000000 0 2 9 3 1 2 0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;&gt;&gt; tune to:<br>
&gt; 610000:I999B8C23D999M64T8G8Y0:T:27500:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; WARNING: filter timeout pid 0x0011<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; WARNING: filter timeout pid 0x0000<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; WARNING: filter timeout pid 0x0010<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;&gt;&gt; tune to:<br>
&gt; 666000:I999B8C23D999M64T8G8Y0:T:27500:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; __tune_to_transponder:1483: ERROR: Setting frontend<br>
&gt; parameters failed: 19 No such device<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;&gt;&gt; tune to:<br>
&gt; 666000:I999B8C23D999M64T8G8Y0:T:27500:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; __tune_to_transponder:1483: ERROR: Setting frontend<br>
&gt; parameters failed: 19 No such device<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;&gt;&gt; tune to:<br>
&gt; 722000:I999B8C23D999M64T8G8Y0:T:27500:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; __tune_to_transponder:1483: ERROR: Setting frontend<br>
&gt; parameters failed: 19 No such device<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;&gt;&gt; tune to:<br>
&gt; 722000:I999B8C23D999M64T8G8Y0:T:27500:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; __tune_to_transponder:1483: ERROR: Setting frontend<br>
&gt; parameters failed: 19 No such device<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; dumping lists (0 services)<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Done.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Any thoughts??<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; --<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; -Antti-<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; _______________________________________________<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; linux-dvb mailing list<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; --<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; -Antti-<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; --<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; -Antti-<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; _______________________________________________<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; linux-dvb mailing list<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; <a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; --<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; -Antti-<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; --<br>
&gt; &gt; &gt; &gt; &gt; &gt; -Antti-<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; --<br>
&gt; &gt; &gt; &gt; -Antti-<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; --<br>
&gt; &gt; &gt; -Antti-<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; -Antti-<br>
&gt; _______________________________________________<br>
&gt; &nbsp;linux-dvb mailing list<br>
&gt; &nbsp;<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt; &nbsp;<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
&gt;<br>
<br>
<br>
--<br>
</div></div>-----------------------------------------------------<br>
There are 10 kind op people in the world:<br>
those who understand binary, and those who don&#39;t.<br>
</blockquote></div><br><br clear="all"><br>-- <br>-Antti-

------=_Part_1256_32466013.1209050033674--


--===============0764829434==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0764829434==--
