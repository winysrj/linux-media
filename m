Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <moreau.steve@gmail.com>) id 1Ja77j-00045N-R2
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 11:26:53 +0100
Received: by fg-out-1718.google.com with SMTP id 22so3089852fge.25
	for <linux-dvb@linuxtv.org>; Fri, 14 Mar 2008 03:26:18 -0700 (PDT)
Message-ID: <bbc1085f0803140326i118537dbic5ba01992753c6e6@mail.gmail.com>
Date: Fri, 14 Mar 2008 11:26:18 +0100
From: "Steve Moreau" <moreau.steve@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] KNC1 TV Station DVB-S2 driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1282825838=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1282825838==
Content-Type: multipart/alternative;
	boundary="----=_Part_2151_9550670.1205490378124"

------=_Part_2151_9550670.1205490378124
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi guys !

I am new to the list. I own a KNC1 TV Station DVB-S2 and I tried to follow
this tutorial to make it work on my Linux :

http://linuxtv.org/wiki/index.php/KNC1_DVB-S2_TV_Station

I know it is quite new since Manu Abraham tested it only 10 days ago but I
would like to make it work at least for DVB-S mode. I used the version 7208
of Manu repository (http://jusst.de/hg/multiproto/rev/ecb96c96a69e) since
more recent versions complains stops after a invalid ioctl, and because I
guess it is the version tested on the 05th of March by Manu. To be perfectly
complete, I DO NOT use a Debian Lenny, but a Ubuntu Gutsy (ie. kernel
2.6.22-14-generic)

Here is what I get when I use scan :

# ./scan -v  dvb-s/Hotbird-13.0E
scanning dvb-s/Hotbird-13.0E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12539000 H 27500000 27500000
Entering tune_to_transponder
Retrieved fmin=950000, fmax=2150000, inv=0
----------------------------------> Using 'STB0899 Multistandard' DVB-S
Tune to frequency 12539000 (12.539000 GHz)
LNB information : low_val = 9750000, high val = 10600000, switch val =
11700000
DiSEqC: fd=3 | switch pos 0, 18V, hiband (index 3)
diseqc_send_msg:56: DiSEqC: e0 10 38 f3 00 00
diseqc_send_msg:66:   -> SEC_VOLTAGE_18
diseqc_send_msg:69:   -> SEC_MINI_A
diseqc_send_msg:72:   -> SEC_TONE_ON
 setup_switch returned 0
DVB-S IF freq is 1939000 (1939.000000 MHz)
fe_params.delivery = 0
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
Tune to frequency 12539000 (12.539000 GHz)
LNB information : low_val = 9750000, high val = 10600000, switch val =
11700000
DiSEqC: fd=3 | switch pos 0, 18V, hiband (index 3)
diseqc_send_msg:56: DiSEqC: e0 10 38 f3 00 00
diseqc_send_msg:66:   -> SEC_VOLTAGE_18
diseqc_send_msg:69:   -> SEC_MINI_A
diseqc_send_msg:72:   -> SEC_TONE_ON
 setup_switch returned 0
DVB-S IF freq is 1939000 (1939.000000 MHz)
fe_params.delivery = 0
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

I would like to help issuing this problem but my knowledge of DVB-S cards is
quite low at the moment (ok ok null). How do you proceed when developing
driver for a new card. Did you get some kind of technical specifications
from KNC1 or did you adapt a generic driver, tuning parameters in a
empirical way ?
If someone can provide me some clues to troubleshoot my problem or to get
knowledge up, I would be happy to contribute !
Thank you guys for your nice work !

See you

Steve

------=_Part_2151_9550670.1205490378124
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi guys !<br><br>I am new to the list. I own a KNC1 TV Station DVB-S2 and I tried to follow this tutorial to make it work on my Linux :<br><br><a href="http://linuxtv.org/wiki/index.php/KNC1_DVB-S2_TV_Station">http://linuxtv.org/wiki/index.php/KNC1_DVB-S2_TV_Station</a><br>
<br>I know it is quite new since Manu Abraham tested it only 10 days ago but I would like to make it work at least for DVB-S mode. I used the version 7208 of Manu repository (<a href="http://jusst.de/hg/multiproto/rev/ecb96c96a69e">http://jusst.de/hg/multiproto/rev/ecb96c96a69e</a>) since more recent versions complains stops after a invalid ioctl, and because I guess it is the version tested on the 05th of March by Manu. To be perfectly complete, I DO NOT use a Debian Lenny, but a Ubuntu Gutsy (ie. kernel 2.6.22-14-generic)<br>
<br>Here is what I get when I use scan : <br><br># ./scan -v&nbsp; dvb-s/Hotbird-13.0E <br>scanning dvb-s/Hotbird-13.0E<br>using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#39;<br>initial transponder 12539000 H 27500000 27500000<br>
Entering tune_to_transponder<br>Retrieved fmin=950000, fmax=2150000, inv=0<br>----------------------------------&gt; Using &#39;STB0899 Multistandard&#39; DVB-S<br>Tune to frequency 12539000 (12.539000 GHz)<br>LNB information : low_val = 9750000, high val = 10600000, switch val = 11700000<br>
DiSEqC: fd=3 | switch pos 0, 18V, hiband (index 3)<br>diseqc_send_msg:56: DiSEqC: e0 10 38 f3 00 00<br>diseqc_send_msg:66:&nbsp;&nbsp; -&gt; SEC_VOLTAGE_18<br>diseqc_send_msg:69:&nbsp;&nbsp; -&gt; SEC_MINI_A<br>diseqc_send_msg:72:&nbsp;&nbsp; -&gt; SEC_TONE_ON<br>
&nbsp;setup_switch returned 0<br>DVB-S IF freq is 1939000 (1939.000000 MHz)<br>fe_params.delivery = 0<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>
&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>
&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>
&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>WARNING: &gt;&gt;&gt; tuning failed!!!<br>Tune to frequency 12539000 (12.539000 GHz)<br>
LNB information : low_val = 9750000, high val = 10600000, switch val = 11700000<br>DiSEqC: fd=3 | switch pos 0, 18V, hiband (index 3)<br>diseqc_send_msg:56: DiSEqC: e0 10 38 f3 00 00<br>diseqc_send_msg:66:&nbsp;&nbsp; -&gt; SEC_VOLTAGE_18<br>
diseqc_send_msg:69:&nbsp;&nbsp; -&gt; SEC_MINI_A<br>diseqc_send_msg:72:&nbsp;&nbsp; -&gt; SEC_TONE_ON<br>&nbsp;setup_switch returned 0<br>DVB-S IF freq is 1939000 (1939.000000 MHz)<br>fe_params.delivery = 0<br>&gt;&gt;&gt; tuning status == 0x00<br>
&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>
&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>
&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>&gt;&gt;&gt; tuning status == 0x00<br>
&gt;&gt;&gt; tuning status == 0x00<br>WARNING: &gt;&gt;&gt; tuning failed!!!<br>ERROR: initial tuning failed<br>dumping lists (0 services)<br>Done.<br><br>I would like to help issuing this problem but my knowledge of DVB-S cards is quite low at the moment (ok ok null). How do you proceed when developing driver for a new card. Did you get some kind of technical specifications from KNC1 or did you adapt a generic driver, tuning parameters in a empirical way ? <br>
If someone can provide me some clues to troubleshoot my problem or to get knowledge up, I would be happy to contribute !<br>Thank you guys for your nice work !<br><br>See you<br><br>Steve<br>

------=_Part_2151_9550670.1205490378124--


--===============1282825838==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1282825838==--
