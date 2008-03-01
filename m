Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s20.bay0.hotmail.com ([65.54.246.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rikardw@hotmail.com>) id 1JVWpN-0000r7-Jf
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 19:52:57 +0100
Message-ID: <BAY118-W5E1C0CAD980EBDED474E0BF150@phx.gbl>
From: Rikard Wissing <rikardw@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Sat, 1 Mar 2008 18:52:22 +0000
In-Reply-To: <47C95DAC.1020301@gmail.com>
References: <BAY118-W56E0462131FD39ABADE685BF150@phx.gbl>
	<47C95DAC.1020301@gmail.com>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Tuning fails with Twinhan DVB-C AD-CP300 (Mantis
 2033)
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


Changed the tuner to TDA10023 and it worked like a charm!
Thanks alot!

Best regards,
Rikard Wissing

----------------------------------------
> Date: Sat, 1 Mar 2008 14:44:12 +0100
> To: linux-dvb@linuxtv.org
> From: e9hack@googlemail.com
> Subject: Re: [linux-dvb] Tuning fails with Twinhan DVB-C AD-CP300 (Mantis=
 2033)
> =

> Rikard Wissing schrieb:
> =

>> [ 4022.656841] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
>> [ 4022.658236] TDA10021: i2c-addr =3D 0x0c, id =3D 0x7d
>> [ 4022.658238] mantis_frontend_init (0): found Philips CU1216 DVB-C fron=
tend (TDA10021) @ 0x0c
>> [ 4022.658240] mantis_frontend_init (0): Mantis DVB-C Philips CU1216 fro=
ntend attach success
>> [ 4022.658243] DVB: registering frontend 0 (Philips TDA10021 DVB-C)...
> =

> The chip ID is 0x7d. Probably, your card uses a CU1216-3 with a TDA10023.=
 There are =

> differences between the TDA10021 and the TDA10023.
> =

> -Hartmut
> =

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_________________________________________________________________
M=F6rkt och kallt? Kanske Barcelona?
http://search.live.com/results.aspx?q=3DBarcelona+reseguide&form=3DQBRE
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
