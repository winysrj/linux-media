Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n21.bullet.mail.ukl.yahoo.com ([87.248.110.138])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1Jwjnx-0001rY-Lr
	for linux-dvb@linuxtv.org; Thu, 15 May 2008 22:12:02 +0200
Date: Thu, 15 May 2008 07:27:21 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <482BF672.1090402@kipdola.com> <20080515111150.392be0b9@bercot.org>
	<200805151140.15939.rudy@grumpydevil.homelinux.org>
In-Reply-To: <200805151140.15939.rudy@grumpydevil.homelinux.org> (from
	rudy@grumpydevil.homelinux.org on Thu May 15 05:40:15 2008)
Message-Id: <1210850841l.5925l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : Technotrend S2-3200 (Or Technisat Skystar HD) on
 LinuxMCE 0710 (Kubuntu Feisty)
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

On 05/15/2008 05:40:15 AM, Rudy Zijlstra wrote:
> On Thursday 15 May 2008 11:11, David BERCOT wrote:
> > Hi Jelle,
> >
> > I've seen your mail this morning ;-)
> >
> > Le Thu, 15 May 2008 10:38:10 +0200,
> >
> > Jelle De Loecker <skerit@kipdola.com> a =E9crit :
> > > Good morning all,
> > >
> > > I'm having difficulty getting my DVB-S2 card to work on LinuxMCE
> 0710
> > > (Kubuntu Feisty, kernel 2.6.22-14-generic) I'll start with some
> lspci
> > > info to prove the card is connected:
> > > lspci -v:
> > > 04:01.0 Multimedia controller: Philips Semiconductors SAA7146 =

> (rev
> 01)
> > >         Subsystem: Technotrend Systemtechnik GmbH S2-3200
> > >         Flags: bus master, medium devsel, latency 64, IRQ 16
> > >         Memory at febffc00 (32-bit, non-prefetchable) [size=3D512]
> > >
> > > I can compile the drivers just fine, I followed the instructions
> from
> > > this French page:
> > > http://wilco.bercot.org/debian/s2-3200.html
> > > <http://wilco.bercot.org/debian/s2-3200.html>(I don't completely
> > > understand French, but we all speak code!)
> > >
> > > But after loading the drivers I don't get a /dev/dvb folder.
> > > My dmesg output only shows this message:
> > > saa7146: register extension 'budget_ci dvb'.
> >
> > Have you reboot your computer ? May be it can solve your =

> problems...
> > If not, I'll do another version with the multiproto plus driver
> soon.
> >
> =

> Remains the question, what is the difference between multiproto and
> multiproto =

> plus?
> =

> Its something i also would like to understand. Another question, how
> if =

> progress on CI with the TT-3200?
> =


Here TT-3200 working with my CAm with no problem (almost every channel =

is scrambled on my sat). I can even have 2channels simustaneously =

recorded (Astoncrypt cam is able to decode 2 streams simultaneously).
Software: multiproto (1- months old I think)+mythtv-0.21 (I had to =

modify it: I need to ADD 4 MHz to the frequency, else I have unreliable =

or no lock).
HTH
Bye
Manu



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
