Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web110807.mail.gq1.yahoo.com ([67.195.13.230])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <urishk@yahoo.com>) id 1LOWsd-0003xu-Ub
	for linux-dvb@linuxtv.org; Sun, 18 Jan 2009 13:35:57 +0100
Date: Sun, 18 Jan 2009 04:35:21 -0800 (PST)
From: Uri Shkolnik <urishk@yahoo.com>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0901181314430.18169@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Message-ID: <743977.30000.qm@web110807.mail.gq1.yahoo.com>
Cc: =?iso-8859-1?Q?St=E5le_Helleberg_/_drc=2Eno?= <staale@drc.no>,
	linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Siano subsystem (DAB/DMB support) library for linux?
Reply-To: linux-media@vger.kernel.org, urishk@yahoo.com
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




--- On Sun, 1/18/09, BOUWSMA Barry <freebeer.bouwsma@gmail.com> wrote:

> From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
> Subject: Re: [linux-dvb] Siano subsystem (DAB/DMB support) library for li=
nux?
> To: urishk@yahoo.com
> Cc: "St=E5le Helleberg / drc.no" <staale@drc.no>
> Date: Sunday, January 18, 2009, 2:29 PM
> An update.  You will see what I fool I am.
> =

> On Sun, 18 Jan 2009, BOUWSMA Barry wrote:
> =

> > cd /dev && mknod -m 766 /dev/mdtvctrl c
> $SMSCHAR $(($SMSMINOR + 0))
> > cd /dev && mknod -m 766 /dev/mdtv1 c $SMSCHAR
> $(($SMSMINOR + 1))
> =

> You know, it might help if I actually looked at the files
> I'm
> hacking on, instead of blindly assuming they work like
> `MAKEDEV'
> and create the node in the current directory  :-)
> =

> Nonetheless, when I chose to migrate from major 251 to 249,
> I decided I could hide my ignorance by an `rm' like
> so...
> =

> rm /dev/mdtvctrl && mknod -m 766 /dev/mdtvctrl c
> $SMSCHAR $(($SMSMINOR + 0))
> rm /dev/mdtv1 && mknod -m 766 /dev/mdtv1 c $SMSCHAR
> $(($SMSMINOR + 1))
> =

> =

> > > I'm not quite that far yet, as I may have
> some further
> > > hardware debugging to do -- plus I will learn far
> more from
> > =

> > It was not hardware debugging needed, so it seems.  On
> the
> =

> Or...  was it?  Not only with major 249 on the newer build,
> but now, again with 249 on my notebook, I also see success.
> =

> Could it be that the USB device into which I plugged the
> TerraTec Piranha caused the problems?  Maybe, because into
> a different USB hub, I have success on the notebook...
> =

> Tuning into a frequency
> Kenneth, the frequency is  227360000
> Esemble Info Result
> Well, no problems there
> Tuning...
> Esemble Info Result
> EID: 16385 with 12 services 'SRG SSR D01     '
> Get Combined Components result
> Found 12 services...
> =

> Service: 0 - DRS 1
> =

> =

> > on the other machine.  If so, I'll complain loudly
> to Uri
> > that the Siano binary library seems to have major 251
> hardcoded
> > somewhere within, rather than the device names linked
> by the
> > script, or some similar problem.
> =

> Uri, please accept my apologies.  This was *not* the
> problem,
> the library works fine with the device nodes pointed to by
> the
> script:
> beer@ralph:/usr/local/src/mini_dab$ ls -lart /dev/mdtv*
> crwxrw-rw- 1 root root 249,  0 Jan 17 18:52 /dev/mdtvctrl
> crwxrw-rw- 1 root root 249,  1 Jan 17 18:52 /dev/mdtv1
> =

> Sorry to have made any false accusation.  It just seemed
> to me that it could be one of the many possibilities that
> might have been at fault.
> =

> =

> Now, the interesting thing is that a USB2 DVB-S connected
> through this same hub delivered streams that were corrupt
> every few minutes, while the same device connected to a
> different hub has been delivering flawless streams.  Now
> I need to check whether the USB1 Piranha can deliver the
> clean streams, or if again, cheap hardware will cause me
> grief...
> =

> =

> thanks again,
> now back to play
> barry bouwsma

Cool, I'm just CC the ML
I get questions (sometimes the exact same questions) from various of people=
. Lets use the ML to sync all...

Uri


      =


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
