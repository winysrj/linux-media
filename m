Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <amitay@gmail.com>) id 1Jo8r4-0006wX-M5
	for linux-dvb@linuxtv.org; Tue, 22 Apr 2008 05:07:41 +0200
Received: by ti-out-0910.google.com with SMTP id y6so642652tia.13
	for <linux-dvb@linuxtv.org>; Mon, 21 Apr 2008 20:07:33 -0700 (PDT)
Message-ID: <75a6c8000804212007m785f6aa0i2804c56a4796feb0@mail.gmail.com>
Date: Tue, 22 Apr 2008 13:07:26 +1000
From: "Amitay Isaacs" <amitay@gmail.com>
To: linux-dvb@linuxtv.org, "Steven Toth" <stoth@linuxtv.org>,
	"Trevor Boon" <trevor_boon@yahoo.com>
In-Reply-To: <480D499A.2040806@linuxtv.org>
MIME-Version: 1.0
References: <685282.37355.qm@web55614.mail.re4.yahoo.com>
	<1208817758.10519.13.camel@pc10.localdom.local>
	<480D499A.2040806@linuxtv.org>
Subject: Re: [linux-dvb] HVR1200 / HVR1700 / TDA10048 support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1623112152=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1623112152==
Content-Type: multipart/alternative;
	boundary="----=_Part_1724_24383458.1208833646763"

------=_Part_1724_24383458.1208833646763
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello everyone,

On Tue, Apr 22, 2008 at 12:12 PM, Steven Toth <stoth@linuxtv.org> wrote:

> hermann pitton wrote:
> > Hi, Trevor and Amitay,
> >
> > Am Dienstag, den 22.04.2008, 07:38 +1000 schrieb Trevor Boon:
> >> Hi Amitay,
> >>
> >> I specified the i2c_scan=1 option in my
> >> /etc/modprobe.d/saa7134 file and the following
> >> addresses were returned..
> >>
> >> saa7130[0]: i2c scan: found device @ 0xa0  [eeprom]
> >> saa7130[0]: i2c scan: found device @ 0xc0  [tuner
> >> (analog)]
> >>
> >> Regards,
> >> Trevor.
> >>
> >
> > the 0x10 >> 1 for the digital demod is in the eeprom, if it follows
> > usual rules, at least the tuner is correct there.
> >
> > Likely there are more possibilities, why the tda10048 does not appear,
> > powered off for example to safe energy, but since you also had a crash
> > previously, try a cold boot at first, means wait some time without any
> > power connected, depending on capacitors of the mobo, but 30 seconds
> > without any power should be always safe, and then just let it auto
> > detect card=0 without a tuner again and let i2c_scan=1 enabled one more
> > time.
> >
> > If still the same, you are likely above that basic testing step and can
> > scratch heads on what doing next.
>
> If this doesn't work then you may need to drive a GPIO to being the part
> out of reset.
>
> - Steve



Here is an update on the tests suggested on the list.

After a cold restart and with i2c_scan=1 options to saa7134 the output is as
follows.


[ 1638.631715] Linux video capture interface: v2.00
[ 1638.648219] saa7130/34: v4l2 driver version 0.2.14 loaded
[ 1638.649371] saa7130[0]: found at 0000:02:09.0, rev: 1, irq: 21, latency:
66, mmio: 0xf9e00000
[ 1638.649386] saa7130[0]: subsystem: 107d:6655, board: Leadtek Winfast
DTV-1000S [card=142,autodetected]
[ 1638.649406] saa7130[0]: board init: gpio is 222000
[ 1638.649409] saa7130[0]/core: hwinit1
[ 1638.798382] saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43 43 a9
1c 55 d2 b2 92
[ 1638.798405] saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff
ff ff ff ff ff
[ 1638.798422] saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08 ff 00
8a ff ff ff ff
[ 1638.798440] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 1638.798457] saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff 04 ff
ff ff ff ff ff
[ 1638.798474] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 1638.798491] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 1638.798508] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 1638.798524] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 1638.798541] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 1638.798558] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 1638.798575] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 1638.798592] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 1638.798609] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 1638.798626] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 1638.798643] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 1638.838381] saa7130[0]: i2c scan: found device @ 0xa0  [eeprom]
[ 1638.846378] saa7130[0]: i2c scan: found device @ 0xc0  [tuner (analog)]
[ 1638.852943] saa7130[0]/core: hwinit2
[ 1638.877459] saa7130[0]: registered device video0 [v4l2]
[ 1638.878602] saa7130[0]: registered device vbi0
[ 1638.879508] saa7130[0]: registered device radio0
[ 1638.999695] tda10048: tda10048_attach()
[ 1638.999705] tda10048: tda10048_readreg(reg = 0x00)
[ 1638.999883] tda10048_readreg: readreg error (ret == -5)
[ 1638.999955] saa7130[0]/dvb: frontend initialization failed

I2C scan reveals only tuner at 0xc0 and no tda10048.

I guess the next step is to try to drive a GPIO to bring the demod out of
reset as suggested by Steve.
Any suggestions on how to get GPIO addresses?

