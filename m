Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outmailhost.telefonica.net ([213.4.149.242]
	helo=ctsmtpout4.frontal.correo)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jareguero@telefonica.net>) id 1LEtLN-0001yy-I4
	for linux-dvb@linuxtv.org; Mon, 22 Dec 2008 23:33:46 +0100
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-dvb@linuxtv.org
Date: Mon, 22 Dec 2008 23:33:08 +0100
References: <4936FF66.3020109@robertoragusa.it> <494C0002.1060204@scram.de>
	<494C0CB3.6090109@iki.fi>
In-Reply-To: <494C0CB3.6090109@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812222333.09509.jareguero@telefonica.net>
Cc: Antti Palosaari <crope@iki.fi>, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] MC44S803 frontend
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

El Viernes, 19 de Diciembre de 2008, Antti Palosaari escribi=F3:
> Jochen Friedrich wrote:
> > Hi Roberto,
> >
> >> Is there any plan to include this frontend in mainline kernels?
> >> I used to run this driver months ago and it was working well.
> >
> > The reason is the huge memory footprint due to the included frequency
> > table. I worked a bit on the driver to get rid of this table. Could you
> > try this version:
> >
> > 1. Patch for AF9015:
> >
> > http://git.bocc.de/cgi-bin/gitweb.cgi?p=3Ddbox2.git;a=3Dcommitdiff;h=3D=
e5d7398a
> >4b2d3c520d949e53bbf7667a481e9690
> >
> > 2. MC44S80x tuner driver:
> >
> > http://git.bocc.de/cgi-bin/gitweb.cgi?p=3Ddbox2.git;a=3Dblob;f=3Ddriver=
s/media/
> >common/tuners/mc44s80x.c;h=3Db8dd335e64b03b8544b4c95e2d7f3dbd968078a0;hb=
=3D4bd
> >e668b4eca90f8bdcc5916dfc88c115a3dfd20
> > http://git.bocc.de/cgi-bin/gitweb.cgi?p=3Ddbox2.git;a=3Dblob;f=3Ddriver=
s/media/
> >common/tuners/mc44s80x.h;h=3Dc6e76da6bf51163c90f0ead259c0e54d4f637671;hb=
=3D4bd
> >e668b4eca90f8bdcc5916dfc88c115a3dfd20
> > http://git.bocc.de/cgi-bin/gitweb.cgi?p=3Ddbox2.git;a=3Dblob;f=3Ddriver=
s/media/
> >common/tuners/mc44s80x_reg.h;h=3D299c1be9a80a3777fb46f65d6070965de975478=
7;hb
> >=3D4bde668b4eca90f8bdcc5916dfc88c115a3dfd20
>
> Is it possible to add this driver to the linuxtv.org repo? My, or Manu
> or you? Looks like there is only one device using this driver currently.
>
> Also Manu's original mxl500x driver seems to be much more sensitive than
> current mxl5005s. I don't know what we should do with this driver, but
> from users perspective this situation is not good. There is rather many
> devices using this tuner.
>

Are your drive using MXL_TF_DEFAULT?
I noticed that in the new driver MXL_TF_DEFAULT is missing in the code.

Jose Alberto

> > Thanks,
> > Jochen
>
> regards
> Antti



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
