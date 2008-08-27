Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <franckbvl@free.fr>) id 1KYU7E-0003Kr-5Y
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 01:07:53 +0200
Message-ID: <48B5D5C7.6000802@free.fr>
Date: Thu, 28 Aug 2008 00:31:35 +0200
From: Franck Bvl <franckbvl@free.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Signal strenght SNR and BER units
Reply-To: Franck Bvl <franckbvl@free.fr>
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

Hi,

Whith dvbsnoop or femon, we can view the values of signal strenght (16
bits),  SNR (16bits) and BER(32 bits). But what are the the scale and
the units of this values. I Googling everywhere and can not find the
meaning of its values. Are they're in DB ? I have just find, that the
BER for the TT3200 are in 10E-7 scale, but that depends on card and drivers.

Can You enlighten me ?

I want to convert the hexadecimals values or the decimal form in human
readable and explicit values.

Best regards

Franck


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
