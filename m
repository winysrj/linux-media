Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JbeTu-0002Gc-LN
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 17:16:11 +0100
Message-ID: <47DFEA9F.4070307@iki.fi>
Date: Tue, 18 Mar 2008 18:15:27 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: insomniac <insomniac@slackware.it>
References: <ea4209750803180734m67c0990byabb81bb2ec52d992@mail.gmail.com>	<47DFDCC4.4090001@iki.fi>
	<20080318163812.343b0a87@slackware.it>
	<20080318170134.69e40dab@slackware.it>
In-Reply-To: <20080318170134.69e40dab@slackware.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib7770 tunner
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

insomniac wrote:
> On Tue, 18 Mar 2008 16:38:12 +0100
> insomniac <insomniac@slackware.it> wrote:
> 
>> On Tue, 18 Mar 2008 17:16:20 +0200
>> Antti Palosaari <crope@iki.fi> wrote:
>>
>>> dib7770 is 3 in 1 solution, usb-bridge + demodulator + tuner. You
>>> can try dib7070 tuner driver. STK7070P looks rather similar (but
>>> less integrated).
> 
> after talking with Albert about it, I moved this code:
> 
> {    "Pinnacle PCTV 73e",
>      { &dib0700_usb_id_table[27], NULL },
>      { NULL },
> }
> 
> after this code:
> 
> {   "Hauppauge Nova-T MyTV.t",
>     { &dib0700_usb_id_table[26], NULL },
>     { NULL },
> }
> 
> in linux/drivers/media/dvb/dvb-usb/dib0700_devices.c .
> 
> After I plug the stick, I see the led to light on, and dmesg says:
> 
> dvb-usb: found a 'Pinnacle PCTV 73e' in cold state, will try to load a
> firmware dvb-usb: downloading firmware from file
> 'dvb-usb-dib0700-1.10.fw' dib0700: firmware started successfully.
> dvb-usb: found a 'Pinnacle PCTV 73e' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer. DVB: registering new adapter (Pinnacle PCTV 73e)
> DVB: registering frontend 0 (DiBcom 7000PC)...
> mt2060 I2C read failed

I don't understand how dib7070p_tuner_attach could call mt2060.

> All the files in /dev/dvb/adapter0 get created, including tuner0, but
> of course tuner is not working (as w_scan can show).
> 
> The solutions seems not to be far.. Anyone has an idea?
> 
> Regards,

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
