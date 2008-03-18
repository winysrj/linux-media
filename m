Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JbZ0n-0007CP-Je
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 11:25:44 +0100
Received: by fg-out-1718.google.com with SMTP id 22so4599566fge.25
	for <linux-dvb@linuxtv.org>; Tue, 18 Mar 2008 03:25:38 -0700 (PDT)
Message-ID: <ea4209750803180325m30d605eq96689a44ad3cb475@mail.gmail.com>
Date: Tue, 18 Mar 2008 11:25:37 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Antti Luoma" <anluoma@gmail.com>
In-Reply-To: <754a11be0803180118y1ec9c02dm30d8215585106143@mail.gmail.com>
MIME-Version: 1.0
References: <754a11be0803171553p63ac231aicbaeaee4c91b2a2d@mail.gmail.com>
	<ea4209750803171601s28010cebrba2afdc7e3884529@mail.gmail.com>
	<754a11be0803171629h1d3cd2a7m3a3a2f264d6d3004@mail.gmail.com>
	<754a11be0803180118y1ec9c02dm30d8215585106143@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TNT Pinnacle PCTV DVB-T 72e
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1557000395=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1557000395==
Content-Type: multipart/alternative;
	boundary="----=_Part_19052_4039109.1205835937693"

------=_Part_19052_4039109.1205835937693
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Are you sure you tested with the new compiled module? Could you verify that
in your v4l-dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c  you have
this on the stk7070p_frontend_attach first line;

       dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 0);

Because I remember with 72e that with GPIO6 set to 1 the tunner is disabled.
Anyway, your dmesg should tell more information after the failed tunning.

Albert

