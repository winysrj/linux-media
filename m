Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timothyparez@gmail.com>) id 1JbBio-00016T-0T
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 10:33:35 +0100
Received: by fk-out-0910.google.com with SMTP id z22so7132196fkz.1
	for <linux-dvb@linuxtv.org>; Mon, 17 Mar 2008 02:33:00 -0700 (PDT)
Message-Id: <D2539D1D-5A7C-4C04-953A-13775C762FBD@gmail.com>
From: Timothy Parez <timothyparez@gmail.com>
To: joris abadie <temps.jo@gmail.com>
In-Reply-To: <a5467650803170001v41323699v88fd983566bad8c6@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Mon, 17 Mar 2008 10:32:52 +0100
References: <235E220E-C575-467D-85AB-181C2BEF9669@gmail.com>
	<a5467650803161233h459b981w27db8c45dca36d16@mail.gmail.com>
	<650D9864-A2A4-4AB7-ACCC-DD54368FFB75@gmail.com>
	<a5467650803170001v41323699v88fd983566bad8c6@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Nova-S-Plus scan ERROR: Initial Tuning Failed
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0544227665=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============0544227665==
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-7--194093792"
Content-Transfer-Encoding: 7bit

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-7--194093792
Content-Type: multipart/alternative; boundary=Apple-Mail-6--194093842


--Apple-Mail-6--194093842
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: quoted-printable

I just tested the card on Windows Vista and it works. Altough I'm only =20=

getting a limited ammount of channels
but had the same problem with my other card so that's probably not =20
card related. (My TV decoder gets all channels)


Timothy.
On 17 Mar 2008, at 08:01, joris abadie wrote:

> Since your post, I try with feisty and gutsy, the nova-S PCI and it =20=

> is the same, no problem. Maybe your card is broken or something with =20=

> your PC. Can you give me dmesg ?
>
>
> 2008/3/17, Timothy Parez <timothyparez@gmail.com>:
> Hi,
>
> I put the card in a new computer and installed Ubuntu Hardy, the =20
> latest preview.
> The adapter is recognized so I installed dvb-utils.
>
> Then I executed
> scan /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-28.2E
>
> The result was the same
>
> WARNING >>> tuning failed!
>
>
> Timothy. =09
>
>
> On 16 Mar 2008, at 20:33, joris abadie wrote:
>
>> Bonjour,
>> j'ai quatre satellites sur nova-S ( Astra 19=B0, hotbird ... ) et =20
>> tout s'est install=E9 tout seul.
>> Every thing is OK with HARDY no install to do ; me-tv or kaffeine =20
>> have the chanels very good
>>
>> 2008/3/15, Timothy Parez <timothyparez@gmail.com>:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Hi,
>>
>> The output of lspci -vvv on my computer looks like this:
>>
>> 04:00.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video
>> and Audio Decoder (rev 05)
>>         Subsystem: Hauppauge computer works Inc. Nova-S-Plus DVB-S
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =20=

>> ParErr-
>> Stepping- SERR- FastB2B-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =20
>> >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 =20=

>> bytes
>>         Interrupt: pin A routed to IRQ 20
>>         Region 0: Memory at e5000000 (32-bit, non-prefetchable) =20
>> [size=3D16M]
>>         Capabilities: [44] Vital Product Data
>>         Capabilities: [4c] Power Management version 2
>>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>>
>> 04:00.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and
>> Audio Decoder [Audio Port] (rev 05)
>>         Subsystem: Hauppauge computer works Inc. Unknown device 9202
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =20=

>> ParErr-
>> Stepping- SERR- FastB2B-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =20
>> >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 32 =20=

>> bytes
>>         Interrupt: pin A routed to IRQ 20
>>         Region 0: Memory at e6000000 (32-bit, non-prefetchable) =20
>> [size=3D16M]
>>         Capabilities: [4c] Power Management version 2
>>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>>
>> 04:00.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and
>> Audio Decoder [MPEG Port] (rev 05)
>>         Subsystem: Hauppauge computer works Inc. Unknown device 9202
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =20=

