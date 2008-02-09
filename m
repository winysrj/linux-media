Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fmmailgate02.web.de ([217.72.192.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Andre.Weidemann@web.de>) id 1JNnFv-0007kB-FV
	for linux-dvb@linuxtv.org; Sat, 09 Feb 2008 11:48:23 +0100
Received: from smtp06.web.de (fmsmtp06.dlan.cinetic.de [172.20.5.172])
	by fmmailgate02.web.de (Postfix) with ESMTP id 54633D0087B8
	for <linux-dvb@linuxtv.org>; Sat,  9 Feb 2008 11:47:53 +0100 (CET)
Received: from [84.184.103.140] (helo=[192.168.0.1])
	by smtp06.web.de with asmtp (WEB.DE 4.109 #226) id 1JNnFR-0001nD-00
	for linux-dvb@linuxtv.org; Sat, 09 Feb 2008 11:47:53 +0100
Message-ID: <47AD84DC.6060304@web.de>
Date: Sat, 09 Feb 2008 11:47:56 +0100
From: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47A9B2AE.7090209@web.de>
In-Reply-To: <47A9B2AE.7090209@web.de>
Subject: Re: [linux-dvb] [PATCH] Support for TT connect S-2400
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Andr=E9 Weidemann wrote:
> Please try the attached patch and let me know whether it's working or not.

I got a few personal replies to this patch and it seems as if it is =

basically working.
But in order to make the USB box work without picture distortion a =

different firmware needs to be loaded for the TT connect S-2400. I was =

able to extract the firmware from the original TT driver and using this =

firmware everything is fine.
The problem I'm facing now is, that my programming knowledge is not =

sufficient to add the necessary changes to the code so that a different =

firmware is loaded for the two different boxes.
Can anyone give me a hand on this or even write the few lines?

The new FW can be found here: =

http://ilpss8.dyndns.org/dvb-usb-tt-s2400-01.fw

Thank you.
  Andr=E9

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
