Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from aa011msr.fastwebnet.it ([85.18.95.71])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <insomniac@slackware.it>) id 1JbCv8-0008An-O2
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 11:50:25 +0100
Date: Mon, 17 Mar 2008 11:48:02 +0100
From: insomniac <insomniac@slackware.it>
To: linux-dvb@linuxtv.org
Message-ID: <20080317114802.0df56399@slackware.it>
In-Reply-To: <20080317104147.1ade57fe@slackware.it>
References: <20080316182618.2e984a46@slackware.it>
	<abf3e5070803161342y4a68b638m1ae82e8b24cc9a4b@mail.gmail.com>
	<20080317011939.36408857@slackware.it> <47DDC4B5.5050607@iki.fi>
	<20080317025002.2fee3860@slackware.it> <47DDD009.30504@iki.fi>
	<20080317025849.49b07428@slackware.it> <47DDD817.9020605@iki.fi>
	<20080317104147.1ade57fe@slackware.it>
Mime-Version: 1.0
Cc: Antti Palosaari <crope@iki.fi>
Subject: Re: [linux-dvb] New unsupported device
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

On Mon, 17 Mar 2008 10:41:47 +0100
insomniac <insomniac@slackware.it> wrote:

> Patched and recompiled the modules. Now plugging in the usb stick
> triggers the loading of the related kernel modules.
> The one error I get in dmesg is 
> 
> dvb_core: exports duplicate symbol dvb_unregister_adapter (owned by
> kernel)

Great :-)
Here my dmesg:

dvb-usb: found a 'Pinnacle PCTV 73e' in cold state, will try to load a
         firmware dvb-usb: downloading firmware from file
         'dvb-usb-dib0700-1.10.fw' dib0700: firmware started
         successfully.
dvb-usb: found a 'Pinnacle PCTV 73e' in warm state. 
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (Pinnacle PCTV 73e) 
dvb-usb: no frontend was attached by 'Pinnacle PCTV 73e' 
dvb-usb: will pass the complete MPEG2 transport stream to the software
         demuxer.
DVB: registering new adapter (Pinnacle PCTV 73e)
dvb-usb: no frontend was attached by 'Pinnacle PCTV 73e' input:
         IR-receiver inside an USB DVB receiver as /class/input/input6
dvb-usb: schedule remote query interval to 150 msecs. 
dvb-usb: Pinnacle PCTV 73e successfully initialized and connected.

But another problem here:

w_scan version 20060902
Info: using DVB adapter auto detection.
Info: unable to open frontend /dev/dvb/adapter0/frontend0'
Info: unable to open frontend /dev/dvb/adapter1/frontend0'
Info: unable to open frontend /dev/dvb/adapter2/frontend0'
Info: unable to open frontend /dev/dvb/adapter3/frontend0'
main:2140: FATAL: ***** NO USEABLE DVB CARD FOUND. *****
Please check wether dvb driver is loaded and
verify that no dvb application (i.e. vdr) is running.

and also:

# ls /dev/dvb/* 
/dev/dvb/adapter0:
demux0  dvr0  net0

/dev/dvb/adapter1:
demux0  dvr0  net0


So, no frontend is created. What may be?

Thanks,
-- 
Andrea Barberio

a.barberio@oltrelinux.com - Linux&C.
andrea.barberio@slackware.it - Slackware Linux Project Italia
GPG key on http://insomniac.slackware.it/gpgkey.asc
2818 A961 D6D8 1A8C 6E84  6181 5FA6 03B2 E68A 0B7D
SIP: 5327786, Phone: 06 916503784

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
