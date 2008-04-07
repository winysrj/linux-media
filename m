Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Jj0ix-000711-GQ
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 01:26:08 +0200
Message-ID: <47FAAD63.80505@iki.fi>
Date: Tue, 08 Apr 2008 02:25:23 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Julien Rebetez <julien@fhtagn.net>
References: <1207588024.14924.12.camel@silver-laptop>
In-Reply-To: <1207588024.14924.12.camel@silver-laptop>
Content-Type: multipart/mixed; boundary="------------090404070901070602040007"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Yuan EC372S no frontend
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------090404070901070602040007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Julien Rebetez wrote:
> Hello,
> 
> I have some problems with a Yuan EC372S card. I am using the latest (rev
> 7499:1abbd650fe07) v4l-dvb from mercurial head. 
> 
> The card is correctly detected and the firmware loaded but no frontend
> is attached to it.

I just tested current master and it worked for me. Anyhow, tuning still 
gives only filter timeouts (as earlier).

> 
> I'm running kernel 2.6.22-14-generic on an Ubuntu Gutsy.
> 
> I have attached the relevant output of dmesg and lsusb -v and of course
> I'll be glad to give more informations if needed.
> 
> Regards,
> Julien

regards
Antti
-- 
http://palosaari.fi/

--------------090404070901070602040007
Content-Type: text/plain;
 name="yuan_insert_log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="yuan_insert_log.txt"

Apr  8 02:22:12 crope-laptop kernel: [  910.108121] dib0700: loaded with support for 7 different device-types
Apr  8 02:22:12 crope-laptop kernel: [  910.108154] usbcore: registered new interface driver dvb_usb_dib0700
Apr  8 02:22:20 crope-laptop kernel: [  914.330737] usb 1-8: new high speed USB device using ehci_hcd and address 23
Apr  8 02:22:20 crope-laptop kernel: [  914.382207] usb 1-8: configuration #1 chosen from 1 choice
Apr  8 02:22:20 crope-laptop kernel: [  914.387576] FW GET_VERSION length: -32
Apr  8 02:22:20 crope-laptop kernel: [  914.387581] cold: 1
Apr  8 02:22:20 crope-laptop kernel: [  914.387583] dvb-usb: found a 'Yuan EC372S' in cold state, will try to load a firmware
Apr  8 02:22:20 crope-laptop kernel: [  914.389666] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
Apr  8 02:22:21 crope-laptop kernel: [  914.474369] dib0700: firmware started successfully.
Apr  8 02:22:21 crope-laptop kernel: [  914.759587] dvb-usb: found a 'Yuan EC372S' in warm state.
Apr  8 02:22:21 crope-laptop kernel: [  914.759645] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Apr  8 02:22:21 crope-laptop kernel: [  914.759808] DVB: registering new adapter (Yuan EC372S)
Apr  8 02:22:21 crope-laptop kernel: [  914.811947] ep 0 read error (status = -32)
Apr  8 02:22:21 crope-laptop kernel: [  914.811955] I2C read failed on address 40
Apr  8 02:22:21 crope-laptop kernel: [  914.980331] DVB: registering frontend 0 (DiBcom 7000PC)...
Apr  8 02:22:21 crope-laptop kernel: [  914.984082] MT2266: successfully identified
Apr  8 02:22:21 crope-laptop kernel: [  915.150087] dvb-usb: Yuan EC372S successfully initialized and connected.


--------------090404070901070602040007
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------090404070901070602040007--
