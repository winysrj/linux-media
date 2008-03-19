Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.231])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anluoma@gmail.com>) id 1Jc5Wm-0000vM-PX
	for linux-dvb@linuxtv.org; Wed, 19 Mar 2008 22:08:55 +0100
Received: by wr-out-0506.google.com with SMTP id c30so595230wra.14
	for <linux-dvb@linuxtv.org>; Wed, 19 Mar 2008 14:08:47 -0700 (PDT)
Message-ID: <754a11be0803191408j7e6b40e0nc9242604f64622a3@mail.gmail.com>
Date: Wed, 19 Mar 2008 23:08:46 +0200
From: "Antti Luoma" <anluoma@gmail.com>
To: "Albert Comerma" <albert.comerma@gmail.com>, linux-dvb@linuxtv.org
In-Reply-To: <754a11be0803181058r1864c075y60f976c692169a3b@mail.gmail.com>
MIME-Version: 1.0
References: <754a11be0803171553p63ac231aicbaeaee4c91b2a2d@mail.gmail.com>
	<ea4209750803171601s28010cebrba2afdc7e3884529@mail.gmail.com>
	<754a11be0803171629h1d3cd2a7m3a3a2f264d6d3004@mail.gmail.com>
	<754a11be0803180118y1ec9c02dm30d8215585106143@mail.gmail.com>
	<ea4209750803180325m30d605eq96689a44ad3cb475@mail.gmail.com>
	<754a11be0803181023p42945cf7ka3acc99975aa638c@mail.gmail.com>
	<ea4209750803181030ge4fb4c3o6fd885d57744d9e0@mail.gmail.com>
	<754a11be0803181052i6b80ece7o81921dcf142db4e@mail.gmail.com>
	<ea4209750803181053n19acbb1eg7d0528486ee03cc6@mail.gmail.com>
	<754a11be0803181058r1864c075y60f976c692169a3b@mail.gmail.com>
Subject: Re: [linux-dvb] TNT Pinnacle PCTV DVB-T 72e
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1245926543=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1245926543==
Content-Type: multipart/alternative;
	boundary="----=_Part_16515_17353360.1205960926247"

------=_Part_16515_17353360.1205960926247
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi again,

I borrowed Targus 7-port powered usb hub from work today and tried it. At
first it hang when I issued the scan -> had to reboot (usb was gone).

After that same usb error keeps bothering me and I can't get nothing out of
the tuner.

84.977573] dvb_frontend_add_event
[   84.977663] dvb_frontend_swzigzag_autotune: drift:0 inversion:0
auto_step:0 auto_sub_step:0 started_auto_step:0
[   85.057760] dvb_frontend_ioctl
[   85.399118] hub 6-3:1.0: port 3 disabled by hub (EMI?), re-enabling...
[   85.399171] usb 6-3.3: USB disconnect, address 4
[   85.399436] dvb_unregister_frontend
[   85.399438] dvb_frontend_stop
[   91.622120] dvb-usb: error while stopping stream.

I think it disconnects the usb after the tuner finds correct signal/stream
because it doesn't reset the usb if it didn't find any channels..

Anyone has more ideas to try? (they are starting to be very welcome)

-antti-


