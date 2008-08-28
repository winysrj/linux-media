Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1KYWt7-00064A-Uy
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 04:05:31 +0200
Message-ID: <48B607E1.8060102@linuxtv.org>
Date: Wed, 27 Aug 2008 22:05:21 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: manu <eallaud@yahoo.fr>
References: <48B5D5C7.6000802@free.fr>	<37219a840808271718y5c25d0d4y62f016de745143b2@mail.gmail.com>
	<1219884004l.9440l.1l@manu-laptop>
In-Reply-To: <1219884004l.9440l.1l@manu-laptop>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Re :  Signal strenght SNR and BER units
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

manu wrote:
> Le 27.08.2008 20:18:18, mkrufky@gmail.com a =E9crit :
>> It is different for each demod, depending on who wrote the code. I =

>> can
>> list a bunch of drivers that report SNR in dB, but you cannot rely on
>> this because the drivers are not consistent between one another.  =

>> That
>> is why your searches didn't turn up any answers.
>>    -MiKE
>>
>>
> =

> Hmm could a format be chosen so that it is actually useable?


As I said, I can point out some drivers that are known to report SNR in dB,=
 but I can't tell you the units used in the other drivers.

It would be nice if it was standardized across all of the drivers, but spec=
s aren't freely available for every device out there.

Any SNR code that I have written, or will write in the future, will be repo=
rted in dB.

-MiKE

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
