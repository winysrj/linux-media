Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta-out.inet.fi ([195.156.147.13] helo=jenni1.inet.fi)
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lwgt@iki.fi>) id 1MFNYP-0003CZ-Ee
	for linux-dvb@linuxtv.org; Sat, 13 Jun 2009 09:21:29 +0200
Received: from [127.0.0.1] (88.192.35.233) by jenni1.inet.fi (8.5.014)
	id 49F5976601C48679 for linux-dvb@linuxtv.org;
	Sat, 13 Jun 2009 10:21:24 +0300
Message-ID: <4A335373.2000906@iki.fi>
Date: Sat, 13 Jun 2009 10:21:23 +0300
From: Lauri Tischler <lwgt@iki.fi>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <4A3138DD.6010306@iki.fi>
In-Reply-To: <4A3138DD.6010306@iki.fi>
Subject: Re: [linux-dvb] af9015 errors
Reply-To: linux-media@vger.kernel.org
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

Lauri Tischler wrote:
> Following appears in syslog when plugin in Fuji usb-stick
> 
>> [  227.744026] usb 1-1: new high speed USB device using ehci_hcd and address 6
>> [  227.881303] usb 1-1: configuration #1 chosen from 1 choice
>> [  228.008884] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state, will try to load a firmware
>> [  228.008894] usb 1-1: firmware: requesting dvb-usb-af9015.fw
>> [  228.030287] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
>> [  228.084183] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in warm state.
>> [  228.084262] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
>> [  228.084558] DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 stick)
>> [  228.518386] af9013: firmware version:4.65.0

Fixed it, firmware was old, replaced 4.65.0 with 4.95.0, works now..

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
