Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1Jxs5X-0004C1-AU
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 01:14:48 +0200
Date: Mon, 19 May 2008 01:14:04 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Jan Hoogenraad <jan-conceptronic@h-i-s.nl>
Message-ID: <Pine.LNX.4.64.0805190112530.15623@pub5.ifh.de>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Testers requested for Freecom / Conceptronic /
 Realtek / haihua /Videomate / Vestel DVB-T cards with RTL2831U
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

The email got bounced by mailman. Too many recipients.

Resending it

---------- Forwarded message ----------
Date: Mon, 19 May 2008 01:02:35 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Jan Hoogenraad <jan-conceptronic@h-i-s.nl>
Subject: Re: [linux-dvb] Testers requested for Freecom / Conceptronic / Realtek
     / haihua /Videomate / Vestel DVB-T cards with RTL2831U

Hi,

On Sun, 18 May 2008, Jan Hoogenraad wrote:
>  However, I ran into problems with the mt2060 (which is the tuner I own).
>  In the function  MT2060_LocateIF1 is making this hard.

Don't bother. IIRC, the function is not working correctly for the MT2060. The 
self-calibration does not work. The IF-offset must be set per-device during 
production and usually is programmed into an eeprom on the cards. Simply apply 
it to the mt2060_attach-function (see mt2060.h).

>  This function doe some sort of calibration, and there is both internal
>  data from the tuner required, and input from the demodulator.

Use a callback in the config struct of either the demod or the tuner driver. It 
is not always the right solution to put specific functionality for one or two 
devices into a generic interface or in the dvb_tuner_ops case into the abstract 
class.

HTH,
Patrick.

--
    Mail: patrick.boettcher@desy.de
    WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
