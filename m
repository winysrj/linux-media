Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt3.poste.it ([62.241.4.129])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1KqFh5-0006i8-VZ
	for linux-dvb@linuxtv.org; Thu, 16 Oct 2008 01:22:22 +0200
Received: from geppetto.reilabs.com (78.15.185.20) by relay-pt3.poste.it
	(7.3.122) (authenticated as stefano.sabatini-lala@poste.it)
	id 48F6763600000100 for linux-dvb@linuxtv.org;
	Thu, 16 Oct 2008 01:22:16 +0200
Received: from stefano by geppetto.reilabs.com with local (Exim 4.67)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1KqFg9-00061B-GC
	for linux-dvb@linuxtv.org; Thu, 16 Oct 2008 01:21:21 +0200
Date: Thu, 16 Oct 2008 01:21:21 +0200
From: Stefano Sabatini <stefano.sabatini-lala@poste.it>
To: linux-dvb@linuxtv.org
Message-ID: <20081015232121.GA8831@geppetto>
References: <20081014212402.GB11745@geppetto>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081014212402.GB11745@geppetto>
Subject: Re: [linux-dvb] Unable to query frontend status with dvbscan
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

On date Tuesday 2008-10-14 23:24:02 +0200, Stefano Sabatini wrote:
> Hi all,
> 
> can you say what's the meaning of such a message?
> 
> I'm using it with:
> dvbscan  /usr/share/dvb/dvb-t/it-MyCity
> Unable to query frontend status
> 
> using a TerraTec Electronic GmbH with dvb-usb-dib0700 driver.
> 
> The module seems to be loaded correctly, indeed I get this in the
> kernel log:
> 
> [ 1834.456051] dib0700: loaded with support for 7 different device-types
> [ 1834.456051] dvb-usb: found a 'Terratec Cinergy HT USB XE' in cold state, will try to load a firmware
> [ 1834.456051] firmware: requesting dvb-usb-dib0700-1.10.fw
> [ 1834.464197] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
> [ 1834.662979] dib0700: firmware started successfully.
> [ 1835.168928] dvb-usb: found a 'Terratec Cinergy HT USB XE' in warm state.
> [ 1835.168997] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> [ 1835.169355] DVB: registering new adapter (Terratec Cinergy HT USB XE)
> [ 1835.419963] DVB: registering frontend 0 (DiBcom 7000PC)...
> [ 1835.499932] xc2028 1-0061: creating new instance
> [ 1835.499932] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
> [ 1835.499932] input: IR-receiver inside an USB DVB receiver as /class/input/input7
> [ 1835.510406] dvb-usb: schedule remote query interval to 150 msecs.
> [ 1835.510416] dvb-usb: Terratec Cinergy HT USB XE successfully initialized and connected.
> [ 1835.510696] usbcore: registered new interface driver dvb_usb_dib0700
> 
> The led on the device switched on when I performed the first scan.

Other meaningful info:
stefano@geppetto ~> dvbscan  /usr/share/dvb/dvb-t/it-Cagliari
Unable to query frontend status
stefano@geppetto ~> sudo dvbscan  /usr/share/dvb/dvb-t/it-Cagliari
Unable to query frontend status
stefano@geppetto ~> ls -l /dev/dvb/adapter0/
total 0
crw-rw---- 1 root video 212, 1 2008-09-23 00:04 audio0
crw-rw---- 1 root video 212, 6 2008-09-23 00:04 ca0
crw-rw---- 1 root video 212, 4 2008-09-23 00:04 demux0
crw-rw---- 1 root video 212, 5 2008-09-23 00:04 dvr0
crw-rw---- 1 root video 212, 3 2008-09-23 00:04 frontend0
crw-rw---- 1 root video 212, 7 2008-09-23 00:04 net0
crw-rw---- 1 root video 212, 8 2008-09-23 00:04 osd0
crw-rw---- 1 root video 212, 0 2008-09-23 00:04 video0

stefano@geppetto ~> uname -a
Linux geppetto 2.6.26-1-686 #1 SMP Thu Oct 9 15:18:09 UTC 2008 i686 GNU/Linux

The device is reported to be supported on the DVB wiki:
http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_HT_USB_XE

Help or hints will be appreciated.

Regards.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
