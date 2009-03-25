Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <poplyra@gmail.com>) id 1LmI55-0005LI-Bt
	for linux-dvb@linuxtv.org; Wed, 25 Mar 2009 02:39:00 +0100
Received: by yx-out-2324.google.com with SMTP id 8so2081358yxm.41
	for <linux-dvb@linuxtv.org>; Tue, 24 Mar 2009 18:38:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7b41dd970903241514g677c1071raf1010653fd6b7e8@mail.gmail.com>
References: <7b41dd970809290235x48f63938ic56318ba3064a71b@mail.gmail.com>
	<c4d80f839f7e2e838b04f6c37c68d9c0@10.0.0.2>
	<7b41dd970810091315h1433fa7du56e5754a1684019d@mail.gmail.com>
	<1223598995.4825.12.camel@pc10.localdom.local>
	<7b41dd970810121321m715f7a81nf2c6e07485603571@mail.gmail.com>
	<loom.20090225T203249-735@post.gmane.org>
	<1235712905.2748.29.camel@pc10.localdom.local>
	<7b41dd970903241514g677c1071raf1010653fd6b7e8@mail.gmail.com>
Date: Tue, 24 Mar 2009 22:38:54 -0300
Message-ID: <ff07fffe0903241838j278bbc4agfc94a23f2ab018cb@mail.gmail.com>
From: Christian Lyra <lyra@pop-pr.rnp.br>
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TechnoTrend C-1501 - Locking issues on 388Mhz
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

Hi
>> > > Hi,
>> > > Am Donnerstag, den 09.10.2008, 22:15 +0200 schrieb klaas de waal:
>> > > =A0The table starts a new segment at 390MHz,
>> > > > it then starts to use VCO2 instead of VCO1.
>> > > > I have now (hack, hack) changed the segment start from 390 to 395M=
Hz
>> > > > so that the 388MHz is still tuned with VCO1, and this works OK!!
>
> TechnoTrend C-1501 DVB-C card does not lock on 388MHz.
> I assume that existing frequency table is valid for DVB-T. This is sugges=
ted
> by the name of the table: tda827xa_dvbt.
> Added a table for DVB-C with the name tda827xa_dvbc.
> Added runtime selection of the DVB-C table when the tuner is type FE_QAM.
> This should leave the behaviour of this driver with with DVB_T tuners
> unchanged.
> This modification is in file tda827x.c

I imagine if there=B4s something similar to my card, as it doesnt seem
to use the same tuner. dmesg only says this:

[    3.611107] Linux video capture interface: v2.00
[    3.621431] saa7146: register extension 'budget_av'.
[    3.621513] budget_av 0000:00:00.0: enabling device (0000 -> 0002)
[    3.621757] saa7146: found saa7146 @ mem ffffc20000024000 (revision
1, irq 16) (0x1894,0x0022).
[    3.621768] saa7146 (0): dma buffer size 192512
[    3.621773] DVB: registering new adapter (KNC1 DVB-C MK3)
[    3.655279] adapter failed MAC signature check
[    3.655292] encoded MAC from EEPROM was
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
[    3.858310] budget_av: saa7113_init(): saa7113 not found on KNC card
[    3.918489] KNC1-0: MAC addr =3D 00:09:d6:6d:9f:db
[    4.112763] DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-=
C)...
[    4.112896] budget-av: ci interface initialised.

What tunner this card use?

-- =

Christian Lyra
PoP-PR/RNP

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