2008/3/18, Antti Luoma <anluoma@gmail.com>:
>
> I have get one from somewhere (hmm, maybe at work tomorrow)..
>
> btw I'm not alone it seemm , See
> http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29988.html
>
>
> -Antti-
>
> 2008/3/18, Albert Comerma <albert.comerma@gmail.com>:
> >
> > Yes I think so... try a hub if you have one near...
> >
> > 2008/3/18, Antti Luoma <anluoma@gmail.com>:
> > >
> > > Hmm dmesg says:
> > >
> > > [15046.955374] <<< 14 07
> > > [15046.955380] >>> 03 80 00 17 01 38
> > > [15046.955914] >>> 03 80 00 18 14 07
> > > [15046.956420] >>> 03 80 00 17 01 38
> > > [15046.956985] >>> 03 80 00 18 14 07
> > > [15046.955931] >>> 02 81 01 fd
> > > [15046.956511] <<< 7f fe
> > > [15046.956590] >>> 0f 10 11 00
> > > [15046.959466] hub 6-0:1.0: port 1 disabled by hub (EMI?),
> > > re-enabling...
> > > [15046.959470] usb 6-1: USB disconnect, address 17
> > > [15046.959655] dvb_unregister_frontend
> > > [15046.959656] dvb_frontend_stop
> > > [15046.961260] >>> 02 81 04 05
> > > [15046.961267] <<< 00 00
> > > [15046.961269] >>> 03 80 04 05 00 00
> > > [15046.961272] ep 0 write error (status = -19, len: 6)
> > > [15046.961273] >>> 02 81 04 06
> > > [15046.961275] <<< 40 00
> > > [15046.961277] >>> 03 80 04 06 42 00
> > > [15046.961279] ep 0 write error (status = -19, len: 6)
> > > [15046.961281] >>> 02 81 00 eb
> > > [15046.961282] <<< 00 d0
> > > [15046.961284] >>> 03 80 00 eb 00 32
> > > [15046.961286] ep 0 write error (status = -19, len: 6)
> > > [15046.961287] >>> 03 80 00 ec 07 00
> > >
> > >
> > > I think this has to be USB related issue...
> > >
> > >
> > >
> > >
> > > 2008/3/18, Albert Comerma <albert.comerma@gmail.com>:
> > > >
> > > > That's very strange... You can try adding a usb hub, but I don't
> > > > think this should be the problem. Perhaps a kernel crash in some function...
> > > > but I don't see much information in your dmesg...
> > > >
> > > > Albert
> > > >
> > > > 2008/3/18, Antti Luoma <anluoma@gmail.com>:
> > > > >
> > > > > Yes I'm sure.
> > > > >
> > > > > Could the problem be low power from usb? Though this is the only
> > > > > usb device at the moment.
> > > > >
> > > > > I get the following line in the log after issuing scan command :
> > > > >
> > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.629120] dvb_frontend_open
> > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.629126] dvb_frontend_start
> > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.629600] dvb_frontend_ioctl
> > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.629604]
> > > > > dvb_frontend_thread
> > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.629605] DVB: initialising
> > > > > frontend 0 (DiBcom 7000PC)...
> > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.637800] dvb_frontend_ioctl
> > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.637805]
> > > > > dvb_frontend_add_event
> > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.637502]
> > > > > dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:0
> > > > > auto_sub_step:0 started_auto_step:0
> > > > > Mar 18 19:03:09 xenbuntu kernel: [13722.717712] dvb_frontend_ioctl
> > > > > Mar 18 19:03:10 xenbuntu kernel: [13722.883240] usb 6-1: USB
> > > > > disconnect, address 14
> > > > > Mar 18 19:03:10 xenbuntu kernel: [13722.883432]
> > > > > dvb_unregister_frontend
> > > > > Mar 18 19:03:10 xenbuntu kernel: [13722.883434] dvb_frontend_stop
> > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.267824] dvb_frontend_ioctl
> > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.267859] dvb_frontend_ioctl
> > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.267876] dvb_frontend_ioctl
> > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.267893] dvb_frontend_ioctl
> > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.267897]
> > > > > dvb_frontend_release
> > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.268363] dvb-usb: Pinnacle
> > > > > PCTV 72e DVB-T successfully deinitialized and disconnected.
> > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.312499] usb 6-1: new high
> > > > > speed USB device using ehci_hcd and address 15
> > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.365651] usb 6-1:
> > > > > configuration #1 chosen from 1 choice
> > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.365724] dvb-usb: found a
> > > > > 'Pinnacle PCTV 72e DVB-T' in warm state.
> > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.365841] dvb-usb: will pass
> > > > > the complete MPEG2 transport stream to the software demuxer.
> > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.365926] DVB: registering
> > > > > new adapter (Pinnacle PCTV 72e DVB-T)
> > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.481923]
> > > > > dvb_register_frontend
> > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.481930] DVB: registering
> > > > > frontend 0 (DiBcom 7000PC)...
> > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.600365] DiB0070:
> > > > > successfully identified
> > > > > Mar 18 19:03:26 xenbuntu kernel: [13729.600376] dvb-usb: Pinnacle
> > > > > PCTV 72e DVB-T successfully initialized and connected.
> > > > >
> > > > > It looks that it is disconnecting the device after scan has
> > > > > started...?
> > > > >
> > > > > BTW this is Ubuntu 8.04 (RC4):
> > > > > Linux xenbuntu 2.6.24-12-generic #1 SMP Wed Mar 12 22:31:43 UTC
> > > > > 2008 x86_64 GNU/Linux
> > > > >
> > > > > -Antti-
> > > > >
> > > > > 2008/3/18, Albert Comerma <albert.comerma@gmail.com>:
> > > > > >
> > > > > > Are you sure you tested with the new compiled module? Could you
> > > > > > verify that in your
> > > > > > v4l-dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c  you have this on
> > > > > > the stk7070p_frontend_attach first line;
> > > > > >
> > > > > >        dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 0);
> > > > > >
> > > > > > Because I remember with 72e that with GPIO6 set to 1 the tunner
> > > > > > is disabled.
> > > > > > Anyway, your dmesg should tell more information after the failed
> > > > > > tunning.
> > > > > >
> > > > > > Albert
> > > > > >
> > > > > > 2008/3/18, Antti Luoma <anluoma@gmail.com>:
> > > > > > >
> > > > > > > Good morning to everyone,
> > > > > > >
> > > > > > > I tested the Stick with windows and it found channels ok.. So
> > > > > > > what shall I do next?
> > > > > > >
> > > > > > > -antti-
> > > > > > >
> > > > > > > 2008/3/18, Antti Luoma <anluoma@gmail.com>:
> > > > > > > >
> > > > > > > > Hi,
> > > > > > > >
> > > > > > > > Tested with same results :( (no channels...)
> > > > > > > >
> > > > > > > > Tomorrow I'l (hmm today, its getting late) test this with
> > > > > > > > windows that it works in there...
> > > > > > > >
> > > > > > > > -Antti-
> > > > > > > >
> > > > > > > >
> > > > > > > > 2008/3/18, Albert Comerma <albert.comerma@gmail.com>:
> > > > > > > > >
> > > > > > > > > Just as I pointed a few hours ago;
> > > > > > > > >
> > > > > > > > > If you speak french you can have a look here;
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > http://www.louviaux.com-a.googlepages.com/tntpinnaclepctvdvb-t72e
> > > > > > > > >
> > > > > > > > > Or if you don't you can go the fast way;
> > > > > > > > >
> > > > > > > > > wget http://www.barbak.org/v4l_for_72e_dongle.tar.bz2
> > > > > > > > > tar xvjf v4l_for_72e_dongle.tar.bz2
> > > > > > > > > cd v4l-dvb
> > > > > > > > > sudo cp firmware/dvb-usb-dib0700-1.10.fw /lib/firmware/
> > > > > > > > > make all
> > > > > > > > > sudo make install
> > > > > > > > >
> > > > > > > > > That should work for you. Please let me know.
> > > > > > > > >
> > > > > > > > > 2008/3/17, Antti Luoma <anluoma@gmail.com>:
> > > > > > > > > >
> > > > > > > > > >  Hi,
> > > > > > > > > >
> > > > > > > > > > I have trying to get Solo Stick (72e) to work for couple
> > > > > > > > > > of days, but with no luck. So what's the current status of this driver?
> > > > > > > > > >
> > > > > > > > > > I did download latest drivers from mercurial today,
> > > > > > > > > > added PCI_ids for card, modified dib0700_devices.c (in
> > > > > > > > > > stk7070p_frontend_attach), added device to struct dvb_usb_device_properties
> > > > > > > > > > dib0700_devices[] where stk7070p_frontend_attach was called.
> > > > > > > > > >
> > > > > > > > > > After that it looked promising:
> > > > > > > > > >
> > > > > > > > > >  usb 6-4: new high speed USB device using ehci_hcd and
> > > > > > > > > > address 30
> > > > > > > > > > [ 6722.607546] usb 6-4: configuration #1 chosen from 1
> > > > > > > > > > choice
> > > > > > > > > > [ 6722.607622] dvb-usb: found a 'Pinnacle PCTV 72e
> > > > > > > > > > DVB-T' in warm state.
> > > > > > > > > > [ 6722.607648] dvb-usb: will pass the complete MPEG2
> > > > > > > > > > transport stream to the software demuxer.
> > > > > > > > > > [ 6722.607724] DVB: registering new adapter (Pinnacle
> > > > > > > > > > PCTV 72e DVB-T)
> > > > > > > > > > [ 6722.731734] dvb_register_frontend
> > > > > > > > > > [ 6722.731742] DVB: registering frontend 0 (DiBcom
> > > > > > > > > > 7000PC)...
> > > > > > > > > > [ 6722.811550] DiB0070: successfully identified
> > > > > > > > > > [ 6722.811557] dvb-usb: Pinnacle PCTV 72e DVB-T
> > > > > > > > > > successfully initialized and connected.
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > BUT if I do a scan I don't get channels (i checked that
> > > > > > > > > > I have correct frequencies):
> > > > > > > > > >
> > > > > > > > > >  #scan -o vdr  fi-Eurajoki
> > > > > > > > > > scanning fi-Eurajoki
> > > > > > > > > > using '/dev/dvb/adapter0/frontend0' and
> > > > > > > > > > '/dev/dvb/adapter0/demux0'
> > > > > > > > > > initial transponder 610000000 0 2 9 3 1 2 0
> > > > > > > > > > initial transponder 666000000 0 2 9 3 1 2 0
> > > > > > > > > > initial transponder 722000000 0 2 9 3 1 2 0
> > > > > > > > > > >>> tune to: 610000:I999B8C23D999M64T8G8Y0:T:27500:
> > > > > > > > > > WARNING: filter timeout pid 0x0011
> > > > > > > > > > WARNING: filter timeout pid 0x0000
> > > > > > > > > > WARNING: filter timeout pid 0x0010
> > > > > > > > > > >>> tune to: 666000:I999B8C23D999M64T8G8Y0:T:27500:
> > > > > > > > > > __tune_to_transponder:1483: ERROR: Setting frontend
> > > > > > > > > > parameters failed: 19 No such device
> > > > > > > > > > >>> tune to: 666000:I999B8C23D999M64T8G8Y0:T:27500:
> > > > > > > > > > __tune_to_transponder:1483: ERROR: Setting frontend
> > > > > > > > > > parameters failed: 19 No such device
> > > > > > > > > > >>> tune to: 722000:I999B8C23D999M64T8G8Y0:T:27500:
> > > > > > > > > > __tune_to_transponder:1483: ERROR: Setting frontend
> > > > > > > > > > parameters failed: 19 No such device
> > > > > > > > > > >>> tune to: 722000:I999B8C23D999M64T8G8Y0:T:27500:
> > > > > > > > > > __tune_to_transponder:1483: ERROR: Setting frontend
> > > > > > > > > > parameters failed: 19 No such device
> > > > > > > > > > dumping lists (0 services)
> > > > > > > > > > Done.
> > > > > > > > > >
> > > > > > > > > > Any thoughts??
> > > > > > > > > >
> > > > > > > > > > --
> > > > > > > > > > -Antti-
> > > > > > > > > > _______________________________________________
> > > > > > > > > > linux-dvb mailing list
> > > > > > > > > > linux-dvb@linuxtv.org
> > > > > > > > > >
> > > > > > > > > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > --
> > > > > > > > -Antti-
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > --
> > > > > > > -Antti-
> > > > > > > _______________________________________________
> > > > > > > linux-dvb mailing list
> > > > > > > linux-dvb@linuxtv.org
> > > > > > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > > > > > >
> > > > > >
> > > > > >
> > > > >
> > > > >
> > > > > --
> > > > > -Antti-
> > > >
> > > >
> > > >
> > >
> > >
> > > --
> > > -Antti-
> >
> >
> >
>
>
> --
> -Antti-




