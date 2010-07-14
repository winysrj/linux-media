Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <hferraggreat@gmail.com>) id 1OZ1Cv-0001bm-PG
	for linux-dvb@linuxtv.org; Wed, 14 Jul 2010 14:37:02 +0200
Received: from mail-wy0-f182.google.com ([74.125.82.182])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OZ1Cu-0003bo-5n; Wed, 14 Jul 2010 14:37:01 +0200
Received: by wyf22 with SMTP id 22so1524347wyf.41
	for <linux-dvb@linuxtv.org>; Wed, 14 Jul 2010 05:37:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim0hthD272S1Z3CX-CEUMyAwF__Od0RBIzh0-zk@mail.gmail.com>
References: <4C3CB05E.3080002@gmail.com> <4C3CB704.1040908@ginder.xs4all.nl>
	<AANLkTim0hthD272S1Z3CX-CEUMyAwF__Od0RBIzh0-zk@mail.gmail.com>
Date: Wed, 14 Jul 2010 14:36:59 +0200
Message-ID: <AANLkTikpaA8qLjThqwsSQUpf9jYCcogjIMJvEkNdCD74@mail.gmail.com>
From: ferrag hamza <hferraggreat@gmail.com>
To: Hans Houwaard <hans@ginder.xs4all.nl>
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] TeVii S470 Tunning Issue (Kernel 2.6.27-21)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1025142428=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1025142428==
Content-Type: multipart/alternative; boundary=00163646be9ef4d8e5048b583d35

--00163646be9ef4d8e5048b583d35
Content-Type: text/plain; charset=ISO-8859-1

Hi Hans,

Thanks for your quick feedback.

Any other suggestions guys ? .


Thanks in advance.

Hamza Ferrag.

On Wed, Jul 14, 2010 at 2:34 PM, ferrag hamza <hferraggreat@gmail.com>wrote:

> Hi Hans,
>
>
>
> On Tue, Jul 13, 2010 at 8:57 PM, Hans Houwaard <hans@ginder.xs4all.nl>wrote:
>
>> I don't really know why, but it happens sometimes on my machine with the
>> same card as well. When I have problems, I power off the computer and then
>> restart it again. The card will not properly load or function untill I do.
>> There is probably some hardware lock that needs to be reset by powering off
>> the card.
>>
>> The loading of the firmware sometimes takes a couple of seconds in my
>> machine, it's not very fast. Besides check if the card, which is on a PCI-1x
>> slot, doesn't share an IRQ with the onboard soundcard. That will seriously
>> effect the performance of both the card and the sound.
>>
>> Good luck,
>>
>> Hans
>>
>> Op 13-07-10 20:28, Hamza Ferrag schreef:
>>
>>> Hi all,
>>>
>>> I am trying to install a 'Tevii S470' card  from TeVii technology as
>>> described  here http://linuxtv.org/wiki/index.php/TeVii_S470.
>>>
>>> My configuration is :
>>>
>>> - intel x86 platform
>>> - Kernel 2.6.27-21
>>> - tevii_ds3000.tar.gz (firmware archive from
>>> http://tevii.com/tevii_ds3000.tar.gz ),
>>> - s2-liplianin  mercurial sources ( from
>>> http://mercurial.intuxication.org/hg/s2-liplianin)last<http://mercurial.intuxication.org/hg/s2-liplianin%29last>changes at 05/29/2010,
>>>
>>> All work fine i.e drivers/firmware installation after madprobe a right
>>> modules.
>>>
>>> # lsmod
>>> Module                  Size  Used by    Not tainted
>>> cx23885                82416  0
>>> tveeprom                9348  1 cx23885
>>> btcx_risc               1928  1 cx23885
>>> cx2341x                 7748  1 cx23885
>>> ir_common              23936  1 cx23885
>>> videobuf_dma_sg         5060  1 cx23885
>>> ir_core                 3596  2 cx23885,ir_common
>>> v4l2_common             8896  2 cx23885,cx2341x
>>> videodev               25376  2 cx23885,v4l2_common
>>> videobuf_dvb            2820  1 cx23885
>>> videobuf_core           8388  3 cx23885,videobuf_dma_sg,videobuf_dvb
>>> lnbp21                  1024  0
>>> dvb_core               54832  2 cx23885,videobuf_dvb
>>> ds3000                  9668  1
>>>
>>>
>>> # dmesg
>>> Linux video capture interface: v2.00
>>> cx23885 driver version 0.0.2 loaded
>>> CORE cx23885[0]: subsystem: d470:9022, board: TeVii S470
>>> [card=15,autodetected]
>>> cx23885_dvb_register() allocating 1 frontend(s)
>>> cx23885[0]: cx23885 based dvb card
>>> DS3000 chip version: 0.192 attached.
>>> DVB: registering new adapter (cx23885[0])
>>> DVB: registering adapter 0 frontend 0 (Montage Technology
>>> DS3000/TS2020)...
>>> cx23885_dev_checkrevision() Hardware revision = 0xb0
>>> cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 11, latency: 0, mmio:
>>> 0xdf800000
>>> cx23885 0000:03:00.0: setting latency timer to 64
>>> tun: Universal TUN/TAP device driver, 1.6
>>>
>>>
>>>
>>> A problem appear when tunning card using szap-s2 :
>>>
>>> # szap-s2 szap-s2 -c /root/channels.conf -x -M 5 -C 89 -l 9750 -S 1 MyCh
>>>
>>> reading channels from file '/root/channels.conf'
>>> zapping to 1 'MyCh':
>>> delivery DVB-S2, modulation 8PSK
>>> sat 0, frequency 8420 MHz V, symbolrate 29400000, coderate 8/9,rolloff
>>> 0.35
>>> vpid 0x0286, apid 0x1fff, sid 0x0000
>>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>> ds3000_firmware_ondemand: Waiting for firmware upload
>>> (dvb-fe-ds3000.fw)...
>>> firmware: requesting dvb-fe-ds3000.fw
>>> ds3000_firmware_ondemand: Waiting for firmware upload(2)...
>>> ds3000_firmware_ondemand: No firmware uploaded (timeout or file not
>>> found?)
>>> ds3000_tune: Unable initialise the firmware
>>>
>>> Apparently it can't locate a firmware file,  yet :
>>>
>>> # ls -l  /lib/firmware/
>>> -rwxr-xr-x    1 root     root         8192 May  3 07:09 dvb-fe-ds3000.fw
>>>
>>>
>>> Any ideas why this happens?
>>>
>>> Thanks and best regards,
>>>
>>> Hamza Ferrag
>>>
>>>
>>> _______________________________________________
>>> linux-dvb users mailing list
>>> For V4L/DVB development, please use instead linux-media@vger.kernel.org
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>
>>
>

--00163646be9ef4d8e5048b583d35
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Hans,<br><br>Thanks for your quick feedback.<br><br>Any other suggestion=
s guys ? .<br><br><br>Thanks in advance.<br><br>Hamza Ferrag.<br><br><div c=
lass=3D"gmail_quote">On Wed, Jul 14, 2010 at 2:34 PM, ferrag hamza <span di=
r=3D"ltr">&lt;<a href=3D"mailto:hferraggreat@gmail.com">hferraggreat@gmail.=
com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hi Hans,<br><br><=
br><br><div class=3D"gmail_quote"><div class=3D"im">On Tue, Jul 13, 2010 at=
 8:57 PM, Hans Houwaard <span dir=3D"ltr">&lt;<a href=3D"mailto:hans@ginder=
.xs4all.nl" target=3D"_blank">hans@ginder.xs4all.nl</a>&gt;</span> wrote:<b=
r>
</div><div><div></div><div class=3D"h5"><blockquote class=3D"gmail_quote" s=
tyle=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8e=
x; padding-left: 1ex;">
I don&#39;t really know why, but it happens sometimes on my machine with th=
e same card as well. When I have problems, I power off the computer and the=
n restart it again. The card will not properly load or function untill I do=
. There is probably some hardware lock that needs to be reset by powering o=
ff the card.<br>


<br>
The loading of the firmware sometimes takes a couple of seconds in my machi=
ne, it&#39;s not very fast. Besides check if the card, which is on a PCI-1x=
 slot, doesn&#39;t share an IRQ with the onboard soundcard. That will serio=
usly effect the performance of both the card and the sound.<br>


<br>
Good luck,<br>
<br>
Hans<br>
<br>
Op 13-07-10 20:28, Hamza Ferrag schreef:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div><div></div><=
div>
Hi all,<br>
<br>
I am trying to install a &#39;Tevii S470&#39; card =A0from TeVii technology=
 as described =A0here <a href=3D"http://linuxtv.org/wiki/index.php/TeVii_S4=
70" target=3D"_blank">http://linuxtv.org/wiki/index.php/TeVii_S470</a>.<br>
<br>
My configuration is :<br>
<br>
- intel x86 platform<br>
- Kernel 2.6.27-21<br>
- tevii_ds3000.tar.gz (firmware archive from <a href=3D"http://tevii.com/te=
vii_ds3000.tar.gz" target=3D"_blank">http://tevii.com/tevii_ds3000.tar.gz</=
a> ),<br>
- s2-liplianin =A0mercurial sources ( from <a href=3D"http://mercurial.intu=
xication.org/hg/s2-liplianin%29last" target=3D"_blank">http://mercurial.int=
uxication.org/hg/s2-liplianin)last</a> changes at 05/29/2010,<br>
<br>
All work fine i.e drivers/firmware installation after madprobe a right modu=
les.<br>
<br>
# lsmod<br>
Module =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used by =A0 =A0Not tainte=
d<br>
cx23885 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A082416 =A00<br>
tveeprom =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A09348 =A01 cx23885<br>
btcx_risc =A0 =A0 =A0 =A0 =A0 =A0 =A0 1928 =A01 cx23885<br>
cx2341x =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 7748 =A01 cx23885<br>
ir_common =A0 =A0 =A0 =A0 =A0 =A0 =A023936 =A01 cx23885<br>
videobuf_dma_sg =A0 =A0 =A0 =A0 5060 =A01 cx23885<br>
ir_core =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 3596 =A02 cx23885,ir_common<br>
v4l2_common =A0 =A0 =A0 =A0 =A0 =A0 8896 =A02 cx23885,cx2341x<br>
videodev =A0 =A0 =A0 =A0 =A0 =A0 =A0 25376 =A02 cx23885,v4l2_common<br>
videobuf_dvb =A0 =A0 =A0 =A0 =A0 =A02820 =A01 cx23885<br>
videobuf_core =A0 =A0 =A0 =A0 =A0 8388 =A03 cx23885,videobuf_dma_sg,videobu=
f_dvb<br>
lnbp21 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01024 =A00<br>
dvb_core =A0 =A0 =A0 =A0 =A0 =A0 =A0 54832 =A02 cx23885,videobuf_dvb<br>
ds3000 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A09668 =A01<br>
<br>
<br>
# dmesg<br>
Linux video capture interface: v2.00<br>
cx23885 driver version 0.0.2 loaded<br>
CORE cx23885[0]: subsystem: d470:9022, board: TeVii S470 [card=3D15,autodet=
ected]<br>
cx23885_dvb_register() allocating 1 frontend(s)<br>
cx23885[0]: cx23885 based dvb card<br>
DS3000 chip version: 0.192 attached.<br>
DVB: registering new adapter (cx23885[0])<br>
DVB: registering adapter 0 frontend 0 (Montage Technology DS3000/TS2020)...=
<br>
cx23885_dev_checkrevision() Hardware revision =3D 0xb0<br>
cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 11, latency: 0, mmio: 0xd=
f800000<br>
cx23885 0000:03:00.0: setting latency timer to 64<br>
tun: Universal TUN/TAP device driver, 1.6<br>
<br>
<br>
<br>
A problem appear when tunning card using szap-s2 :<br>
<br>
# szap-s2 szap-s2 -c /root/channels.conf -x -M 5 -C 89 -l 9750 -S 1 MyCh<br=
>
<br>
reading channels from file &#39;/root/channels.conf&#39;<br>
zapping to 1 &#39;MyCh&#39;:<br>
delivery DVB-S2, modulation 8PSK<br>
sat 0, frequency 8420 MHz V, symbolrate 29400000, coderate 8/9,rolloff 0.35=
<br>
vpid 0x0286, apid 0x1fff, sid 0x0000<br>
using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demu=
x0&#39;<br>
ds3000_firmware_ondemand: Waiting for firmware upload (dvb-fe-ds3000.fw)...=
<br>
firmware: requesting dvb-fe-ds3000.fw<br>
ds3000_firmware_ondemand: Waiting for firmware upload(2)...<br>
ds3000_firmware_ondemand: No firmware uploaded (timeout or file not found?)=
<br>
ds3000_tune: Unable initialise the firmware<br>
<br>
Apparently it can&#39;t locate a firmware file, =A0yet :<br>
<br>
# ls -l =A0/lib/firmware/<br>
-rwxr-xr-x =A0 =A01 root =A0 =A0 root =A0 =A0 =A0 =A0 8192 May =A03 07:09 d=
vb-fe-ds3000.fw<br>
<br>
<br>
Any ideas why this happens?<br>
<br>
Thanks and best regards,<br>
<br>
Hamza Ferrag<br>
<br>
<br></div></div>
_______________________________________________<br>
linux-dvb users mailing list<br>
For V4L/DVB development, please use instead <a href=3D"mailto:linux-media@v=
ger.kernel.org" target=3D"_blank">linux-media@vger.kernel.org</a><br>
<a href=3D"mailto:linux-dvb@linuxtv.org" target=3D"_blank">linux-dvb@linuxt=
v.org</a><br>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><=
br>
</blockquote>
</blockquote></div></div></div><br>
</blockquote></div><br>

--00163646be9ef4d8e5048b583d35--


--===============1025142428==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1025142428==--