>> ParErr-
>> Stepping- SERR- FastB2B-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =20
>> >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 32 =20=

>> bytes
>>         Interrupt: pin A routed to IRQ 20
>>         Region 0: Memory at e7000000 (32-bit, non-prefetchable) =20
>> [size=3D16M]
>>         Capabilities: [4c] Power Management version 2
>>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>>
>> 04:00.4 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and
>> Audio Decoder [IR Port] (rev 05)
>>         Subsystem: Hauppauge computer works Inc. Unknown device 9202
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- =20=

>> ParErr-
>> Stepping- SERR- FastB2B-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium =20
>> >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 32 (1500ns min, 63750ns max), Cache Line Size: 32 =20=

>> bytes
>>         Interrupt: pin A routed to IRQ 7
>>         Region 0: Memory at e8000000 (32-bit, non-prefetchable) =20
>> [size=3D16M]
>>         Capabilities: [4c] Power Management version 2
>>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>>
>> I installed v4l and now have a /dev/dvb/adapter0 directory
>> demux0  dvr0  frontend0  net0
>>
>> I should note that the items in that directory are colored yellow =20
>> with
>> black background (perhaps this is indicating something related to the
>> problem?
>>
>> When I use scan I get this
>>
>> scan -a 0 /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E
>> scanning /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> initial transponder 12551500 V 22000000 5
>>   >>> tune to: 12551:v:0:22000
>> WARNING: >>> tuning failed!!!
>>   >>> tune to: 12551:v:0:22000 (tuning failed)
>> WARNING: >>> tuning failed!!!
>> ERROR: initial tuning failed
>> dumping lists (0 services)
>> Done.
>>
>>
>> If I connect the cable to a decoder + tv I get all the channels and
>> perfect image.
>> I'm using a dual / twin LNB. Dual for Astra 19.2 E and 23.5 E with 2
>> connectors.
>>
>> I did get it to work on my previous computer.
>>
>>
>> Any ideas?
>>
>> Timothy.
>> -----BEGIN PGP SIGNATURE-----
>> Version: GnuPG v1.4.7 (Darwin)
>>
>> iD8DBQFH3FDS+j5y+etesF8RAldeAKDeRHdC3YqDZNBze975O5peeRjILgCeNQqV
>> CukiOWQomn8Ctkn2ErrQMI4=3D
>> =3DQbCX
>> -----END PGP SIGNATURE-----
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>
>
>


--Apple-Mail-6--194093842
Content-Type: text/html;
	charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; ">I just tested the card on =
Windows Vista and it works. Altough I'm only getting a limited ammount =
of channels<div>but had the same problem with my other card so that's =
probably not card related. (My TV decoder gets all =
channels)</div><div><br class=3D"webkit-block-placeholder"></div><div><br =
class=3D"webkit-block-placeholder"></div><div>Timothy.<br><div><div>On =
17 Mar 2008, at 08:01, joris abadie wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite">Since your =
post, I try with feisty and gutsy, the nova-S PCI and it is the same, no =
problem. Maybe your card is broken or something with your PC. Can you =
give me dmesg ?<br><br><br><div><span class=3D"gmail_quote">2008/3/17, =
Timothy Parez &lt;<a =
href=3D"mailto:timothyparez@gmail.com">timothyparez@gmail.com</a>&gt;:</sp=
an><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid =
rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"> <div =
style=3D""><div>Hi,</div><div><br></div><div>I put the card in a new =
computer and installed Ubuntu Hardy, the latest preview.</div><div>The =
adapter is recognized so I installed =
dvb-utils.</div><div><br></div><div>Then I executed</div> <div>scan =
/usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-28.2E</div><div><br></d=
iv><div>The result was the same</div><div><br></div><div>WARNING =
&gt;&gt;&gt; tuning failed!</div><div><br></div><span =
class=3D"sg"><div><br> </div><div>Timothy.&nbsp;<span =
style=3D"white-space: pre;">	</span></div></span><div><span class=3D"e"=
 id=3D"q_118b9dd8502f67f8_2"><div><br></div><br><div><div>On 16 Mar =
2008, at 20:33, joris abadie wrote:</div><br><blockquote type=3D"cite"> =
Bonjour,<br>j'ai quatre satellites sur nova-S ( Astra 19=B0, hotbird ... =
) et tout s'est install=E9 tout seul.<br>Every thing is OK with HARDY no =
install to do ; me-tv or kaffeine have the chanels very =
good<br><br><div> <span class=3D"gmail_quote">2008/3/15, Timothy Parez =
&lt;<a href=3D"mailto:timothyparez@gmail.com" target=3D"_blank" =
onclick=3D"return =
top.js.OpenExtLink(window,event,this)">timothyparez@gmail.com</a>&gt;:</sp=
an><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid =
rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"> =
-----BEGIN PGP SIGNED MESSAGE-----<br> Hash: SHA1<br> <br> Hi,<br> <br> =
The output of lspci -vvv on my computer looks like this:<br> <br> =
04:00.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI =
Video<br> and Audio Decoder (rev 05)<br> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Subsystem: Hauppauge =
computer works Inc. Nova-S-Plus =
DVB-S<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Control: I/O- =
Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-<br> Stepping- =
SERR- =
FastB2B-<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Status: Cap+ =
66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium &gt;TAbort-<br> &lt;TAbort- =
&lt;MAbort- &gt;SERR- =
&lt;PERR-<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Latency: 32 =
(5000ns min, 13750ns max), Cache Line Size: 32 =
bytes<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Interrupt: pin =
A routed to IRQ =
20<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Region 0: Memory =
at e5000000 (32-bit, non-prefetchable) [size=3D16M]<br> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Capabilities: [44] Vital =
Product =
Data<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Capabilities: =
[4c] Power Management version =
2<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;Flags: PMEClk- DSI+ D1- D2- =
AuxCurrent=3D0mA<br> =
PME(D0-,D1-,D2-,D3hot-,D3cold-)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Status: D0 =
PME-Enable- DSel=3D0 DScale=3D0 PME-<br> <br> 04:00.1 Multimedia =
controller: Conexant CX23880/1/2/3 PCI Video and<br> Audio Decoder =
[Audio Port] (rev =
05)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Subsystem: =
Hauppauge computer works Inc. Unknown device =
9202<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Control: I/O- =
Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-<br> Stepping- =
SERR- =
FastB2B-<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Status: Cap+ =
66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium &gt;TAbort-<br> &lt;TAbort- =
&lt;MAbort- &gt;SERR- =
&lt;PERR-<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Latency: 32 =
(1000ns min, 63750ns max), Cache Line Size: 32 bytes<br> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Interrupt: pin A routed =
to IRQ 20<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Region 0: =
Memory at e6000000 (32-bit, non-prefetchable) =
[size=3D16M]<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Capabiliti=
es: [4c] Power Management version =
2<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;Flags: PMEClk- DSI+ D1- D2- =
AuxCurrent=3D0mA<br> =
PME(D0-,D1-,D2-,D3hot-,D3cold-)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Status: D0 =
PME-Enable- DSel=3D0 DScale=3D0 PME-<br> <br> 04:00.2 Multimedia =
controller: Conexant CX23880/1/2/3 PCI Video and<br> Audio Decoder [MPEG =
Port] (rev =
05)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Subsystem: =
Hauppauge computer works Inc. Unknown device 9202<br> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Control: I/O- Mem+ =
BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-<br> Stepping- SERR- =
FastB2B-<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Status: Cap+ =
66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium &gt;TAbort-<br> &lt;TAbort- =
&lt;MAbort- &gt;SERR- &lt;PERR-<br> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Latency: 32 (1500ns min, =
22000ns max), Cache Line Size: 32 =
bytes<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Interrupt: pin =
A routed to IRQ =
20<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Region 0: Memory =
at e7000000 (32-bit, non-prefetchable) =
[size=3D16M]<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Capabiliti=
es: [4c] Power Management version 2<br> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA<br> =
PME(D0-,D1-,D2-,D3hot-,D3cold-)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Status: D0 =
PME-Enable- DSel=3D0 DScale=3D0 PME-<br> <br> 04:00.4 Multimedia =
controller: Conexant CX23880/1/2/3 PCI Video and<br> Audio Decoder [IR =
Port] (rev =
05)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Subsystem: =
Hauppauge computer works Inc. Unknown device =
9202<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Control: I/O- =
Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-<br> Stepping- =
SERR- =
FastB2B-<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Status: Cap+ =
66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium &gt;TAbort-<br> &lt;TAbort- =
&lt;MAbort- &gt;SERR- =
&lt;PERR-<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Latency: 32 =
(1500ns min, 63750ns max), Cache Line Size: 32 =
bytes<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Interrupt: pin =
A routed to IRQ =
7<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Region 0: Memory at =
e8000000 (32-bit, non-prefetchable) [size=3D16M]<br> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Capabilities: [4c] Power =
Management version =
2<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;Flags: PMEClk- DSI+ D1- D2- =
AuxCurrent=3D0mA<br> =
PME(D0-,D1-,D2-,D3hot-,D3cold-)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Status: D0 =
PME-Enable- DSel=3D0 DScale=3D0 PME-<br> <br> I installed v4l and now =
have a /dev/dvb/adapter0 directory<br> =
demux0&nbsp;&nbsp;dvr0&nbsp;&nbsp;frontend0&nbsp;&nbsp;net0<br> <br> I =
should note that the items in that directory are colored yellow with<br> =
black background (perhaps this is indicating something related to =
the<br> problem?<br> <br> When I use scan I get this<br> <br> scan -a 0 =
/usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E<br> scanning =
/usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E<br> using =
'/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'<br> initial =
transponder 12551500 V 22000000 5<br>&nbsp;&nbsp;&gt;&gt;&gt; tune to: =
12551:v:0:22000<br> WARNING: &gt;&gt;&gt; tuning =
failed!!!<br>&nbsp;&nbsp;&gt;&gt;&gt; tune to: 12551:v:0:22000 (tuning =
failed)<br> WARNING: &gt;&gt;&gt; tuning failed!!!<br> ERROR: initial =
tuning failed<br> dumping lists (0 services)<br> Done.<br> <br> <br> If =
I connect the cable to a decoder + tv I get all the channels and<br> =
perfect image.<br> I'm using a dual / twin LNB. Dual for Astra 19.2 E =
and 23.5 E with 2<br> connectors.<br> <br> I did get it to work on my =
previous computer.<br> <br> <br> Any ideas?<br> <br> Timothy.<br> =
-----BEGIN PGP SIGNATURE-----<br> Version: GnuPG v1.4.7 (Darwin)<br> =
<br> =
iD8DBQFH3FDS+j5y+etesF8RAldeAKDeRHdC3YqDZNBze975O5peeRjILgCeNQqV<br> =
CukiOWQomn8Ctkn2ErrQMI4=3D<br> =3DQbCX<br> -----END PGP =
SIGNATURE-----<br> <br> =
_______________________________________________<br> linux-dvb mailing =
list<br> <a href=3D"mailto:linux-dvb@linuxtv.org" target=3D"_blank" =
onclick=3D"return =
top.js.OpenExtLink(window,event,this)">linux-dvb@linuxtv.org</a><br> <a =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" =
target=3D"_blank" onclick=3D"return =
top.js.OpenExtLink(window,event,this)">http://www.linuxtv.org/cgi-bin/mail=
man/listinfo/linux-dvb</a><br> </blockquote></div> =
<br></blockquote></div><br></span></div></div><br =
clear=3D"all"></blockquote></div><br></blockquote></div><br></div></body><=
/html>=

--Apple-Mail-6--194093842--

--Apple-Mail-7--194093792
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)

iD8DBQFH3jrE+j5y+etesF8RAu8vAKCQXIyXg1VvIHcl6FUc8gR8GSakeACdGbJs
rsaeumoG2QMeSTHQoM4aoGc=
=UXEE
-----END PGP SIGNATURE-----

--Apple-Mail-7--194093792--


--===============0544227665==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0544227665==--
