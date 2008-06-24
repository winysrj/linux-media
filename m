Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <websdaleandrew@googlemail.com>) id 1KBDtS-0007C1-Li
	for linux-dvb@linuxtv.org; Tue, 24 Jun 2008 21:09:31 +0200
Received: by fk-out-0910.google.com with SMTP id f40so3194198fka.1
	for <linux-dvb@linuxtv.org>; Tue, 24 Jun 2008 12:09:27 -0700 (PDT)
Message-ID: <e37d7f810806241209y6b1c3e0dn61048cc58922bc68@mail.gmail.com>
Date: Tue, 24 Jun 2008 20:09:26 +0100
From: "Andrew Websdale" <websdaleandrew@googlemail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <9738.212.50.194.254.1214289017.squirrel@webmail.kapsi.fi>
MIME-Version: 1.0
References: <e37d7f810806111512w46a508b0h92047728ba38cac8@mail.gmail.com>
	<e37d7f810806120158g6257b7a9h429dd8b8f885321e@mail.gmail.com>
	<4850F597.9030603@iki.fi>
	<e37d7f810806120619q28bff0d8y8f2d5319187ab6b0@mail.gmail.com>
	<e37d7f810806171229j72aa07cco5f82e4021317ef8f@mail.gmail.com>
	<9188.212.50.194.254.1213898824.squirrel@webmail.kapsi.fi>
	<e37d7f810806191119h76ef8162ia3dc14b350fcd22c@mail.gmail.com>
	<e37d7f810806230414o7b7d589q71bf6ae5d8c9bc4b@mail.gmail.com>
	<e37d7f810806231158l848f2d3hb160f16db38e71a7@mail.gmail.com>
	<9738.212.50.194.254.1214289017.squirrel@webmail.kapsi.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dposh DVB-T USB2.0 seems to not work properly
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1949172985=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1949172985==
Content-Type: multipart/alternative;
	boundary="----=_Part_23918_23616548.1214334566855"

------=_Part_23918_23616548.1214334566855
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/6/24 Antti Palosaari <crope@iki.fi>:

> ma 23.6.2008 21:58 Andrew Websdale kirjoitti:
>
> >> I've tried adding the mt2060 code - it compiles OK & does seem to be
> >> nearly
> >> right,the tuner is being recognised, but I think loading the module
> >> causes
> >> the I2c bit of the kernel to Oops - would an incorrect i2c address cause
> >> this?
> >>
> > Here's my dmesg output:
> > m920x_mt2060_tuner_attach
> > BUG: unable to handle kernel NULL pointer dereference at virtual address
> > 0000006c
>
> because you have passed tuner i2c-address as parameter to the dvb_attach()




I've changed the parameter to '&adap->dev->i2c_adap' & I now get this dmesg
output:

dvb-usb: found a 'Dposh(mt2060 tuner) DVB-T USB2.0' in cold state, will try
to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-dposh-01.fw'
80 0 b0 0
ff
firmware uploaded!
dvb_usb_m920x: probe of 5-1:1.0 failed with error 64
usb 5-1: USB disconnect, address 4
usb 5-1: new high speed USB device using ehci_hcd and address 5
usb 5-1: configuration #1 chosen from 1 choice
Probing for m920x device at interface 0
dvb-usb: found a 'Dposh(mt2060 tuner) DVB-T USB2.0' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (Dposh(mt2060 tuner) DVB-T USB2.0)
m920x_mt352_frontend_attach
DVB: registering frontend 0 (Zarlink MT352 DVB-T)...
m920x_mt2060_tuner_attach
MT2060: successfully identified (IF1 = 1220)
dvb-usb: Dposh(mt2060 tuner) DVB-T USB2.0 successfully initialized and
connected.

so far so good :) , but when I scan with Kaffeine I get this:

Demod init!    //this repeated ~ 30 times

mt352_read_register: readreg error (reg=3, ret==-110)  //then this block or
mt2060 I2C write failed (len=2)                           //similar repeated
until end of scan
mt2060 I2C write failed (len=6)
mt2060 I2C read failed
mt2060 I2C read failed
mt2060 I2C read failed
mt2060 I2C read failed
mt2060 I2C read failed
mt2060 I2C read failed
mt2060 I2C read failed
mt2060 I2C read failed
mt2060 I2C read failed
mt2060 I2C read failed
mt352_write() to reg 51 failed (err = -110)!
mt352_write() to reg 5e failed (err = -110)!


