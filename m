Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt3.poste.it ([62.241.4.129])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1KprNz-0003Qm-Q4
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 23:25:02 +0200
Received: from geppetto.reilabs.com (78.15.177.222) by relay-pt3.poste.it
	(7.3.122) (authenticated as stefano.sabatini-lala@poste.it)
	id 48F3D3360000873B for linux-dvb@linuxtv.org;
	Tue, 14 Oct 2008 23:24:56 +0200
Received: from stefano by geppetto.reilabs.com with local (Exim 4.67)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1KprN4-0003Hp-I1
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 23:24:02 +0200
Date: Tue, 14 Oct 2008 23:24:02 +0200
From: Stefano Sabatini <stefano.sabatini-lala@poste.it>
To: linux-dvb Mailing List <linux-dvb@linuxtv.org>
Message-ID: <20081014212402.GB11745@geppetto>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Unable to query frontend status with dvbscan
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi all,

can you say what's the meaning of such a message?

I'm using it with:
dvbscan  /usr/share/dvb/dvb-t/it-MyCity
Unable to query frontend status

using a TerraTec Electronic GmbH with dvb-usb-dib0700 driver.

The module seems to be loaded correctly, indeed I get this in the
kernel log:

[ 1834.456051] dib0700: loaded with support for 7 different device-types
[ 1834.456051] dvb-usb: found a 'Terratec Cinergy HT USB XE' in cold state, will try to load a firmware
[ 1834.456051] firmware: requesting dvb-usb-dib0700-1.10.fw
[ 1834.464197] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
[ 1834.662979] dib0700: firmware started successfully.
[ 1835.168928] dvb-usb: found a 'Terratec Cinergy HT USB XE' in warm state.
[ 1835.168997] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[ 1835.169355] DVB: registering new adapter (Terratec Cinergy HT USB XE)
[ 1835.419963] DVB: registering frontend 0 (DiBcom 7000PC)...
[ 1835.499932] xc2028 1-0061: creating new instance
[ 1835.499932] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[ 1835.499932] input: IR-receiver inside an USB DVB receiver as /class/input/input7
[ 1835.510406] dvb-usb: schedule remote query interval to 150 msecs.
[ 1835.510416] dvb-usb: Terratec Cinergy HT USB XE successfully initialized and connected.
[ 1835.510696] usbcore: registered new interface driver dvb_usb_dib0700

The led on the device switched on when I performed the first scan.

Thanks for any help.

Regards.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
