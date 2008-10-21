Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate04.web.de ([217.72.192.242])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <SebastianMarskamp@web.de>) id 1KsOjF-0005j2-JD
	for linux-dvb@linuxtv.org; Tue, 21 Oct 2008 23:25:26 +0200
Date: Tue, 21 Oct 2008 23:24:50 +0200
Message-Id: <1550114954@web.de>
MIME-Version: 1.0
From: Sebastian Marskamp <SebastianMarskamp@web.de>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] MSI DigiVox mini II V3.0 stopped working
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Same here  ..Problem occures with Kernel  	2.6.27   . Firmware is installed=
 correct , hardware is working under windows . No error Message at all. =


[ 2696.610565] af9015_usb_probe: interface:0
[ 2696.611970] af9015_read_config: IR mode:1
[ 2696.614463] af9015_read_config: TS mode:0
[ 2696.615839] af9015_read_config: [0] xtal:2 set adc_clock:28000
[ 2696.618595] af9015_read_config: [0] IF1:43000
[ 2696.621344] af9015_read_config: [0] MT2060 IF1:0
[ 2696.622718] af9015_read_config: [0] tuner id:156
[ 2696.623093] af9015_identify_state: reply:01
[ 2696.623097] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold=
 state, will try to load a firmware
[ 2696.623100] firmware: requesting dvb-usb-af9015.fw
[ 2696.634547] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[ 2696.634552] af9015_download_firmware:
[ 2696.701890] usbcore: registered new interface driver dvb_usb_af9015

Its just not working anymore =



It also doesnt work with new Alsa 1.0.18 , but thats another Problem =


________________________________________________________________________
Schon geh=F6rt? Bei WEB.DE gibt' s viele kostenlose Spiele:
http://games.entertainment.web.de/de/entertainment/games/free/index.html


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