2008/3/18, Antti Luoma <anluoma@gmail.com>:
>
> Good morning to everyone,
>
> I tested the Stick with windows and it found channels ok.. So what shall I
> do next?
>
> -antti-
>
> 2008/3/18, Antti Luoma <anluoma@gmail.com>:
> >
> > Hi,
> >
> > Tested with same results :( (no channels...)
> >
> > Tomorrow I'l (hmm today, its getting late) test this with windows that
> > it works in there...
> >
> > -Antti-
> >
> >
> > 2008/3/18, Albert Comerma <albert.comerma@gmail.com>:
> > >
> > > Just as I pointed a few hours ago;
> > >
> > > If you speak french you can have a look here;
> > >
> > > http://www.louviaux.com-a.googlepages.com/tntpinnaclepctvdvb-t72e
> > >
> > > Or if you don't you can go the fast way;
> > >
> > > wget http://www.barbak.org/v4l_for_72e_dongle.tar.bz2
> > > tar xvjf v4l_for_72e_dongle.tar.bz2
> > > cd v4l-dvb
> > > sudo cp firmware/dvb-usb-dib0700-1.10.fw /lib/firmware/
> > > make all
> > > sudo make install
> > >
> > > That should work for you. Please let me know.
> > >
> > > 2008/3/17, Antti Luoma <anluoma@gmail.com>:
> > > >
> > > >  Hi,
> > > >
> > > > I have trying to get Solo Stick (72e) to work for couple of days,
> > > > but with no luck. So what's the current status of this driver?
> > > >
> > > > I did download latest drivers from mercurial today, added PCI_ids
> > > > for card, modified dib0700_devices.c (in stk7070p_frontend_attach), added
> > > > device to struct dvb_usb_device_properties dib0700_devices[] where
> > > > stk7070p_frontend_attach was called.
> > > >
> > > > After that it looked promising:
> > > >
> > > >  usb 6-4: new high speed USB device using ehci_hcd and address 30
> > > > [ 6722.607546] usb 6-4: configuration #1 chosen from 1 choice
> > > > [ 6722.607622] dvb-usb: found a 'Pinnacle PCTV 72e DVB-T' in warm
> > > > state.
> > > > [ 6722.607648] dvb-usb: will pass the complete MPEG2 transport
> > > > stream to the software demuxer.
> > > > [ 6722.607724] DVB: registering new adapter (Pinnacle PCTV 72e
> > > > DVB-T)
> > > > [ 6722.731734] dvb_register_frontend
> > > > [ 6722.731742] DVB: registering frontend 0 (DiBcom 7000PC)...
> > > > [ 6722.811550] DiB0070: successfully identified
> > > > [ 6722.811557] dvb-usb: Pinnacle PCTV 72e DVB-T successfully
> > > > initialized and connected.
> > > >
> > > >
> > > > BUT if I do a scan I don't get channels (i checked that I have
> > > > correct frequencies):
> > > >
> > > >  #scan -o vdr  fi-Eurajoki
> > > > scanning fi-Eurajoki
> > > > using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> > > > initial transponder 610000000 0 2 9 3 1 2 0
> > > > initial transponder 666000000 0 2 9 3 1 2 0
> > > > initial transponder 722000000 0 2 9 3 1 2 0
> > > > >>> tune to: 610000:I999B8C23D999M64T8G8Y0:T:27500:
> > > > WARNING: filter timeout pid 0x0011
> > > > WARNING: filter timeout pid 0x0000
> > > > WARNING: filter timeout pid 0x0010
> > > > >>> tune to: 666000:I999B8C23D999M64T8G8Y0:T:27500:
> > > > __tune_to_transponder:1483: ERROR: Setting frontend parameters
> > > > failed: 19 No such device
> > > > >>> tune to: 666000:I999B8C23D999M64T8G8Y0:T:27500:
> > > > __tune_to_transponder:1483: ERROR: Setting frontend parameters
> > > > failed: 19 No such device
> > > > >>> tune to: 722000:I999B8C23D999M64T8G8Y0:T:27500:
> > > > __tune_to_transponder:1483: ERROR: Setting frontend parameters
> > > > failed: 19 No such device
> > > > >>> tune to: 722000:I999B8C23D999M64T8G8Y0:T:27500:
> > > > __tune_to_transponder:1483: ERROR: Setting frontend parameters
> > > > failed: 19 No such device
> > > > dumping lists (0 services)
> > > > Done.
> > > >
> > > > Any thoughts??
> > > >
> > > > --
> > > > -Antti-
> > > > _______________________________________________
> > > > linux-dvb mailing list
> > > > linux-dvb@linuxtv.org
> > > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > > >
> > >
> > >
> >
> >
> > --
> > -Antti-
>
>
>
>
> --
> -Antti-
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_19052_4039109.1205835937693
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Are you sure you tested with the new compiled module? Could you verify that in your v4l-dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c&nbsp; you have this on the stk7070p_frontend_attach first line;<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dib0700_set_gpio(adap-&gt;dev, GPIO6, GPIO_OUT, 0);<br>
<br>Because I remember with 72e that with GPIO6 set to 1 the tunner is disabled.<br>Anyway, your dmesg should tell more information after the failed tunning.<br><br>Albert<br><br><div><span class="gmail_quote">2008/3/18, Antti Luoma &lt;<a href="mailto:anluoma@gmail.com">anluoma@gmail.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Good morning to everyone,<br><br>I tested the Stick with windows and it found channels ok.. So what shall I do next?<br><br>-antti-<br><br><div><span class="gmail_quote">2008/3/18, Antti Luoma &lt;<a href="mailto:anluoma@gmail.com" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">anluoma@gmail.com</a>&gt;:</span><div>
<span class="e" id="q_118c0f88dda2608e_1"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
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
</span></blockquote></span></div></div><br><br clear="all"><br>-- <br><span class="sg">-Antti-
</span><br>_______________________________________________<br>
linux-dvb mailing list<br>
<a onclick="return top.js.OpenExtLink(window,event,this)" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a onclick="return top.js.OpenExtLink(window,event,this)" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></blockquote></div>
<br>

------=_Part_19052_4039109.1205835937693--


--===============1557000395==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1557000395==--
