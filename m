Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [194.250.18.140] (helo=tv-numeric.com)
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1LocCK-0007rL-O3
	for linux-dvb@linuxtv.org; Tue, 31 Mar 2009 13:32:05 +0200
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: <linux-dvb@linuxtv.org>
Date: Tue, 31 Mar 2009 13:31:18 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAx84X9ngDfUyzlWnN0NIgkwEAAAAA@tv-numeric.com>
MIME-Version: 1.0
In-Reply-To: <49D1F823.9020001@hanno.de>
Subject: [linux-dvb] RE : Question about EPG data - is there a logo in it?
Reply-To: linux-media@vger.kernel.org
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

EPG may have several formats: DVB standard or proprietary.
This depends on the network.

The DVB standard document which defines the Service Information
is ETSI EN 300 468: Specification for Service Information (SI)
in DVB systems. Latest version is 1.9.1 (March 2009). It can
be requested for free at etsi.org.

Using DVB, the EPG data is contained in EIT (Event Information
Table). There is no requirement for a channel logo. A very
recent icon_descriptor has been defined for such purpose but
I doubt it is actually used. I am not aware of networks doing
this.

Many networks, however, still use proprietary EPG data format.
So, DVB EIT's are not always the answer...

-Thierry

> -----Message d'origine-----
> De : linux-dvb-bounces@linuxtv.org =

> [mailto:linux-dvb-bounces@linuxtv.org] De la part de Hanno Zulla
> Envoy=E9 : mardi 31 mars 2009 13:02
> =C0 : linux-dvb@linuxtv.org
> Objet : [linux-dvb] Question about EPG data - is there a logo in it?
> =

> =

> Hi,
> =

> can some of the readers on this list enlight me:
> =

> Where is a public document describing the EPG data content?
> =

> The specific thing I want to know is: Does the EPG data contain a
> channel logo and if it does, what is its format?
> =

> Thank you,
> =

> Hanno
> =

> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead =

> linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> =



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