-- 
-Antti-

------=_Part_16515_17353360.1205960926247
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi again,<br><br>I borrowed Targus 7-port powered usb hub from work today and tried it. At first it hang when I issued the scan -&gt; had to reboot (usb was gone).<br><br>After that same usb error keeps bothering me and I can&#39;t get nothing out of the tuner.<br>
<br>84.977573] dvb_frontend_add_event<br>[&nbsp;&nbsp; 84.977663] dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:0 auto_sub_step:0 started_auto_step:0<br>[&nbsp;&nbsp; 85.057760] dvb_frontend_ioctl<br><span style="font-weight: bold;">[&nbsp;&nbsp; 85.399118] hub 6-3:1.0: port 3 disabled by hub (EMI?), re-enabling...</span><br>
[&nbsp;&nbsp; 85.399171] usb 6-3.3: USB disconnect, address 4<br>[&nbsp;&nbsp; 85.399436] dvb_unregister_frontend<br>[&nbsp;&nbsp; 85.399438] dvb_frontend_stop<br>[&nbsp;&nbsp; 91.622120] dvb-usb: error while stopping stream.<br><br>I think it disconnects the usb after the tuner finds correct signal/stream because it doesn&#39;t reset the usb if it didn&#39;t find any channels..<br>
<br>Anyone has more ideas to try? (they are starting to be very welcome)<br><br>-antti-<br><br><br><div><span class="gmail_quote">2008/3/18, Antti Luoma &lt;<a href="mailto:anluoma@gmail.com" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">anluoma@gmail.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">

