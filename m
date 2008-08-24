Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KX58O-0001h0-K3
	for linux-dvb@linuxtv.org; Sun, 24 Aug 2008 04:15:20 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	C6B971800130
	for <linux-dvb@linuxtv.org>; Sun, 24 Aug 2008 02:14:39 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: jackden@gmail.com
Date: Sun, 24 Aug 2008 12:14:39 +1000
Message-Id: <20080824021439.BB192BE4078@ws1-9.us4.outblaze.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
 TV/FM capture card
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

> I have Compro VideoMate E650.
> VideoMate E650 hybrid PCI-Express DVB-T and analog TV/FM capture card.
> But it can't correct run. I use Ubuntu 8.04. vga card is ATI Radeon HD2600 Pro.

--Snip--

> ps.sorry, my english is very poor.
> 
> ----=Jackden in Google=----
> --=Jackden at Gmail.com=--


Jackden,

As you have found out the current drivers do not provide support for this card.
However I think with your help, and others with this card, we can get at least DVB-T support running.
This card seems similar to the Leadtek Winfast PxDVR 3200 H, which I wrote support for (however not similar enough to work straight away).

Can you update the wiki page (http://linuxtv.org/wiki/index.php/Compro_VideoMate_E650) with the following:

1) A high resolution photo so I can identify the main items on the board

2) A list of chips used on board, (The two key chips that I need to know are the tuner & demodulator)

3) The output of `lspci -vv` and `lspci -n` that are relevant for this card.

4) The output of `i2cdetect -l` and `i2cdetect #` where # is the number associated with a cx23885 adapter (see http://linuxtv.org/wiki/index.php/AVerMedia_AVerTV_Hybrid_Express_Slim_HC81R#i2cdetect for example)

5) The Regspy output, for: idle straight after boot, dvb channel tuned and working, analog tuned and working. (This needs windows, to get regspy just google "regspy dscaler".

6) An external link to the compro product page.

To get an idea of what I need see: http://linuxtv.org/wiki/index.php/Leadtek_Winfast_PxDVR_3200_H

To be able to edit wiki pages you need to create a login and sign in.

Once any of these items have been posted please let me know and I can see if it is possible to write the driver.

Regards,

Stephen.



-- 
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
