Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <beth.null@gmail.com>) id 1KVbvv-0003Sx-JV
	for linux-dvb@linuxtv.org; Wed, 20 Aug 2008 02:52:22 +0200
Received: by yx-out-2324.google.com with SMTP id 8so64278yxg.41
	for <linux-dvb@linuxtv.org>; Tue, 19 Aug 2008 17:52:15 -0700 (PDT)
Message-ID: <7641eb8f0808191752l66477998hf1df63f3470290cd@mail.gmail.com>
Date: Wed, 20 Aug 2008 02:52:14 +0200
From: Beth <beth.null@gmail.com>
To: "Carl Oscar Ejwertz" <oscarmax3@gmail.com>
In-Reply-To: <48AB3A52.8010305@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <48AB3A52.8010305@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Twinhan AD-TP300 (3030) Mantis .. Help needed..
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

I don't know if is applicable to you but I have the same problem with
a SkyStar HD2 that is a Twinhan clone (mine is satellite not
terrestrial), but I think that this could work for you.

I had the same problem, I get dvr0 and such, until I modified the
kernel driver to recognize my card, the problem becomes because they
are the same card but have different product id (a pci device is
identified by its vendor id "vid" and product id "pid"), my clone is
the same but with a different vid, 0x003 instead 0x001, so I edited
the .h of the driver change the vid to the SkyStar HD2, and
recompile&install the driver modules.

Later I had read that without this modification the frontend is not
created, so maybe you are in the same situation as I.

I hope this helps you, bye.

2008/8/19 Carl Oscar Ejwertz <oscarmax3@gmail.com>:
> Hello!
>
> I have this DVB-T card in my ubuntu htpc box but cannot get it to work.
> I've tried diffrent kinds of drivers and no luck.. my best hopes are on
> some guys drivers called Manu - he has Mantis drivers that are almost
> working for this card. The problem are after compiling the lastest hg
> is  that it doesn't create a Frontend0 in the /dev/dvb/adapter0. I get
> the dvr0, mux0 and the others. I wonder if anyone have any solution for
> this and can assist me in getting this card to work.
>
> I get this from lspci -vvv
>
> 01:06.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
> Bridge Controller [Ver 1.0] (rev 01)
>    Subsystem: Twinhan Technology Co. Ltd Unknown device 0024
>    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>    Latency: 32 (2000ns min, 63750ns max)
>    Interrupt: pin A routed to IRQ 10
>    Region 0: Memory at ea000000 (32-bit, prefetchable) [size=3D4K]
>
> Many thanks
>
> Oscar
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>



-- =

---------------------------------------------------
Jos=E9 Antonio Robles

beth.null@gmail.com

661 960 119

Sometimes something happens ...
---------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