I have get one from somewhere (hmm, maybe at work tomorrow)..<br><br>btw I&#39;m not alone it seemm , See <a href="http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29988.html" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29988.html</a><div>

<span><br>
<br><br>-Antti-<br><br><div><span class="gmail_quote">2008/3/18, Albert Comerma &lt;<a href="mailto:albert.comerma@gmail.com" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">albert.comerma@gmail.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">


Yes I think so... try a hub if you have one near...<div><span><br><br><div><span class="gmail_quote">2008/3/18, Antti Luoma &lt;<a href="mailto:anluoma@gmail.com" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">anluoma@gmail.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">



Hmm dmesg says:<br><br>[15046.955374] &lt;&lt;&lt; 14 07 <br>[15046.955380] &gt;&gt;&gt; 03 80 00 17 01 38 <br>[15046.955914] &gt;&gt;&gt; 03 80 00 18 14 07 <br>[15046.956420] &gt;&gt;&gt; 03 80 00 17 01 38 <br>[15046.956985] &gt;&gt;&gt; 03 80 00 18 14 07 <br>




[15046.955931] &gt;&gt;&gt; 02 81 01 fd <br>[15046.956511] &lt;&lt;&lt; 7f fe <br>[15046.956590] &gt;&gt;&gt; 0f 10 11 00 <br><span style="font-weight: bold;">[15046.959466] hub 6-0:1.0: port 1 disabled by hub (EMI?), re-enabling...</span><br style="font-weight: bold;">




