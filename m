Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp03.msg.oleane.net ([62.161.4.3])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1Jtedz-0004nM-4V
	for linux-dvb@linuxtv.org; Wed, 07 May 2008 10:04:55 +0200
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: "'Brice DUBOST'" <braice@braice.net>, <linux-dvb@linuxtv.org>
Date: Wed, 7 May 2008 10:04:47 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAAB0B3nNnu0eZW4llRIXYCAEAAAAA@tv-numeric.com>
MIME-Version: 1.0
In-Reply-To: <4820B6EB.9070204@braice.net>
Subject: [linux-dvb] RE :  Patch for the scan utility from dvb-apps
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

> By the way I have an issue : the French DVB-T network doesn't give the
> good frequencies in the SI-Tables. Is there a way to get the frequency
> from the card ?

An ioctl FE_GET_FRONTEND on the frontend device returns a struct
dvb_frontend_parameters which contains all the tuning and modulation
parameters, including the frequency. You need to tune on the frequency
first, of course.

In the French DVB-T network, all terrestrial_delivery_descriptors in the
NIT are generic. All frequencies are 0xFFFFFFFF and all modulation
parameters are those of the average MFN transmitters in the country.
They are incorrect for all SFN transmitters and some specific transmitters
(including the local services "L8" multiplex).

Otherwise, the most recent (March 31) list of the French DVB-T frequencies
by transmitter is available at:
http://www.csa.fr/pdf/frequences_tnt_planifiees_alpha.pdf

-Thierry 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
