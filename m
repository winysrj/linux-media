Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mikko.reijo.makinen@gmail.com>) id 1KBqrb-0004UP-ME
	for linux-dvb@linuxtv.org; Thu, 26 Jun 2008 14:46:13 +0200
Received: by ug-out-1314.google.com with SMTP id m3so250545uge.20
	for <linux-dvb@linuxtv.org>; Thu, 26 Jun 2008 05:46:08 -0700 (PDT)
Message-ID: <9c84b2480806260546r5a30e115v62d43fa4047add68@mail.gmail.com>
Date: Thu, 26 Jun 2008 15:46:08 +0300
From: "=?ISO-8859-1?Q?Mikko_M=E4kinen?=" <mikko.reijo.makinen@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] Terratec Cinergy C HD (1822:4e35) SOLVED (at least
	PARTIALLY)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2114974972=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2114974972==
Content-Type: multipart/alternative;
	boundary="----=_Part_5454_16902032.1214484368158"

------=_Part_5454_16902032.1214484368158
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello again!

With kind help from Magnus H=F6rlin I was able to get past the problem with
different subsystem id's. He suggested testing the card in another PCI-slot
and/or taking other cards away. I removed a 3Com NIC and put the Cinergy in
another slot and voil=E1: frontend got recognized during bootup:

found a VP-2040 PCI DVB-C device on (00:07.0),
Mantis Rev 1 [153b:1178], irq: 19, latency: 32
memory: 0xfc000000, mmio: 0xf89aa000
MAC Address=3D[00:08:ca:1c:82:c0]
mantis_alloc_buffers (0): DMA=3D0x36cc0000 cpu=3D0xf6cc0000 size=3D65536
mantis_alloc_buffers (0): RISC=3D0x1fb88000 cpu=3D0xdfb88000 size=3D1000
DVB: registering new adapter (Mantis dvb adapter)
ACPI: Sleep Button (CM) [SLPB]
mantis_frontend_init (0): Probing for CU1216 (DVB-C)
mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10023) @
0x0c
mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach
success
DVB: registering frontend 0 (Philips TDA10023 DVB-C)...
mantis_ca_init (0): Registering EN50221 device
mantis_ca_init (0): Registered EN50221 device
mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface

To make this even stranger, I placed the 3Com NIC and Cinergy back to their
original slots and rebooted the machine. I was waiting for the problem to
reappear, but NO; frontend was recognized and subsystem id's were similar n=
o
matter which options I used with lspci.

Now scanning doesn't seem to work, but that's another story.

Mikko M=E4kinen


2008/6/26 Mikko M=E4kinen <mikko.reijo.makinen@gmail.com>:

> Hi again,
>
> I included wrong kind of lspci output; subsystem id didn't show up. But
> here come the right ones:
>
> lspci -d 1822:4e35 -vn gives the following:
>
> administrator@hydra:~$ administrator@hydra:~$ lspci -d 1822:4e35 -vn
> 00:08.0 0480: 1822:4e35 (rev 01)
>     Subsystem: 153b:1178
>     Flags: bus master, medium devsel, latency 32, IRQ 20
>     Memory at fc020000 (32-bit, prefetchable) [size=3D4K]
>
> but without -d option, which is lspci -vn:
>
> administrator@hydra:~$ lspci -vn
> .
> .
> .
> 00:08.0 0480: 1822:4e35 (rev 01) (prog-if 02)
>     Subsystem: 173b:1178
>     Flags: bus master, fast Back2Back, medium devsel, latency 34, IRQ 20
>     Memory at fc020000 (32-bit, prefetchable) [size=3D4K]
>     Memory at <ignored> (32-bit, non-prefetchable)
>     Memory at <ignored> (32-bit, non-prefetchable)
>     Memory at <ignored> (32-bit, non-prefetchable)
>     Memory at <ignored> (32-bit, non-prefetchable)
>     Memory at <ignored> (32-bit, non-prefetchable)
>     Expansion ROM at <unassigned> [disabled]
> .
> .
> .
>
> You see, the subsystem ids differ: 153b:1178 and 173b:1178. I don't know
> what that means, but hopefully someone else does.
>
> lspci -vnn says:
>
> 00:08.0 Multimedia controller [0480]: Twinhan Technology Co. Ltd Mantis D=
TV
> PCI Bridge Controller [Ver 1.0] [1822:4e35] (rev 01) (prog-if 02)
>     Subsystem: Altima (nee Broadcom) Unknown device [173b:1178]
>
> Is it possible to get this card working in linux (in the near future)?
>
> Mikko M=E4kinen
>
> 2008/6/25 Mikko M=E4kinen <mikko.reijo.makinen@gmail.com>:
>
> Hello everybody,
>>
>> I've been trying to get my recently (yesterday) bought dvb-c tuner worki=
ng
>> under Ubuntu Hardy. Installed drivers from http://www.jusst.de/hg/mantis=
,
>> and the /dev/dvb got populated, but without frontend.
>>
>>
>> Output from lspci:
>>
>> administrator@hydra:~$ lspci -d 1822:4e35 -vv
>> 00:08.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
>> Bridge Controller [Ver 1.0] (rev 01)
>>     Subsystem: TERRATEC Electronic GmbH Unknown device 1178
>>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B-
>>     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-
>> <TAbort+ <MAbort- >SERR+ <PERR+
>>     Latency: 32 (2000ns min, 63750ns max)
>>     Interrupt: pin A routed to IRQ 20
>>     Region 0: Memory at fc020000 (32-bit, prefetchable) [size=3D4K]
>>
>> PCI id seems to have changed from the earlier Cinergy C cards.
>>
>>  Output (partial) from dmesg:
>>
>> [   33.894498] found a VP-2040 PCI DVB-C device on (00:08.0),
>> [   33.894502]     Mantis Rev 1 [153b:1178], irq: 20, latency: 32
>> [   33.894507]     memory: 0xfc020000, mmio: 0xf8972000
>> [   33.897204]     MAC Address=3D[00:08:c8:1c:80:c0]
>> [   33.897246] mantis_alloc_buffers (0): DMA=3D0x374c0000 cpu=3D0xf74c00=
00
>> size=3D65536
>> [   33.897253] mantis_alloc_buffers (0): RISC=3D0x1f9e3000 cpu=3D0xdf9e3=
000
>> size=3D1000
>> [   33.897258] DVB: registering new adapter (Mantis dvb adapter)
>> [   33.926286] input: Power Button (FF) as /devices/virtual/input/input4
>> [   33.944481] ACPI: Power Button (FF) [PWRF]
>> [   33.944568] input: Power Button (CM) as /devices/virtual/input/input5
>> [   33.976486] ACPI: Power Button (CM) [PWRB]
>> [   33.976625] input: Sleep Button (CM) as /devices/virtual/input/input6
>> [   33.988428] ACPI: Sleep Button (CM) [SLPB]
>> [   34.416113] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
>> [   34.418214] mantis_frontend_init (0): !!! NO Frontends found !!!
>> [   34.418220] mantis_ca_init (0): Registering EN50221 device
>> [   34.475764] mantis_ca_init (0): Registered EN50221 device
>> [   34.475777] mantis_hif_init (0): Adapter(0) Initializing Mantis Host
>> Interface
>>
>> Even I managed to notice one line stating: "!!! NO Frontends found !!!",
>> so I guess it's no wonder it isn't working.
>>
>> Does anyone have a clue what I should try next? Or has anyone had succes=
s
>> with this card. I couldn't find earlier models, like cinergy 1200-c, or =
even
>> newer, anywhere. I'm supposed to build a DVB to IP streaming machine for=
 a
>> school, so I would also be happy if someone knew any other available DVB=
-C
>> cards working under linux.
>>
>> Best regards,
>> Mikko M=E4kinen
>>
>>
>>
>>
>>
>>
>

------=_Part_5454_16902032.1214484368158
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello again!<br><br>With kind help from Magnus H=F6rlin I was able to get p=
ast the problem with different subsystem id&#39;s. He suggested testing the=
 card in another PCI-slot and/or taking other cards away. I removed a 3Com =
