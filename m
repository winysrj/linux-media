Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anluoma@gmail.com>) id 1JkJO3-0004Ax-9X
	for linux-dvb@linuxtv.org; Fri, 11 Apr 2008 15:33:52 +0200
Received: by el-out-1112.google.com with SMTP id o28so400637ele.2
	for <linux-dvb@linuxtv.org>; Fri, 11 Apr 2008 06:33:43 -0700 (PDT)
Message-ID: <754a11be0804110633o1ed02d73s4bd7b2f96872fe33@mail.gmail.com>
Date: Fri, 11 Apr 2008 16:33:42 +0300
From: "Antti Luoma" <anluoma@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <-512412488328245395@unknownmsgid>
MIME-Version: 1.0
References: <-512412488328245395@unknownmsgid>
Subject: Re: [linux-dvb] [ubuntu 7.10] Typhoon DVB-T Stick => wrong firmware?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1900973794=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1900973794==
Content-Type: multipart/alternative;
	boundary="----=_Part_20592_7788752.1207920822606"

------=_Part_20592_7788752.1207920822606
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

You can change the firmware by just making a symbolic link in to
/lib/firmware/<kernel-version>/dvb-usb-dibusb-6.0.0.8.fw of course you
should move the original aside.

Is there USB disconnect messages after you issue scan? I had the same
problem with Pinnacle 72e stick with ubuntu 8.04, but the kernel issue that
caused it is now fixed in 8.04



2008/4/8 Alexander Petri <alex.petri@gmx.de>:

>  Has no one any suggestion for me?
>
>
>
> *Von:* Alexander Petri [mailto:alex.petri@gmx.de]
> *Gesendet:* Dienstag, 25. M=E4rz 2008 23:11
> *An:* 'linux-dvb@linuxtv.org'
> *Betreff:* [ubuntu 7.10] Typhoon DVB-T Stick =3D> wrong firmware?
>
>
>
> Hi,
> ich have some Troubles brining my Typhoon DVB-T USB to work:
> i called the following:
>
>
>
> xysfsdf@asdf:~$ lsusb
>
> Bus 001 Device 001: ID 0000:0000
>
> Bus 005 Device 003: ID eb1a:e361 eMPIA Technology, Inc.
>
> Bus 005 Device 001: ID 0000:0000
>
> Bus 004 Device 001: ID 0000:0000
>
> Bus 003 Device 001: ID 0000:0000
>
> Bus 002 Device 001: ID 0000:0000
>
> xysfsdf@asdf:~$ dmesg | grep dvb
>
> [ 9380.608000] dvb-usb: found a 'MSI Digivox Mini SL' in cold state, will
> try to load a firmware
>
> [ 9380.744000] dvb-usb: downloading firmware from file
> 'dvb-usb-dibusb-6.0.0.8.fw'
>
> [ 9380.808000] usbcore: registered new interface driver dvb_usb_dibusb_mc
>
> [ 9380.812000] dvb-usb: generic DVB-USB module successfully deinitialized
> and disconnected.
>
> [ 9382.704000] dvb-usb: found a 'MSI Digivox Mini SL' in warm state.
>
> [ 9382.704000] dvb-usb: will pass the complete MPEG2 transport stream to
> the software demuxer.
>
> [ 9383.360000] dvb-usb: schedule remote query interval to 150 msecs.
>
> [ 9383.360000] dvb-usb: MSI Digivox Mini SL successfully initialized and
> connected.
>
> xysfsdf@asdf:~$ dmesg | grep DVB
>
> [ 9380.812000] dvb-usb: generic DVB-USB module successfully deinitialized
> and disconnected.
>
> [ 9382.708000] DVB: registering new adapter (MSI Digivox Mini SL).
>
> [ 9382.712000] DVB: registering frontend 0 (DiBcom 3000MC/P)...
>
> [ 9383.360000] input: IR-receiver inside an USB DVB receiver as
> /class/input/input4
>
>
>
> As you can see ubuntu shows me that there is as MSI Digivox MiniSL
>
> So I guess the wrong firmware is loaded..
>
> If I scan for channels I get this output
>
>
>
> xysfsdf@asdf:~$ scan -c
>
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>
> WARNING: filter timeout pid 0x0011
>
> WARNING: filter timeout pid 0x0000
>
> dumping lists (0 services)
>
> Done.
>
> Also the following could be useful:
>
> x@x-desktop:~$ tail -f /var/log/messages
>
> Mar 25 21:00:41 x-desktop kernel: [ 9382.704000] usb 5-2: configuration #=
1
> chosen from 1 choice
>
> Mar 25 21:00:41 x-desktop kernel: [ 9382.704000] dvb-usb: found a 'MSI
> Digivox Mini SL' in warm state.
>
> Mar 25 21:00:41 x-desktop kernel: [ 9382.704000] dvb-usb: will pass the
> complete MPEG2 transport stream to the software demuxer.
>
> Mar 25 21:00:41 x-desktop kernel: [ 9382.708000] DVB: registering new
> adapter (MSI Digivox Mini SL).
>
> Mar 25 21:00:41 x-desktop kernel: [ 9382.712000] DVB: registering fronten=
d
> 0 (DiBcom 3000MC/P)...
>
> Mar 25 21:00:41 x-desktop kernel: [ 9382.900000] MT2060: successfully
> identified (IF1 =3D 1220)
>
> Mar 25 21:00:42 x-desktop kernel: [ 9383.360000] input: IR-receiver insid=
e
> an USB DVB receiver as /class/input/input4
>
> Mar 25 21:00:42 x-desktop kernel: [ 9383.360000] dvb-usb: schedule remote
> query interval to 150 msecs.
>
> Mar 25 21:00:42 x-desktop kernel: [ 9383.360000] dvb-usb: MSI Digivox Min=
i
> SL successfully initialized and connected.
>
> Mar 25 21:24:59 x-desktop -- MARK --
>
>
>
> How can i force ubuntu to use the right firmware? Or is there the digivox
> chip inside the typhoon box?
>
> How can I use my Stick? Why cant I scan for channels?
>
>
>
> Thx for any comment.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>



