Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web26102.mail.ukl.yahoo.com ([217.146.182.143])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <linuxcbon@yahoo.fr>) id 1JigYV-0000VZ-OL
	for linux-dvb@linuxtv.org; Mon, 07 Apr 2008 03:53:59 +0200
Date: Mon, 7 Apr 2008 03:53:22 +0200 (CEST)
From: linuxcbon <linuxcbon@yahoo.fr>
To: Antti Palosaari <crope@iki.fi>
In-Reply-To: <47F97374.80902@iki.fi>
MIME-Version: 1.0
Message-ID: <308027.91758.qm@web26102.mail.ukl.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] RE : Re:  RE : Re:  Which DVB-T USB tuner  on linux ?
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

--- Antti Palosaari <crope@iki.fi> a =E9crit=A0:
> linuxcbon wrote:
> > Thanks for your answer Antti,
> > =

> > ARTEC T14BR =

> > Chip DiB0700
> > Is the firmware downloaded automaticaly by the kernel ?
> =

> It is loaded automatically as it is done always. There is no drivers =

> that needs firmware loaded manually. Everyone driver will load firmware =

> automatically.
> But if you mean that if firmware is coming from kernel - answer is =

> almost 100% no. Firmware is almost always needed to install manually =

> from somewhere on the net or from via package manager depending on your =

> distribution. Installing firmware is not big issue and it is needed only
> =

> once. Installing drivers from source is more work...

Ok then I buy an ARTEC T14BR (if I find it in the shop :))

Is dvb-usb-dib0700-03-pre1.fw latest firmware ? Where can it be found ?
I guess dmesg | grep dvb should tell the correct name and it should be
changed to it. It should be copied to /lib/firmware/ ?

Do you know if the code is mature for this product, I mean no bugs and all
features completed ? :p

BR, linuxcbon




      _____________________________________________________________________=
________ =

Envoyez avec Yahoo! Mail. Une boite mail plus intelligente http://mail.yaho=
o.fr

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
