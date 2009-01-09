Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1LLFGj-0000U0-N7
	for linux-dvb@linuxtv.org; Fri, 09 Jan 2009 12:11:15 +0100
Date: Fri, 09 Jan 2009 12:10:39 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <26D75E582F22456998AE6365440ACEC6@xplap>
Message-ID: <20090109111039.309760@gmx.net>
MIME-Version: 1.0
References: <mailman.1.1231412401.14666.linux-dvb@linuxtv.org>
	<26D75E582F22456998AE6365440ACEC6@xplap>
To: =?iso-8859-1?Q?=22M=E5rten_Gustafsson=22?= <reklam@holisticode.se>,
	linux-dvb@linuxtv.org
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



> > > Hi,
> > > =

> > > i'm new to this mailinglist, so 'Hello' to all :)
> > > =

> > > My first problem, cause of bleeding edge hardware, intels gem, hdmi,
> > > experimental xorg and so on, i've problems to compile the mantis driv=
er
> > > from http://jusst.de/hg/mantis on 2.6.28.
> > > =

> > > I'm getting the following:
> > > =

> > > .... ....
> > > =

> > > Is there a patch or something else to get this driver working on 2.6.=
28
> > =

> > Use the s2-liplianin repository.  It contains an up-to-date mantis driv=
er.
> > =

> > hg clone http://mercurial.intuxication.org/hg/s2-liplianin
> > cd s2-liplianin
> > make
> > sudo make install
> > sudo reboot
> > =

> > Hans

> M=E5rten Gustafsson wrote:
> =

> I tried downloading and compiling from s2-liplianin repository.
> Unfortunately the driver doesn't work at all with AzureWave AD-CP300,
> frontend tda10021 is identified instead of tda10023.
> =

> On Sun, 19 Oct 2008 11:19:40 +0200 (MEST) Niklas Edmundsson posted a patch
> that makes the mantis driver correctly identify the frontend tda10023. It
> is
> in linux-dvb Digest, Vol 45, Issue 24. I tried that patch on the just.de
> repository and it kind of "improved" things, but since CI support was
> lacking it was unusable for me.
> =

> I would really appreciate CI support since all my ComHem channels are
> scrambled. =

> =

> M=E5rten


Could you post the output of 'lspci -vvn' please?
Hans
-- =

Release early, release often.

Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit allen: =
http://www.gmx.net/de/go/multimessenger

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
