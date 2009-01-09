Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.citynetwork.se ([62.95.110.81] helo=smtp01.citynetwork.se)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <reklam@holisticode.se>) id 1LLH5g-0004jH-N8
	for linux-dvb@linuxtv.org; Fri, 09 Jan 2009 14:07:59 +0100
From: =?iso-8859-1?Q?M=E5rten_Gustafsson?= <reklam@holisticode.se>
To: "'Hans Werner'" <HWerner4@gmx.de>,
	<linux-dvb@linuxtv.org>
References: <mailman.1.1231412401.14666.linux-dvb@linuxtv.org>
	<26D75E582F22456998AE6365440ACEC6@xplap>
	<20090109111039.309760@gmx.net>
Date: Fri, 9 Jan 2009 14:07:20 +0100
Message-ID: <87D6FAB545B1401AB72F361FD4E56BC5@xplap>
MIME-Version: 1.0
In-Reply-To: <20090109111039.309760@gmx.net>
Subject: Re: [linux-dvb] Compiling mantis driver on 2.6.28
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

 =


> -----Ursprungligt meddelande-----
> Fr=E5n: Hans Werner [mailto:HWerner4@gmx.de] =

> Skickat: den 9 januari 2009 12:11
> Till: "M=E5rten Gustafsson"; linux-dvb@linuxtv.org
> =C4mne: Re: [linux-dvb] Compiling mantis driver on 2.6.28
> =

> =

> =

> > > > Hi,
> > > > =

> > > > i'm new to this mailinglist, so 'Hello' to all :)
> > > > =

> > > > My first problem, cause of bleeding edge hardware, intels gem, =

> > > > hdmi, experimental xorg and so on, i've problems to compile the =

> > > > mantis driver from http://jusst.de/hg/mantis on 2.6.28.
> > > > =

> > > > I'm getting the following:
> > > > =

> > > > .... ....
> > > > =

> > > > Is there a patch or something else to get this driver =

> working on =

> > > > 2.6.28
> > > =

> > > Use the s2-liplianin repository.  It contains an =

> up-to-date mantis driver.
> > > =

> > > hg clone http://mercurial.intuxication.org/hg/s2-liplianin
> > > cd s2-liplianin
> > > make
> > > sudo make install
> > > sudo reboot
> > > =

> > > Hans
> =

> > M=E5rten Gustafsson wrote:
> > =

> > I tried downloading and compiling from s2-liplianin repository.
> > Unfortunately the driver doesn't work at all with AzureWave =

> AD-CP300, =

> > frontend tda10021 is identified instead of tda10023.
> > =

> > On Sun, 19 Oct 2008 11:19:40 +0200 (MEST) Niklas Edmundsson =

> posted a =

> > patch that makes the mantis driver correctly identify the frontend =

> > tda10023. It is in linux-dvb Digest, Vol 45, Issue 24. I tried that =

> > patch on the just.de repository and it kind of "improved" =

> things, but =

> > since CI support was lacking it was unusable for me.
> > =

> > I would really appreciate CI support since all my ComHem =

> channels are =

> > scrambled.
> > =

> > M=E5rten
> =

> =

> Could you post the output of 'lspci -vvn' please?
> Hans
> --
> Release early, release often.
> =

> Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s =

> mit allen: http://www.gmx.net/de/go/multimessenger
> =

> =


Hi Hans

I guess this is what you want:

05:07.0 0480: 1822:4e35 (rev 01)
    Subsystem: 1822:0008
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 32 (2000ns min, 63750ns max)
    Interrupt: pin A routed to IRQ 17
    Region 0: Memory at c6000000 (32-bit, prefetchable) [size=3D4K]
    Kernel driver in use: Mantis
    Kernel modules: mantis


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