Could this just be due to not getting the .i2c_address set in the
'm920x_mt2060_config' struct correct, or is it another dumb error on my
part?
cheers for the help,
Andrew

------=_Part_23918_23616548.1214334566855
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">2008/6/24 Antti Palosaari &lt;<a href="mailto:crope@iki.fi">crope@iki.fi</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
ma 23.6.2008 21:58 Andrew Websdale kirjoitti:<br>
<div class="Ih2E3d"><br>
&gt;&gt; I&#39;ve tried adding the mt2060 code - it compiles OK &amp; does seem to be<br>
&gt;&gt; nearly<br>
&gt;&gt; right,the tuner is being recognised, but I think loading the module<br>
&gt;&gt; causes<br>
&gt;&gt; the I2c bit of the kernel to Oops - would an incorrect i2c address cause<br>
&gt;&gt; this?<br>
&gt;&gt;<br>
&gt; Here&#39;s my dmesg output:<br>
</div><div class="Ih2E3d">&gt; m920x_mt2060_tuner_attach<br>
&gt; BUG: unable to handle kernel NULL pointer dereference at virtual address<br>
&gt; 0000006c<br>
<br>
</div>because you have passed tuner i2c-address as parameter to the dvb_attach()</blockquote><div><br><br><br>I&#39;ve changed the parameter to &#39;&amp;adap-&gt;dev-&gt;i2c_adap&#39; &amp; I now get this dmesg output:<br>
<br>dvb-usb: found a &#39;Dposh(mt2060 tuner) DVB-T USB2.0&#39; in cold state, will try to load a firmware<br>dvb-usb: downloading firmware from file &#39;dvb-usb-dposh-01.fw&#39;<br>80 0 b0 0<br>ff<br>firmware uploaded!<br>
dvb_usb_m920x: probe of 5-1:1.0 failed with error 64<br>usb 5-1: USB disconnect, address 4<br>usb 5-1: new high speed USB device using ehci_hcd and address 5<br>usb 5-1: configuration #1 chosen from 1 choice<br>Probing for m920x device at interface 0<br>
dvb-usb: found a &#39;Dposh(mt2060 tuner) DVB-T USB2.0&#39; in warm state.<br>dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>DVB: registering new adapter (Dposh(mt2060 tuner) DVB-T USB2.0)<br>
m920x_mt352_frontend_attach<br>DVB: registering frontend 0 (Zarlink MT352 DVB-T)...<br>m920x_mt2060_tuner_attach<br>MT2060: successfully identified (IF1 = 1220)<br>dvb-usb: Dposh(mt2060 tuner) DVB-T USB2.0 successfully initialized and connected.<br>
<br>so far so good :) , but when I scan with Kaffeine I get this:<br><br>Demod init!&nbsp;&nbsp;&nbsp; //this repeated ~ 30 times<br><br>mt352_read_register: readreg error (reg=3, ret==-110)&nbsp; //then this block or<br>mt2060 I2C write failed (len=2)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //similar repeated until end of scan<br>
mt2060 I2C write failed (len=6)<br>mt2060 I2C read failed<br>mt2060 I2C read failed<br>mt2060 I2C read failed<br>mt2060 I2C read failed<br>mt2060 I2C read failed<br>mt2060 I2C read failed<br>mt2060 I2C read failed<br>mt2060 I2C read failed<br>
mt2060 I2C read failed<br>mt2060 I2C read failed<br>mt352_write() to reg 51 failed (err = -110)!<br>mt352_write() to reg 5e failed (err = -110)!<br><br><br>Could this just be due to not getting the .i2c_address set in the &#39;m920x_mt2060_config&#39; struct correct, or is it another dumb error on my part?<br>
cheers for the help,<br>Andrew<br></div></div><br>

------=_Part_23918_23616548.1214334566855--


--===============1949172985==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1949172985==--