--=20
-Antti-

------=_Part_20592_7788752.1207920822606
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

You can change the firmware by just making a symbolic link in to /lib/firmw=
are/&lt;kernel-version&gt;/<span style=3D"font-size: 10pt;" lang=3D"EN-US">=
dvb-usb-dibusb-6.0.0.8.fw of course you should move the original aside. <br=
>
<br>Is there USB disconnect messages after you issue scan? I had the same p=
roblem with Pinnacle 72e stick with ubuntu 8.04, but the kernel issue that =
caused it is now fixed in 8.04<br><br><br></span><br><div class=3D"gmail_qu=
ote">
2008/4/8 Alexander Petri &lt;<a href=3D"mailto:alex.petri@gmx.de">alex.petr=
i@gmx.de</a>&gt;:<br><blockquote class=3D"gmail_quote" style=3D"border-left=
: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1e=
x;">










<div link=3D"blue" vlink=3D"purple" lang=3D"DE">

<div>

<p><span style=3D"color: rgb(31, 73, 125);">Has no one any suggestion for
me?</span></p>

<p><span style=3D"color: rgb(31, 73, 125);">&nbsp;</span></p>

<div>

<div style=3D"border-style: solid none none; border-color: rgb(181, 196, 22=
3) -moz-use-text-color -moz-use-text-color; border-width: 1pt medium medium=
; padding: 3pt 0cm 0cm;">

<p><b><span style=3D"font-size: 10pt;">Von:</span></b><span style=3D"font-s=
ize: 10pt;"> Alexander Petri
[mailto:<a href=3D"mailto:alex.petri@gmx.de" target=3D"_blank">alex.petri@g=
mx.de</a>] <br>
<b>Gesendet:</b> Dienstag, 25. M=E4rz 2008 23:11<br>
<b>An:</b> &#39;<a href=3D"mailto:linux-dvb@linuxtv.org" target=3D"_blank">=
linux-dvb@linuxtv.org</a>&#39;<br>
<b>Betreff:</b> [ubuntu 7.10] Typhoon DVB-T Stick =3D&gt; wrong firmware?</=
span></p>

</div>

</div>

<p>&nbsp;</p>

<p><span style=3D"font-size: 12pt;" lang=3D"EN-US">Hi,<br>
ich have some Troubles brining my Typhoon DVB-T USB to work:<br>
i called the following:</span></p>

<p><span style=3D"font-size: 12pt;" lang=3D"EN-US">&nbsp;</span></p>

<table border=3D"0" cellpadding=3D"0">
 <tbody><tr>
  <td style=3D"padding: 0.75pt;">
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">xysfsdf@asdf:~$
  lsusb</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">Bus
  001 Device 001: ID 0000:0000</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">Bus
  005 Device 003: ID eb1a:e361 eMPIA Technology, Inc.</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">Bus
  005 Device 001: ID 0000:0000</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">Bus
  004 Device 001: ID 0000:0000</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">Bus
  003 Device 001: ID 0000:0000</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">Bus
  002 Device 001: ID 0000:0000</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">xysfsdf@asdf:~$
  dmesg | grep dvb</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">[
  9380.608000] dvb-usb: found a &#39;MSI Digivox Mini SL&#39; in cold state=
, will try
  to load a firmware</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">[
  9380.744000] dvb-usb: downloading firmware from file
  &#39;dvb-usb-dibusb-6.0.0.8.fw&#39;</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">[
  9380.808000] usbcore: registered new interface driver dvb_usb_dibusb_mc</=
span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">[
  9380.812000] dvb-usb: generic DVB-USB module successfully deinitialized a=
nd
  disconnected.</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">[
  9382.704000] dvb-usb: found a &#39;MSI Digivox Mini SL&#39; in warm state=