<span style="font-weight: bold;">[15046.959470] usb 6-1: USB disconnect, address 17</span><br>[15046.959655] dvb_unregister_frontend<br>[15046.959656] dvb_frontend_stop<br>[15046.961260] &gt;&gt;&gt; 02 81 04 05 <br>[15046.961267] &lt;&lt;&lt; 00 00 <br>




[15046.961269] &gt;&gt;&gt; 03 80 04 05 00 00 <br>[15046.961272] ep 0 write error (status = -19, len: 6)<br>[15046.961273] &gt;&gt;&gt; 02 81 04 06 <br>[15046.961275] &lt;&lt;&lt; 40 00 <br>[15046.961277] &gt;&gt;&gt; 03 80 04 06 42 00 <br>




[15046.961279] ep 0 write error (status = -19, len: 6)<br>[15046.961281] &gt;&gt;&gt; 02 81 00 eb <br>[15046.961282] &lt;&lt;&lt; 00 d0 <br>[15046.961284] &gt;&gt;&gt; 03 80 00 eb 00 32 <br>[15046.961286] ep 0 write error (status = -19, len: 6)<br>




[15046.961287] &gt;&gt;&gt; 03 80 00 ec 07 00 <br><br><br>I think this has to be USB related issue...<div><span><br><br><br><br><br><div><span class="gmail_quote">2008/3/18, Albert Comerma &lt;<a href="mailto:albert.comerma@gmail.com" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">albert.comerma@gmail.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">




