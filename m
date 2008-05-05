Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1JswTK-00025e-Os
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 10:55:03 +0200
Date: Mon, 5 May 2008 10:54:16 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: "Igor M. Liplianin" <liplianin@me.by>
In-Reply-To: <200805051150.05608.liplianin@me.by>
Message-ID: <Pine.LNX.4.64.0805051053050.24331@pub3.ifh.de>
References: <200805051150.05608.liplianin@me.by>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="579696399-733700727-1209977656=:24331"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DM713S and DM714S very same PCI ID,
 but different hardware(STV0299 and TDA10086 frontends)?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--579696399-733700727-1209977656=:24331
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by znsun1.ifh.de id m458sG4s026432

Hi Igor,

yes, that is possible. Just try to attach the stv0299 first, it will=20
return NULL if it didn't detect itself. The same for the tda10086.

Patrick.



On Mon, 5 May 2008, Igor M. Liplianin wrote:

> Hello !
> I =A0wonder:
> Card DM713S, pci\ven_195d&dev1105&subsys_1105195d, frontend STV0299B.
> Card DM714S, pci\ven_195d&dev1105&subsys_1105195d, frontend TDA10086HT.
> Is it possible autodetect different frontends on cards with very same P=
CI
> ID's? =A0
>
> Best regards
> Igor M. Liplianin
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

--579696399-733700727-1209977656=:24331
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--579696399-733700727-1209977656=:24331--
