Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JP0vX-0000sS-QQ
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 20:36:23 +0100
Received: by fg-out-1718.google.com with SMTP id 22so4009720fge.25
	for <linux-dvb@linuxtv.org>; Tue, 12 Feb 2008 11:36:22 -0800 (PST)
Message-ID: <ea4209750802121136p462abbf3ubf57c87a5c856d0b@mail.gmail.com>
Date: Tue, 12 Feb 2008 20:36:22 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: hfvogt@gmx.net
In-Reply-To: <200802112223.11129.hfvogt@gmx.net>
MIME-Version: 1.0
References: <200802112223.11129.hfvogt@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] support Cinergy HT USB XE (0ccd:0058)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1376002446=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1376002446==
Content-Type: multipart/alternative;
	boundary="----=_Part_3584_8247316.1202844982862"

------=_Part_3584_8247316.1202844982862
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Hans, you where faster than me... I don't understand what you did with
the firmware. I just extracted the xc3028-v27.fw from the win driver as
commented in other threads.
Then I added my card (pinnacle 320cx) to your patch with some
mid-successfully results, this is the dmesg;

[ 8067.028000] usb 1-1: new high speed USB device using ehci_hcd and address
4
[ 8067.160000] usb 1-1: configuration #1 chosen from 1 choice
[ 8067.160000] dvb-usb: found a 'Pinnacle Expresscard 320cx' in cold state,
will try to load a firmware
[ 8067.164000] dvb-usb: downloading firmware from file '
dvb-usb-dib0700-1.10.fw'
[ 8067.360000] dib0700: firmware started successfully.
[ 8067.864000] dvb-usb: found a 'Pinnacle Expresscard 320cx' in warm state.
[ 8067.864000] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[ 8067.864000] DVB: registering new adapter (Pinnacle Expresscard 320cx)
[ 8068.236000] DVB: registering frontend 0 (DiBcom 7000PC)...
[ 8068.236000] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
[ 8068.236000] input: IR-receiver inside an USB DVB receiver as
/class/input/input13
[ 8068.236000] dvb-usb: schedule remote query interval to 150 msecs.
[ 8068.236000] dvb-usb: Pinnacle Expresscard 320cx successfully initialized
and connected.

But when I start kaffeine i got this error;

[ 8144.084000] xc2028 4-0061: Error on line 1063: -5

And when I try to scan I get more errors;
[ 8176.032000] xc2028 4-0061: Loading 80 firmware images from xc3028-v27.fw,
type: xc2028 firmware, ver 2.7
[ 8176.032000] dib0700: stk7700ph_xc3028_callback: XC2028_TUNER_RESET 0
[ 8176.032000]
[ 8176.060000] xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
0000000000000000.
[ 8176.060000] dib0700: stk7700ph_xc3028_callback: XC2028_TUNER_RESET 0
[ 8176.060000]
[ 8182.548000] xc2028 4-0061: Loading firmware for type=D2620 DTV8 (208), id
0000000000000000.
[ 8182.668000] xc2028 4-0061: Device is Xceive 3028 version 1.0, firmware
version 2.7
[ 8182.688000] dib0700: stk7700ph_xc3028_callback: XC2028_RESET_CLK 1
[ 8182.688000]
[ 8184.364000] xc2028 4-0061: Device is Xceive 3028 version 1.0, firmware
version 2.7
[ 8184.384000] dib0700: stk7700ph_xc3028_callback: XC2028_RESET_CLK 1

Any idea? is this related to the firmware??

Albert

------=_Part_3584_8247316.1202844982862
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Hans, you where faster than me... I don&#39;t understand what you did with the firmware. I just extracted the xc3028-v27.fw from the win driver as commented in other threads. <br>Then I added my card (pinnacle 320cx) to your patch with some mid-successfully results, this is the dmesg;<br>
<br>[ 8067.028000] usb 1-1: new high speed USB device using ehci_hcd and address 4<br>[ 8067.160000] usb 1-1: configuration #1 chosen from 1 choice<br>[ 8067.160000] dvb-usb: found a &#39;Pinnacle Expresscard 320cx&#39; in cold state, will try to load a firmware<br>
[ 8067.164000] dvb-usb: downloading firmware from file &#39;dvb-usb-dib0700-1.10.fw&#39;<br>[ 8067.360000] dib0700: firmware started successfully.<br>[ 8067.864000] dvb-usb: found a &#39;Pinnacle Expresscard 320cx&#39; in warm state.<br>
[ 8067.864000] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>[ 8067.864000] DVB: registering new adapter (Pinnacle Expresscard 320cx)<br>[ 8068.236000] DVB: registering frontend 0 (DiBcom 7000PC)...<br>
[ 8068.236000] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner<br>[ 8068.236000] input: IR-receiver inside an USB DVB receiver as /class/input/input13<br>[ 8068.236000] dvb-usb: schedule remote query interval to 150 msecs.<br>
[ 8068.236000] dvb-usb: Pinnacle Expresscard 320cx successfully initialized and connected.<br><br>But when I start kaffeine i got this error;<br><br>[ 8144.084000] xc2028 4-0061: Error on line 1063: -5<br><br>And when I try to scan I get more errors;<br>
[ 8176.032000] xc2028 4-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7<br>[ 8176.032000] dib0700: stk7700ph_xc3028_callback: XC2028_TUNER_RESET 0<br>[ 8176.032000] <br>[ 8176.060000] xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.<br>
[ 8176.060000] dib0700: stk7700ph_xc3028_callback: XC2028_TUNER_RESET 0<br>[ 8176.060000] <br>[ 8182.548000] xc2028 4-0061: Loading firmware for type=D2620 DTV8 (208), id 0000000000000000.<br>[ 8182.668000] xc2028 4-0061: Device is Xceive 3028 version 1.0, firmware version 2.7<br>
[ 8182.688000] dib0700: stk7700ph_xc3028_callback: XC2028_RESET_CLK 1<br>[ 8182.688000] <br>[ 8184.364000] xc2028 4-0061: Device is Xceive 3028 version 1.0, firmware version 2.7<br>[ 8184.384000] dib0700: stk7700ph_xc3028_callback: XC2028_RESET_CLK 1<br>
<br>Any idea? is this related to the firmware??<br><br>Albert<br><br><br><br><br>

------=_Part_3584_8247316.1202844982862--


--===============1376002446==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1376002446==--
