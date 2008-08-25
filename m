Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ws1-5.us4.outblaze.com ([205.158.62.51])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KXk9i-0005W7-R1
	for linux-dvb@linuxtv.org; Tue, 26 Aug 2008 00:03:23 +0200
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: jackden <jackden@gmail.com>
Date: Tue, 26 Aug 2008 08:03:05 +1000
Message-Id: <20080825220305.429DA4782FC@ws1-5.us4.outblaze.com>
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


> ----- Original Message -----
> From: jackden <jackden@gmail.com>
> To: stev391@email.com
> Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog TV/FM capture card
> Date: Mon, 25 Aug 2008 21:40:08 +0800
> 
> 
> Stephen,
> 
> > 1) A high resolution photo so I can identify the main items on the board
> ok. see http://linuxtv.org/wiki/index.php/Compro_VideoMate_E650
> 
> > 2) A list of chips used on board, (The two key chips that I need to know are the tuner & 
> > demodulator)
> ok.
> 
> > 3) The output of `lspci -vv` and `lspci -n` that are relevant for this card.
> ok.
> 
> > 4) The output of `i2cdetect -l` and `i2cdetect #` where # is the number associated with a 
> > cx23885 adapter (see 
> > http://linuxtv.org/wiki/index.php/AVerMedia_AVerTV_Hybrid_Express_Slim_HC81R#i2cdetect for 
> > example)
> hmm... I run 'i2cdetect -l' ,but the output is empty. : (
> 
> 
> > 5) The Regspy output, for: idle straight after boot, dvb channel tuned and working, analog 
> > tuned and working. (This needs windows, to get regspy just google "regspy dscaler".
> Regspy is windows only? I no have windows operating system.  : (
> 
> 6) An external link to the compro product page.
> 
> ----=Jackden in Google=----
> --=Jackden@Gmail.com=--

Jackden,

Thanks for completing the information on the wiki page.

To use i2cdetect you need to load i2c_dev module (or something similar).  i2cdetect is part of lm sensors so maybe you should install this if you haven't already. (perhaps try Google for an answer...)

>From what you have posted I still think it is possible to support this card easily, but as you cannot provide me with the output of Regspy (which is windows) I will have do a little of trial and error.  So hopefully you are very patient. (I still need the output of i2cdetect before I create a patch).

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