Also what are the contents of eeprom? Is there any useful information?

Amitay.

------=_Part_1724_24383458.1208833646763
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello everyone,<br><br><div class="gmail_quote">On Tue, Apr 22, 2008 at 12:12 PM, Steven Toth &lt;<a href="mailto:stoth@linuxtv.org">stoth@linuxtv.org</a>&gt; wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d">hermann pitton wrote:<br>
&gt; Hi, Trevor and Amitay,<br>
&gt;<br>
&gt; Am Dienstag, den 22.04.2008, 07:38 +1000 schrieb Trevor Boon:<br>
&gt;&gt; Hi Amitay,<br>
&gt;&gt;<br>
&gt;&gt; I specified the i2c_scan=1 option in my<br>
&gt;&gt; /etc/modprobe.d/saa7134 file and the following<br>
&gt;&gt; addresses were returned..<br>
&gt;&gt;<br>
&gt;&gt; saa7130[0]: i2c scan: found device @ 0xa0 &nbsp;[eeprom]<br>
&gt;&gt; saa7130[0]: i2c scan: found device @ 0xc0 &nbsp;[tuner<br>
&gt;&gt; (analog)]<br>
&gt;&gt;<br>
&gt;&gt; Regards,<br>
&gt;&gt; Trevor.<br>
&gt;&gt;<br>
&gt;<br>
&gt; the 0x10 &gt;&gt; 1 for the digital demod is in the eeprom, if it follows<br>
&gt; usual rules, at least the tuner is correct there.<br>
&gt;<br>
&gt; Likely there are more possibilities, why the tda10048 does not appear,<br>
&gt; powered off for example to safe energy, but since you also had a crash<br>
&gt; previously, try a cold boot at first, means wait some time without any<br>
&gt; power connected, depending on capacitors of the mobo, but 30 seconds<br>
&gt; without any power should be always safe, and then just let it auto<br>
&gt; detect card=0 without a tuner again and let i2c_scan=1 enabled one more<br>
&gt; time.<br>
&gt;<br>
&gt; If still the same, you are likely above that basic testing step and can<br>
&gt; scratch heads on what doing next.<br>
<br>
</div>If this doesn&#39;t work then you may need to drive a GPIO to being the part<br>
out of reset.<br>
<br>
- Steve</blockquote><div><br>&nbsp;</div></div>Here is an update on the tests suggested on the list.<br>
<br>
After a cold restart and with i2c_scan=1 options to saa7134 the output is as follows.<br><br><br>[ 1638.631715] Linux video capture interface: v2.00<br>[ 1638.648219] saa7130/34: v4l2 driver version 0.2.14 loaded<br>[ 1638.649371] saa7130[0]: found at 0000:02:09.0, rev: 1, irq: 21, latency: 66, mmio: 0xf9e00000<br>
[ 1638.649386] saa7130[0]: subsystem: 107d:6655, board: Leadtek Winfast DTV-1000S [card=142,autodetected]<br>[ 1638.649406] saa7130[0]: board init: gpio is 222000<br>[ 1638.649409] saa7130[0]/core: hwinit1<br>[ 1638.798382] saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43 43 a9 1c 55 d2 b2 92<br>
[ 1638.798405] saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff<br>[ 1638.798422] saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08 ff 00 8a ff ff ff ff<br>[ 1638.798440] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>
[ 1638.798457] saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff 04 ff ff ff ff ff ff<br>[ 1638.798474] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[ 1638.798491] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>
[ 1638.798508] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[ 1638.798524] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[ 1638.798541] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>
[ 1638.798558] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[ 1638.798575] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[ 1638.798592] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>
[ 1638.798609] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[ 1638.798626] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>[ 1638.798643] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>
[ 1638.838381] saa7130[0]: i2c scan: found device @ 0xa0&nbsp; [eeprom]<br>[ 1638.846378] saa7130[0]: i2c scan: found device @ 0xc0&nbsp; [tuner (analog)]<br>[ 1638.852943] saa7130[0]/core: hwinit2<br>[ 1638.877459] saa7130[0]: registered device video0 [v4l2]<br>
[ 1638.878602] saa7130[0]: registered device vbi0<br>[ 1638.879508] saa7130[0]: registered device radio0<br>[ 1638.999695] tda10048: tda10048_attach()<br>[ 1638.999705] tda10048: tda10048_readreg(reg = 0x00)<br>[ 1638.999883] tda10048_readreg: readreg error (ret == -5)<br>
[ 1638.999955] saa7130[0]/dvb: frontend initialization failed<br><br>I2C scan reveals only tuner at 0xc0 and no tda10048. <br><br>I guess the next step is to try to drive a GPIO to bring the demod out of reset as suggested by Steve.<br>
Any suggestions on how to get GPIO addresses?<br><br>Also what are the contents of eeprom? Is there any useful information?<br><br>Amitay.<br>

------=_Part_1724_24383458.1208833646763--


--===============1623112152==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1623112152==--
