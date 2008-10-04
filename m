Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from naboo.kollasch.net ([64.71.161.77])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jakllsch@kollasch.net>) id 1KmB9S-0007nr-NU
	for linux-dvb@linuxtv.org; Sat, 04 Oct 2008 19:42:47 +0200
Received: from mail.kollasch.net (mail.kollasch.net
	[IPv6:2002:a867:36dd:1::19])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "mail.kollasch.net",
	Issuer "CA Cert Signing Authority" (verified OK))
	by naboo.kollasch.net (Postfix) with ESMTPS id B136F49E2D
	for <linux-dvb@linuxtv.org>; Sat,  4 Oct 2008 17:42:41 +0000 (UTC)
Received: from tazenda.kollasch.net (tazenda.kollasch.net
	[IPv6:2002:a867:36dd:410:216:3eff:fe1e:883])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	(Authenticated sender: jakllsch@KOLLASCH.NET)
	by mail.kollasch.net (Postfix) with ESMTP id 449263A32D
	for <linux-dvb@linuxtv.org>; Sat,  4 Oct 2008 17:42:39 +0000 (UTC)
Date: Sat, 4 Oct 2008 17:42:39 +0000
From: "Jonathan A. Kollasch" <jakllsch@kollasch.net>
To: linux-dvb@linuxtv.org
Message-ID: <20081004174238.GC27702@tazenda.kollasch.net>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] ATI HDTV Wonder "VE" from HP z556 (1002:a103)
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

I've been working with a 1002:a103 ATI HDTV Wonder (sometimes denoted as a
'VE' variant, perhaps better known as the one in the HP z556).

Only PCI functions 0 and 2 are visible.

The NIM is Philips, but seems to be a digital-only
variant of the one on the regular retail model:

3139 147 22461D#
TU1236/F H
SV20 0434
MADE IN INDONESIA

This tuner can be driven the same as the TUV1236D, except it has no TDA9887,
and doesn't have a alternate RF input, just the normal "DTV" input on top.
(I've not opened the can, but i have manually probed for the TDA9887 via
i2c and got no response.)

The card is missing the AK5355 audio chip, as well as the purple mini-DIN
input connector for the ATI Wonder purple breakout box.

The cx88xx card=34 option seems to work fine for me.  However there are no
sources of analog video on(to) the board, so that support is not really
going to do anything useful.

	Jonathan Kollasch

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
