Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1K6CA0-0007nA-Bf
	for linux-dvb@linuxtv.org; Wed, 11 Jun 2008 00:17:49 +0200
Message-ID: <484EFD87.5070107@iki.fi>
Date: Wed, 11 Jun 2008 01:17:43 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Andrew Websdale <websdaleandrew@googlemail.com>
References: <e37d7f810806101449l1302da8cj12da36142cc989d1@mail.gmail.com>
In-Reply-To: <e37d7f810806101449l1302da8cj12da36142cc989d1@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dposh DVB-T USB2.0 seems to not work properly
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

Andrew Websdale wrote:
> I've got a Dposh DVB-T USB2.0 (marked ATMT) and I've downloaded some 
> firmware ( which was v.difficult to find as the page in the wiki is 
> blank) which put the stick into a "warm" state i.e.
> 
> dvb-usb: found a 'Dposh DVB-T USB2.0' in cold state, will try to load a 
> firmware
> dvb-usb: downloading firmware from file 'dvb-usb-dposh-01.fw'
> dvb_usb_m920x: probe of 5-1:1.0 failed with error 64
> dvb-usb: found a 'Dposh DVB-T USB2.0' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software 
> demuxer.
> dvb-usb: Dposh DVB-T USB2.0 successfully initialized and connected.
> usbcore: registered new interface driver dvb_usb_m920x
> 
> I've tried Kaffeine and w_scan to no avail, (WinXP gets a signal), I 
> could do with some advice on a)perhaps new firmware and b)help with how 
> to use dvbsnoop or similar to divine what is happening with this device 
> as I lack sufficient knowledge to proceed
> Regards Andrew

There was someone asking this same some time ago. I think it could be 
possible that MT352 demodulator is changed to other one and it does not 
work due to that. Could you open the stick and check chips?

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