NIC and put the Cinergy in another slot and voil=E1: frontend got recognize=
d during bootup:<br>
<br>found a VP-2040 PCI DVB-C device on (00:07.0),<br>Mantis Rev 1 [153b:11=
78], irq: 19, latency: 32<br>memory: 0xfc000000, mmio: 0xf89aa000<br>MAC Ad=
dress=3D[00:08:ca:1c:82:c0]<br>mantis_alloc_buffers (0): DMA=3D0x36cc0000 c=
pu=3D0xf6cc0000 size=3D65536<br>
mantis_alloc_buffers (0): RISC=3D0x1fb88000 cpu=3D0xdfb88000 size=3D1000<br=
>DVB: registering new adapter (Mantis dvb adapter)<br>ACPI: Sleep Button (C=
M) [SLPB]<br>mantis_frontend_init (0): Probing for CU1216 (DVB-C)<br>mantis=
_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10023) @ 0x0c<b=
r>
mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach succe=
ss<br>DVB: registering frontend 0 (Philips TDA10023 DVB-C)...<br>mantis_ca_=
init (0): Registering EN50221 device<br>mantis_ca_init (0): Registered EN50=
221 device<br>
mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface<br><br>T=
o make this even stranger, I placed the 3Com NIC and Cinergy back to their =
original slots and rebooted the machine. I was waiting for the problem to r=
eappear, but NO; frontend was recognized and subsystem id&#39;s were simila=
r no matter which options I used with lspci.<br>
<br>Now scanning doesn&#39;t seem to work, but that&#39;s another story. <b=
r><br>Mikko M=E4kinen<br><br><br><div class=3D"gmail_quote">2008/6/26 Mikko=
 M=E4kinen &lt;<a href=3D"mailto:mikko.reijo.makinen@gmail.com">mikko.reijo=
.makinen@gmail.com</a>&gt;:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hi again,<br><br>=
I included wrong kind of lspci output; subsystem id didn&#39;t show up. But=
 here come the right ones:<br>
<br>lspci -d 1822:4e35 -vn gives the following:<br><br>administrator@hydra:=
~$ administrator@hydra:~$ lspci -d 1822:4e35 -vn<br>
00:08.0 0480: 1822:4e35 (rev 01)<br>&nbsp;&nbsp;&nbsp; Subsystem: 153b:1178=
<br>&nbsp;&nbsp;&nbsp; Flags: bus master, medium devsel, latency 32, IRQ 20=
<div class=3D"Ih2E3d"><br>
&nbsp;&nbsp;&nbsp; Memory at fc020000 (32-bit, prefetchable) [size=3D4K]<br=
><br></div>but without -d option, which is lspci -vn:<br><br>administrator@=
hydra:~$ lspci -vn<br>.<br>.<br>.<br>00:08.0 0480: 1822:4e35 (rev 01) (prog=
-if 02)<br>&nbsp;&nbsp;&nbsp; Subsystem: 173b:1178<br>


&nbsp;&nbsp;&nbsp; Flags: bus master, fast Back2Back, medium devsel, latenc=
y 34, IRQ 20<div class=3D"Ih2E3d"><br>&nbsp;&nbsp;&nbsp; Memory at fc020000=
 (32-bit, prefetchable) [size=3D4K]<br></div>&nbsp;&nbsp;&nbsp; Memory at &=
lt;ignored&gt; (32-bit, non-prefetchable)<br>
&nbsp;&nbsp;&nbsp; Memory at &lt;ignored&gt; (32-bit, non-prefetchable)<br>

&nbsp;&nbsp;&nbsp; Memory at &lt;ignored&gt; (32-bit, non-prefetchable)<br>=
&nbsp;&nbsp;&nbsp; Memory at &lt;ignored&gt; (32-bit, non-prefetchable)<br>=
&nbsp;&nbsp;&nbsp; Memory at &lt;ignored&gt; (32-bit, non-prefetchable)<br>=
&nbsp;&nbsp;&nbsp; Expansion ROM at &lt;unassigned&gt; [disabled]<br>


.<br>.<br>.<br><br>You see, the subsystem ids differ: 153b:1178 and 173b:11=
78. I don&#39;t know what that means, but hopefully someone else does. <br>=
<br>lspci -vnn says:<br><br>00:08.0 Multimedia controller [0480]: Twinhan T=
echnology Co. Ltd Mantis DTV PCI Bridge Controller [Ver 1.0] [1822:4e35] (r=
ev 01) (prog-if 02)<br>

&nbsp;&nbsp;&nbsp; Subsystem: Altima (nee Broadcom) Unknown device [173b:11=
78]<br><br>Is it possible to get this card working in linux (in the near fu=
ture)?<br><br>Mikko M=E4kinen<br><br><div class=3D"gmail_quote">2008/6/25 M=
ikko M=E4kinen &lt;<a href=3D"mailto:mikko.reijo.makinen@gmail.com" target=
=3D"_blank">mikko.reijo.makinen@gmail.com</a>&gt;:<div>
<div></div><div class=3D"Wj3C7c"><br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hello everybody, =
<br>&nbsp;<br>I&#39;ve been trying to get my recently (yesterday) bought dv=
b-c tuner working under Ubuntu Hardy. Installed drivers from <a href=3D"htt=
p://www.jusst.de/hg/mantis" target=3D"_blank">http://www.jusst.de/hg/mantis=
</a>, and the /dev/dvb got populated, but without frontend. <br>