That&#39;s very strange... You can try adding a usb hub, but I don&#39;t think this should be the problem. Perhaps a kernel crash in some function... but I don&#39;t see much information in your dmesg...<div><span><br>
<br>Albert<br><br>
<div><span class="gmail_quote">2008/3/18, Antti Luoma &lt;<a href="mailto:anluoma@gmail.com" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">anluoma@gmail.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">





Yes I&#39;m sure.<br><br>Could the problem be low power from usb? Though this is the only usb device at the moment.<br><br>I get the following line in the log after issuing scan command : <br><br>Mar 18 19:03:09 xenbuntu kernel: [13722.629120] dvb_frontend_open<br>






Mar 18 19:03:09 xenbuntu kernel: [13722.629126] dvb_frontend_start<br>Mar 18 19:03:09 xenbuntu kernel: [13722.629600] dvb_frontend_ioctl<br>Mar 18 19:03:09 xenbuntu kernel: [13722.629604] dvb_frontend_thread<br>Mar 18 19:03:09 xenbuntu kernel: [13722.629605] DVB: initialising frontend 0 (DiBcom 7000PC)...<br>






Mar 18 19:03:09 xenbuntu kernel: [13722.637800] dvb_frontend_ioctl<br>Mar 18 19:03:09 xenbuntu kernel: [13722.637805] dvb_frontend_add_event<br>Mar 18 19:03:09 xenbuntu kernel: [13722.637502] dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:0 auto_sub_step:0 started_auto_step:0<br>






<span style="font-weight: bold;">Mar 18 19:03:09 xenbuntu kernel: [13722.717712] dvb_frontend_ioctl</span><br style="font-weight: bold;"><span style="font-weight: bold;">Mar 18 19:03:10 xenbuntu kernel: [13722.883240] usb 6-1: USB disconnect, address 14</span><br>






<span style="font-weight: bold;">Mar 18 19:03:10 xenbuntu kernel: [13722.883432] dvb_unregister_frontend</span><br style="font-weight: bold;"><span style="font-weight: bold;">Mar 18 19:03:10 xenbuntu kernel: [13722.883434] dvb_frontend_stop</span><br>






Mar 18 19:03:26 xenbuntu kernel: [13729.267824] dvb_frontend_ioctl<br>Mar 18 19:03:26 xenbuntu kernel: [13729.267859] dvb_frontend_ioctl<br>Mar 18 19:03:26 xenbuntu kernel: [13729.267876] dvb_frontend_ioctl<br>Mar 18 19:03:26 xenbuntu kernel: [13729.267893] dvb_frontend_ioctl<br>






