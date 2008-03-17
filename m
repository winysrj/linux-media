Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1JbDDS-0001US-VZ
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 12:09:20 +0100
Received: by ti-out-0910.google.com with SMTP id y6so1757651tia.13
	for <linux-dvb@linuxtv.org>; Mon, 17 Mar 2008 04:09:12 -0700 (PDT)
Message-ID: <abf3e5070803170409j8be4c54r96f97eb2d3fd4dac@mail.gmail.com>
Date: Mon, 17 Mar 2008 22:09:12 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: insomniac <insomniac@slackware.it>
In-Reply-To: <20080317114802.0df56399@slackware.it>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080316182618.2e984a46@slackware.it>
	<abf3e5070803161342y4a68b638m1ae82e8b24cc9a4b@mail.gmail.com>
	<20080317011939.36408857@slackware.it> <47DDC4B5.5050607@iki.fi>
	<20080317025002.2fee3860@slackware.it> <47DDD009.30504@iki.fi>
	<20080317025849.49b07428@slackware.it> <47DDD817.9020605@iki.fi>
	<20080317104147.1ade57fe@slackware.it>
	<20080317114802.0df56399@slackware.it>
Cc: Antti Palosaari <crope@iki.fi>, linux-dvb@linuxtv.org
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

On Mon, Mar 17, 2008 at 9:48 PM, insomniac <insomniac@slackware.it> wrote:
> On Mon, 17 Mar 2008 10:41:47 +0100
>
> insomniac <insomniac@slackware.it> wrote:
>
>
> > Patched and recompiled the modules. Now plugging in the usb stick
>  > triggers the loading of the related kernel modules.
>  > The one error I get in dmesg is
>  >
>  > dvb_core: exports duplicate symbol dvb_unregister_adapter (owned by
>  > kernel)
>
>  Great :-)
>  Here my dmesg:
>
>  dvb-usb: found a 'Pinnacle PCTV 73e' in cold state, will try to load a
>          firmware dvb-usb: downloading firmware from file
>          'dvb-usb-dib0700-1.10.fw' dib0700: firmware started
>          successfully.
>  dvb-usb: found a 'Pinnacle PCTV 73e' in warm state.
>  dvb-usb: will pass the complete MPEG2 transport stream to the software
>  demuxer.
>  DVB: registering new adapter (Pinnacle PCTV 73e)
>  dvb-usb: no frontend was attached by 'Pinnacle PCTV 73e'
>  dvb-usb: will pass the complete MPEG2 transport stream to the software
>          demuxer.
>  DVB: registering new adapter (Pinnacle PCTV 73e)
>  dvb-usb: no frontend was attached by 'Pinnacle PCTV 73e' input:
>          IR-receiver inside an USB DVB receiver as /class/input/input6
>  dvb-usb: schedule remote query interval to 150 msecs.
>  dvb-usb: Pinnacle PCTV 73e successfully initialized and connected.
>
>  But another problem here:
>
>  w_scan version 20060902
>  Info: using DVB adapter auto detection.
>  Info: unable to open frontend /dev/dvb/adapter0/frontend0'
>  Info: unable to open frontend /dev/dvb/adapter1/frontend0'
>  Info: unable to open frontend /dev/dvb/adapter2/frontend0'
>  Info: unable to open frontend /dev/dvb/adapter3/frontend0'
>  main:2140: FATAL: ***** NO USEABLE DVB CARD FOUND. *****
>  Please check wether dvb driver is loaded and
>  verify that no dvb application (i.e. vdr) is running.
>
>  and also:
>
>  # ls /dev/dvb/*
>  /dev/dvb/adapter0:
>  demux0  dvr0  net0
>
>  /dev/dvb/adapter1:
>  demux0  dvr0  net0
>
>
>  So, no frontend is created. What may be?
>
>  Thanks,
>
>
> --
>  Andrea Barberio
>

That means the driver either couldn't work out what the tuner is
and therefore, couldn't attach a frontend, or there was an error
attaching the frontend. The next job is to work out what the
tuner chip is, you might have to open it up and read the writing
off the chip to find that out.

Jarryd.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
