Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JigdH-0001Ba-HC
	for linux-dvb@linuxtv.org; Mon, 07 Apr 2008 03:58:58 +0200
Message-ID: <47F97FBD.4030307@iki.fi>
Date: Mon, 07 Apr 2008 04:58:21 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linuxcbon <linuxcbon@yahoo.fr>
References: <308027.91758.qm@web26102.mail.ukl.yahoo.com>
In-Reply-To: <308027.91758.qm@web26102.mail.ukl.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] RE : Re: RE : Re: Which DVB-T USB tuner on linux ?
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

linuxcbon wrote:
> --- Antti Palosaari <crope@iki.fi> a =E9crit :
>> linuxcbon wrote:
>>> Thanks for your answer Antti,
>>>
>>> ARTEC T14BR =

>>> Chip DiB0700
>>> Is the firmware downloaded automaticaly by the kernel ?
>> It is loaded automatically as it is done always. There is no drivers =

>> that needs firmware loaded manually. Everyone driver will load firmware =

>> automatically.
>> But if you mean that if firmware is coming from kernel - answer is =

>> almost 100% no. Firmware is almost always needed to install manually =

>> from somewhere on the net or from via package manager depending on your =

>> distribution. Installing firmware is not big issue and it is needed only
>>
>> once. Installing drivers from source is more work...
> =

> Ok then I buy an ARTEC T14BR (if I find it in the shop :))
> =

> Is dvb-usb-dib0700-03-pre1.fw latest firmware ? Where can it be found ?
> I guess dmesg | grep dvb should tell the correct name and it should be
> changed to it. It should be copied to /lib/firmware/ ?

Yes, yes, yes.
http://www.wi-bw.tfh-wildau.de/~pboettch/home/linux-dvb-firmware/dvb-usb-di=
b0700-1.10.fw

> =

> Do you know if the code is mature for this product, I mean no bugs and all
> features completed ? :p

I think it is rather mature as all BibCom.

> =

> BR, linuxcbon

regards
Antti
-- =

http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
