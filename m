Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailserv.web-arts.de ([85.220.131.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thorsten.barth@web-arts.com>) id 1K5fSO-0001n8-PM
	for linux-dvb@linuxtv.org; Mon, 09 Jun 2008 13:22:37 +0200
Message-ID: <484D1253.9090201@web-arts.com>
Date: Mon, 09 Jun 2008 13:21:55 +0200
From: Thorsten Barth <thorsten.barth@web-arts.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <65922d730806081149j2ba9085bm1984155ebf8eebd2@mail.gmail.com>
	<200806082120.04766@orion.escape-edv.de>
In-Reply-To: <200806082120.04766@orion.escape-edv.de>
Subject: Re: [linux-dvb] TT-Budget/WinTV-NOVA-CI is recognized as sound card
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

Hello,

could this also be the case with a Hauppauge Nova S-Plus PCI unter
Kubuntu 7.10 ?

If so, what do I have to do to disable the audiowerk driver? What is the
name of the module, and am I right if I take a look at the files in
/etc/modules.d/* ?

Thanks and CU
Thorsten

Oliver Endriss schrieb:
> Michael Stepanov wrote:
>   =

>> Hi,
>>
>> I have following problem with my TT-Budget/WinTV-NOVA-CI DVB card. It's
>> recognized as Audiowerk2 sound card instead of DVB:
>>
>> linuxmce@dcerouter:~$ cat /proc/asound/cards
>>  0 [Audiowerk2     ]: aw2 - Audiowerk2
>>                       Audiowerk2 with SAA7146 irq 16
>>  1 [NVidia         ]: HDA-Intel - HDA NVidia
>>                       HDA NVidia at 0xfe020000 irq 20
>>
>> This is what I can see in the dmesg output:
>> [   81.311527] saa7146: register extension 'budget_ci dvb'.
>>
>> I use LinxuMCE which is built on the top of Kubuntu Gutsy, AMD64.
>>
>> Linux dcerouter 2.6.22-14-generic #1 SMP Sun Oct 14 21:45:15 GMT 2007
>> x86_64 GNU/Linux
>>
>> Any suggestion how to solve that will be very appreciated.
>>     =

>
> Complain to the developers of the Audiowerk2 driver for this:
>
> | static struct pci_device_id snd_aw2_ids[] =3D {
> | 	{PCI_VENDOR_ID_SAA7146, PCI_DEVICE_ID_SAA7146, PCI_ANY_ID, PCI_ANY_ID,
> | 	 0, 0, 0},
> |	{0}
> | };
>
> This will grab _all_ saa7146-based cards. :-(
>
> For now you should blacklist that driver.
>
> CU
> Oliver
>
>   =


-- =

*Thorsten Barth*
Vorstand

*Web Arts AG*
Seifgrundstra=DFe 2
61348 Bad Homburg v. d. H=F6he
http://www.web-arts.com

Tel.: +49.6172.68097-17
Fax: +49.6172.68097-77
thorsten.barth@web-arts.com <mailto:thorsten.barth@web-arts.com>


*Sitz der Gesellschaft:* Bad Homburg v. d. H=F6he | *Amtsgericht:* Bad
Homburg v. d. H=F6he HRB 6719
*Steuernummer:* 003 248 00118 Finanzamt Bad Homburg v. d. H=F6he
*Vorstand:* Thorsten Barth, Andr=E9 Morys | *Aufsichtsrat:* Gerhard
Beinhauer (Vors.)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
