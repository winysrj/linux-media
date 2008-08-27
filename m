Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1KYGKq-0001M8-P8
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 10:25:03 +0200
Date: Wed, 27 Aug 2008 10:24:18 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Eduard Huguet <eduardhc@gmail.com>
In-Reply-To: <617be8890808270010j640f4cb7je46e74c7234b978b@mail.gmail.com>
Message-ID: <alpine.LRH.1.10.0808271021040.18085@pub6.ifh.de>
References: <617be8890808270010j640f4cb7je46e74c7234b978b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="579696143-892527153-1219825458=:18085"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib0700 new i2c implementation
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

--579696143-892527153-1219825458=:18085
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by znsun1.ifh.de id m7R8OIuM020902

Hi Eduard,

We had some problems with previous I2C implementation and the 1.20 is=20
really fixing them - they were hard to find. But the problem we had were=20
not on the Nova-T 500... Still I think it could be related.

So depending on any previous behaviour of the device it can only be bette=
r=20
or worse, both results are interesting in order to know whether this=20
firmware can be become the main one or not.

best regards,
Patrick.

On Wed, 27 Aug 2008, Eduard Huguet wrote:

>       ---------- Missatge reenviat ----------
>       From:=A0"Devin Heitmueller" <devin.heitmueller@gmail.com>
>       To:=A0linux-dvb <linux-dvb@linuxtv.org>
>       Date:=A0Tue, 26 Aug 2008 21:15:20 -0400
>       Subject:=A0[linux-dvb] dib0700 new i2c implementation
>       The attached patch implements the new dib0700 i2c API, which requ=
ires
>       v1.20 of the firmware. =A0It addresses some classes of i2c proble=
ms (in
>       particular the one I had where i2c reads were being sent onto the=
 bus
>       as i2c write calls)
>
>       I would appreciate it if those with dib0700 based devices would t=
ry
>       out the patch and provide feedback as to whether they have any
>       problems. =A0I've done testing with the Pinnacle PCTV HD Pro USB =
801e
>       stick, but I don't have any other dib0700 based devices.
>
>       Thanks to Patrick Boettcher for providing the firmware, sample co=
de,
>       and peer review of the first version of this patch.
>
>       Regards,
>
>       Devin
>
>       --
>       Devin J. Heitmueller
>       http://www.devinheitmueller.com
>       AIM: devinheitmueller
>=20
>=20
>=20
> Hi,
> =A0=A0=A0 Thanks for your work, first of all. =BFDo you think this patc=
h might=A0 solve the problems that seem to be appeared since the new firm=
ware is out
> with the Hauppauge Nova-T 500, like random reboots, etc... (what's ths =
state on this, anyway?) ?
>=20
> I delayed the adoption of the new 1.20 firmware because of those proble=
ms, because I didn't want to leave the machine in a complete unusable
> state...
>=20
> Best regards,
> =A0 Eduard Huguet
>=20
> =A0
>=20
>=20
>
--579696143-892527153-1219825458=:18085
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--579696143-892527153-1219825458=:18085--