Mar 18 19:03:26 xenbuntu kernel: [13729.267897] dvb_frontend_release<br>Mar 18 19:03:26 xenbuntu kernel: [13729.268363] dvb-usb: Pinnacle PCTV 72e DVB-T successfully deinitialized and disconnected.<br>Mar 18 19:03:26 xenbuntu kernel: [13729.312499] usb 6-1: new high speed USB device using ehci_hcd and address 15<br>






Mar 18 19:03:26 xenbuntu kernel: [13729.365651] usb 6-1: configuration #1 chosen from 1 choice<br>Mar 18 19:03:26 xenbuntu kernel: [13729.365724] dvb-usb: found a &#39;Pinnacle PCTV 72e DVB-T&#39; in warm state.<br>Mar 18 19:03:26 xenbuntu kernel: [13729.365841] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>






Mar 18 19:03:26 xenbuntu kernel: [13729.365926] DVB: registering new adapter (Pinnacle PCTV 72e DVB-T)<br>Mar 18 19:03:26 xenbuntu kernel: [13729.481923] dvb_register_frontend<br>Mar 18 19:03:26 xenbuntu kernel: [13729.481930] DVB: registering frontend 0 (DiBcom 7000PC)...<br>






Mar 18 19:03:26 xenbuntu kernel: [13729.600365] DiB0070: successfully identified<br>Mar 18 19:03:26 xenbuntu kernel: [13729.600376] dvb-usb: Pinnacle PCTV 72e DVB-T successfully initialized and connected.<br><br>It looks that it is disconnecting the device after scan has started...?<br>






<br>BTW this is Ubuntu 8.04 (RC4):<br>Linux xenbuntu 2.6.24-12-generic #1 SMP Wed Mar 12 22:31:43 UTC 2008 x86_64 GNU/Linux<div><span><br><br>-Antti-<br><br><div><span class="gmail_quote">2008/3/18, Albert Comerma &lt;<a href="mailto:albert.comerma@gmail.com" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">albert.comerma@gmail.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">






Are you sure you tested with the new compiled module? Could you verify that in your v4l-dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c&nbsp; you have this on the stk7070p_frontend_attach first line;<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dib0700_set_gpio(adap-&gt;dev, GPIO6, GPIO_OUT, 0);<br>







<br>Because I remember with 72e that with GPIO6 set to 1 the tunner is disabled.<br>Anyway, your dmesg should tell more information after the failed tunning.<br><span><br>Albert</span><div><span><br>
<br><div><span class="gmail_quote">2008/3/18, Antti Luoma &lt;<a href="mailto:anluoma@gmail.com" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">anluoma@gmail.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">







Good morning to everyone,<br><br>I tested the Stick with windows and it found channels ok.. So what shall I do next?<br><br>-antti-<br><br><div><span class="gmail_quote">2008/3/18, Antti Luoma &lt;<a href="mailto:anluoma@gmail.com" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">anluoma@gmail.com</a>&gt;:</span><div>