<br><br>Output from lspci:<br><br>administrator@hydra:~$ lspci -d 1822:4e35=
 -vv<br>00:08.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DT=
V PCI Bridge Controller [Ver 1.0] (rev 01)<br>&nbsp;&nbsp;&nbsp; Subsystem:=
 TERRATEC Electronic GmbH Unknown device 1178<br>


&nbsp;&nbsp;&nbsp; Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASno=
op- ParErr- Stepping- SERR- FastB2B-<br>&nbsp;&nbsp;&nbsp; Status: Cap- 66M=
Hz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium &gt;TAbort- &lt;TAbort+ &lt;MAbor=
t- &gt;SERR+ &lt;PERR+<br>&nbsp;&nbsp;&nbsp; Latency: 32 (2000ns min, 63750=
ns max)<br>


&nbsp;&nbsp;&nbsp; Interrupt: pin A routed to IRQ 20<br>&nbsp;&nbsp;&nbsp; =
Region 0: Memory at fc020000 (32-bit, prefetchable) [size=3D4K]<br><br>PCI =
id seems to have changed from the earlier Cinergy C cards. <br><br>&nbsp;Ou=
tput (partial) from dmesg:<br><br>


[&nbsp;&nbsp; 33.894498] found a VP-2040 PCI DVB-C device on (00:08.0),<br>=
[&nbsp;&nbsp; 33.894502]&nbsp;&nbsp;&nbsp;&nbsp; Mantis Rev 1 [153b:1178], =
irq: 20, latency: 32<br>[&nbsp;&nbsp; 33.894507]&nbsp;&nbsp;&nbsp;&nbsp; me=
mory: 0xfc020000, mmio: 0xf8972000<br>[&nbsp;&nbsp; 33.897204]&nbsp;&nbsp;&=
nbsp;&nbsp; MAC Address=3D[00:08:c8:1c:80:c0]<br>


[&nbsp;&nbsp; 33.897246] mantis_alloc_buffers (0): DMA=3D0x374c0000 cpu=3D0=
xf74c0000 size=3D65536<br>[&nbsp;&nbsp; 33.897253] mantis_alloc_buffers (0)=
: RISC=3D0x1f9e3000 cpu=3D0xdf9e3000 size=3D1000<br>[&nbsp;&nbsp; 33.897258=
] DVB: registering new adapter (Mantis dvb adapter)<br>


[&nbsp;&nbsp; 33.926286] input: Power Button (FF) as /devices/virtual/input=
/input4<br>[&nbsp;&nbsp; 33.944481] ACPI: Power Button (FF) [PWRF]<br>[&nbs=
p;&nbsp; 33.944568] input: Power Button (CM) as /devices/virtual/input/inpu=
t5<br>[&nbsp;&nbsp; 33.976486] ACPI: Power Button (CM) [PWRB]<br>


[&nbsp;&nbsp; 33.976625] input: Sleep Button (CM) as /devices/virtual/input=
/input6<br>[&nbsp;&nbsp; 33.988428] ACPI: Sleep Button (CM) [SLPB]<br>[&nbs=
p;&nbsp; 34.416113] mantis_frontend_init (0): Probing for CU1216 (DVB-C)<br=
>[&nbsp;&nbsp; 34.418214] mantis_frontend_init (0): !!! NO Frontends found =
!!!<br>


[&nbsp;&nbsp; 34.418220] mantis_ca_init (0): Registering EN50221 device<br>=
[&nbsp;&nbsp; 34.475764] mantis_ca_init (0): Registered EN50221 device<br>[=
&nbsp;&nbsp; 34.475777] mantis_hif_init (0): Adapter(0) Initializing Mantis=
 Host Interface<br><br>Even I managed to notice one line stating: &quot;!!!=
 NO Frontends found !!!&quot;, so I guess it&#39;s no wonder it isn&#39;t w=
orking. <br>


<br>Does anyone have a clue what I should try next? Or has anyone had succe=
ss with this card. I couldn&#39;t find earlier models, like cinergy 1200-c,=
 or even newer, anywhere. I&#39;m supposed to build a DVB to IP streaming m=
achine for a school, so I would also be happy if someone knew any other ava=
ilable DVB-C cards working under linux. <br>


<br>Best regards, <br><font color=3D"#888888">Mikko M=E4kinen<br><br><br>&n=
bsp;<br><br><br>
</font></blockquote></div></div></div><br>
</blockquote></div><br>

------=_Part_5454_16902032.1214484368158--


--===============2114974972==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2114974972==--
