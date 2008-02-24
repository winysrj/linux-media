Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JTNQn-00030s-1g
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 21:26:41 +0100
Message-ID: <47C1D2FA.40909@gmail.com>
Date: Mon, 25 Feb 2008 00:26:34 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Simeon Simeonov <simeonov_2000@yahoo.com>
References: <694662.3577.qm@web33104.mail.mud.yahoo.com>
	<47BFBE5A.4030000@gmail.com>
In-Reply-To: <47BFBE5A.4030000@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help with Skystar HD2 (Twinhan VP-1041/Azurewave
 AD	SP400 rebadge)
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

Manu Abraham wrote:
> Simeon Simeonov wrote:
>> Hi Gernot,
>>
>> I can confirm that I have similar experience to yours.
>> By the way do you know if one can control from the soft side (register or some other means)
>> the max current output for the card. I am having a problem when trying to tune with a rotor.
>> On the Linux side the current seems to be capped at 300 mA as on the XP I see it goes to
>> about 440 mA. I was still surprised that this card can supply less current than the 102g but
>> we take what we get ...

Can you please try this change, whether it helps in your case ?

In mantis_dvb.c

line #251

if (!lnbp21_attach(mantis->fe, &mantis->adapter, 0, 0)) {

change it to

if (!lnbp21_attach(mantis->fe, &mantis->adapter, 0x80, 0x40)) {

and see whether it helps in improving your current limited situation.
according to the specification it should yield 500 - 650mA

A word of caution, make sure that the auxilliary power connector is
connected. Current drawn will be a bit much higher in this case,
additionally Static Current Limiting is used, hence additional dissipation,
which means more current drawn which might overload the PCI bus, hence
  it would be nice to use the auxilliary power connector.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