<span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi,<br><br>Tested with same results :( (no channels...)<br><br>Tomorrow I&#39;l (hmm today, its getting late) test this with windows that it works in there...<br><br>-Antti-<br><br><br><div><span class="gmail_quote">2008/3/18, Albert Comerma &lt;<a href="mailto:albert.comerma@gmail.com" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">albert.comerma@gmail.com</a>&gt;:</span><div>








<span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Just as I pointed a few hours ago;<br><br>If you speak french you can have a look here;<br><br><a href="http://www.louviaux.com-a.googlepages.com/tntpinnaclepctvdvb-t72e" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">http://www.louviaux.com-a.googlepages.com/tntpinnaclepctvdvb-t72e</a><br>










<br>Or if you don&#39;t you can go the fast way;<br>
<br>wget <a href="http://www.barbak.org/v4l_for_72e_dongle.tar.bz2" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">http://www.barbak.org/v4l_for_72e_dongle.tar.bz2</a><br>
tar xvjf v4l_for_72e_dongle.tar.bz2<br>
cd  v4l-dvb<br>
sudo cp  firmware/dvb-usb-dib0700-1.10.fw /lib/firmware/<br>
make all<br>
sudo make install<br><br>That should work for you. Please let me know.<br><br><div><span class="gmail_quote">2008/3/17, Antti Luoma &lt;<a href="mailto:anluoma@gmail.com" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">anluoma@gmail.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">









<div><span>
Hi,<br><br>I have trying to get Solo Stick (72e) to work for couple of days, but with no luck. So what&#39;s the current status of this driver?<br><br>I did download latest drivers from mercurial today, added PCI_ids for card, modified dib0700_devices.c (in stk7070p_frontend_attach), added device to struct dvb_usb_device_properties dib0700_devices[] where stk7070p_frontend_attach was called. <br>











<br>After that it looked promising:<br><br>&nbsp;usb 6-4: new high speed USB device using ehci_hcd and address 30<br>[ 6722.607546] usb 6-4: configuration #1 chosen from 1 choice<br>[ 6722.607622] dvb-usb: found a &#39;Pinnacle PCTV 72e DVB-T&#39; in warm state.<br>











[ 6722.607648] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>[ 6722.607724] DVB: registering new adapter (Pinnacle PCTV 72e DVB-T)<br>[ 6722.731734] dvb_register_frontend<br>[ 6722.731742] DVB: registering frontend 0 (DiBcom 7000PC)...<br>











[ 6722.811550] DiB0070: successfully identified<br>[ 6722.811557] dvb-usb: Pinnacle PCTV 72e DVB-T successfully initialized and connected.<br><br><br>BUT if I do a scan I don&#39;t get channels (i checked that I have correct frequencies):<br>











<br>&nbsp;#scan -o vdr&nbsp; fi-Eurajoki <br>scanning fi-Eurajoki<br>using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#39;<br>initial transponder 610000000 0 2 9 3 1 2 0<br>initial transponder 666000000 0 2 9 3 1 2 0<br>











initial transponder 722000000 0 2 9 3 1 2 0<br>&gt;&gt;&gt; tune to: 610000:I999B8C23D999M64T8G8Y0:T:27500:<br>WARNING: filter timeout pid 0x0011<br>WARNING: filter timeout pid 0x0000<br>WARNING: filter timeout pid 0x0010<br>











&gt;&gt;&gt; tune to: 666000:I999B8C23D999M64T8G8Y0:T:27500:<br>__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 19 No such device<br>&gt;&gt;&gt; tune to: 666000:I999B8C23D999M64T8G8Y0:T:27500:<br>










__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 19 No such device<br>
&gt;&gt;&gt; tune to: 722000:I999B8C23D999M64T8G8Y0:T:27500:<br>__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 19 No such device<br>&gt;&gt;&gt; tune to: 722000:I999B8C23D999M64T8G8Y0:T:27500:<br>










__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 19 No such device<br>
dumping lists (0 services)<br>Done.<br><br>Any thoughts??<br clear="all"><br>-- <br><span>-Antti-
</span><br></span></div>_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></blockquote></div>










<br>
</blockquote></span></div></div><br><br clear="all"><br>-- <br><span>-Antti-
</span></blockquote></span></div></div><br><br clear="all"><br>-- <br><span>-Antti-
</span><br>_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></blockquote></div>







<br>
</span></div></blockquote></div><br><br clear="all"><br></span></div>-- <br><span>-Antti-
</span></blockquote></div><br>
</span></div></blockquote></div><br><br clear="all"><br></span></div>-- <br><span>-Antti-
</span></blockquote></div><br>
</span></div></blockquote></div><br><br clear="all"><br></span></div>-- <br><span>-Antti-
</span></blockquote></div><br><br clear="all"><br>-- <br>-Antti-

------=_Part_16515_17353360.1205960926247--


--===============1245926543==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1245926543==--