.</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">[
  9382.704000] dvb-usb: will pass the complete MPEG2 transport stream to th=
e
  software demuxer.</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">[
  9383.360000] dvb-usb: schedule remote query interval to 150 msecs.</span>=
</p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">[
  9383.360000] dvb-usb: MSI Digivox Mini SL successfully initialized and
  connected.</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">xysfsdf@asdf:~$
  dmesg | grep DVB</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">[
  9380.812000] dvb-usb: generic DVB-USB module successfully deinitialized a=
nd
  disconnected.</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">[
  9382.708000] DVB: registering new adapter (MSI Digivox Mini SL).</span></=
p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">[
  9382.712000] DVB: registering frontend 0 (DiBcom 3000MC/P)...</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">[
  9383.360000] input: IR-receiver inside an USB DVB receiver as
  /class/input/input4</span></p>
  </td>
 </tr>
</tbody></table>

<p><span style=3D"font-size: 12pt;" lang=3D"EN-US">&nbsp;</span></p>

<p><span style=3D"font-size: 12pt;" lang=3D"EN-US">As
you can see ubuntu shows me that there is as MSI Digivox MiniSL</span></p>

<p><span style=3D"font-size: 12pt;" lang=3D"EN-US">So
I guess the wrong firmware is loaded..</span></p>

<p><span style=3D"font-size: 12pt;" lang=3D"EN-US">If
I scan for channels I get this output</span></p>

<p><span style=3D"font-size: 12pt;" lang=3D"EN-US">&nbsp;</span></p>

<table border=3D"0" cellpadding=3D"0">
 <tbody><tr>
  <td style=3D"padding: 0.75pt;">
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">xysfsdf@asdf:~$
  scan -c</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">using
  &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#=
39;</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">WARNING:
  filter timeout pid 0x0011</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">WARNING:
  filter timeout pid 0x0000</span></p>
  <p><span style=3D"font-size: 10pt;">dumping
  lists (0 services)</span></p>
  <p><span style=3D"font-size: 10pt;">Done.</span></p>
  </td>
 </tr>
</tbody></table>

<p style=3D"margin-bottom: 12pt;"><span style=3D"font-size: 12pt;" lang=3D"=
EN-US">Also the
following could be useful:</span></p>

<table border=3D"0" cellpadding=3D"0">
 <tbody><tr>
  <td style=3D"padding: 0.75pt;">
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">x@x-desktop:~$
  tail -f /var/log/messages</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">Mar
  25 21:00:41 x-desktop kernel: [ 9382.704000] usb 5-2: configuration #1 ch=
osen
  from 1 choice</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">Mar
  25 21:00:41 x-desktop kernel: [ 9382.704000] dvb-usb: found a &#39;MSI Di=
givox Mini
  SL&#39; in warm state.</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">Mar
  25 21:00:41 x-desktop kernel: [ 9382.704000] dvb-usb: will pass the compl=
ete
  MPEG2 transport stream to the software demuxer.</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">Mar
  25 21:00:41 x-desktop kernel: [ 9382.708000] DVB: registering new adapter
  (MSI Digivox Mini SL).</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">Mar
  25 21:00:41 x-desktop kernel: [ 9382.712000] DVB: registering frontend 0
  (DiBcom 3000MC/P)...</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">Mar
  25 21:00:41 x-desktop kernel: [ 9382.900000] MT2060: successfully identif=
ied
  (IF1 =3D 1220)</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">Mar
  25 21:00:42 x-desktop kernel: [ 9383.360000] input: IR-receiver inside an=
 USB
  DVB receiver as /class/input/input4</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">Mar
  25 21:00:42 x-desktop kernel: [ 9383.360000] dvb-usb: schedule remote que=
ry
  interval to 150 msecs.</span></p>
  <p><span style=3D"font-size: 10pt;" lang=3D"EN-US">Mar
  25 21:00:42 x-desktop kernel: [ 9383.360000] dvb-usb: MSI Digivox Mini SL
  successfully initialized and connected.</span></p>
  <p><span style=3D"font-size: 10pt;">Mar
  25 21:24:59 x-desktop -- MARK --</span></p>
  </td>
 </tr>
</tbody></table>

<p>&nbsp;</p>

<p><span lang=3D"EN-US">How can i force ubuntu to use the right
firmware? Or is there the digivox chip inside the typhoon box?</span></p>

<p><span lang=3D"EN-US">How can I use my Stick? Why cant I scan for
channels?</span></p>

<p><span lang=3D"EN-US">&nbsp;</span></p>

<p><span lang=3D"EN-US">Thx for any comment.</span></p>

</div>

</div>


<br>_______________________________________________<br>
linux-dvb mailing list<br>
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br></blockquote></div><br><br clear=3D"all"><br>-- <br>-Antti-

------=_Part_20592_7788752.1207920822606--


--===============1900973794==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1900973794==--
