Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f149.mail.ru ([194.67.57.228])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1L09VB-0004eX-GB
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 07:46:58 +0100
From: Goga777 <goga777@bk.ru>
To: Hans Werner <HWerner4@gmx.de>
Mime-Version: 1.0
Date: Wed, 12 Nov 2008 09:46:23 +0300
References: <20081112023112.94740@gmx.net>
In-Reply-To: <20081112023112.94740@gmx.net>
Message-Id: <E1L09Ud-000GW2-00.goga777-bk-ru@f149.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?W1BBVENIXSBzY2FuLXMyOiBmaXhlcyBhbmQgZGlz?=
	=?koi8-r?b?ZXFjIHJvdG9yIHN1cHBvcnQ=?=
Reply-To: Goga777 <goga777@bk.ru>
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

> I have attached two patches for scan-s2 at http://mercurial.intuxication.org/hg/scan-s2.
> 
> Patch1: Some fixes for problems I found. QAM_AUTO is not supported by all drivers,
> in particular the HVR-4000, so one needs to use QPSK as the default and ensure that
> settings are parsed properly from the network information -- the new S2 FECs and
> modulations were not handled.
> 
> Patch2: Add DiSEqC 1.2 rotor support. Use it like this to move the dish to the correct
> position for the scan:
>  scan-s2 -r 19.2E -n dvb-s/Astra-19.2E
>  or
>  scan-s2 -R 2 -n dvb-s/Astra-19.2E
> 
> A file (rotor.conf) listing the rotor positions is used (NB: rotors vary -- do check your
> rotor manual).


thanks for your patch.

btw - could you scan dvb-s2 (qpsk & 8psk) channels with scan-s2 and hvr4000 ? with which drivers ?

Goga


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
