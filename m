Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KedtR-0005ff-2O
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 00:47:06 +0200
Message-ID: <48CC42D8.8080806@gmail.com>
Date: Sun, 14 Sep 2008 02:46:48 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>	<48C66829.1010902@grumpydevil.homelinux.org>
	<d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
In-Reply-To: <d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

Markus Rechberger wrote:

> How many devices are currently supported by the multiproto API
> compared with the s2 tree?

The initial set of DVB-S2 multistandard devices supported by the
multiproto tree is follows. This is just the stb0899 based dvb-s2 driver
alone. There are more additions by 2 more modules (not devices), but for
the simple comparison here is the quick list of them, for which some of
the manufacturers have shown support in some way. (There has been quite
some contributions from the community as well.):

(Also to be noted is that, some BSD chaps also have shown interest in
the same)

* STB0899 based

Anubis
Typhoon DVB-S2 PCI

Azurewave/Twinhan
VP-1041
VP-7050

Digital Now
AD SP400
AD SB300

KNC1
TV Station DVB-S2
TV Station DVB-S2 Plus

Pinnacle
PCTV Sat HDTV Pro USB 452e

Satelco
TV Station DVB-S2
Easywatch HDTV USB CI
Easywatch HDTV PCI

Technisat
Skystar HD
Skystar HD2
Skystar USB2 HDCI

Technotrend
TT S2 3200
TT S2 3600
TT S2 3650

Terratec
Cinergy S2 PCI HD
Cinergy S2 PCI HDCI


Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
