Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n4.bullet.ukl.yahoo.com ([217.146.182.181])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <newspaperman_germany@yahoo.com>) id 1KlOcF-0000bZ-3I
	for linux-dvb@linuxtv.org; Thu, 02 Oct 2008 15:53:16 +0200
Date: Thu, 2 Oct 2008 13:52:30 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <1a18e9e80810011521o35f59ba5k658ab5f2c70cbfeb@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <395581.38574.qm@web23201.mail.ird.yahoo.com>
Subject: Re: [linux-dvb] Re : Re : TT S2-3200 driver
Reply-To: newspaperman_germany@yahoo.com
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

I didn't experience any differences with dvb-s2 channels.
Those problematic transponders always produces corrupted video streams. It'=
s always DVB-s2 30000 3/4. When entering SR of 29999 I get constant lock, b=
ut the stream is corrupted. 1 HD channel has only a VideoRate of 4,5 MBit a=
nd audio 77 kbit/s :(


kind regards

Newsy

--- Meysam Hariri <meysam.hariri@gmail.com> schrieb am Do, 2.10.2008:

> Von: Meysam Hariri <meysam.hariri@gmail.com>
> Betreff: [linux-dvb]  Re : Re : TT S2-3200 driver
> An: linux-dvb@linuxtv.org
> Datum: Donnerstag, 2. Oktober 2008, 0:21
> Hi,
> =

> thanks for your update. i used a TT-3200 device and
> here's the results:
> - i couldn't lock on some S2 channels or those
> 'bad' channels, although i
> could get unstable lock on these channels using the
> unpatched version, but
> resulting in corrupted data. so the unpatched version still
> works a bit
> better.
> - the lock on QPSK S2 channels is fast and stable as it was
> with the
> unpatched version
> - locking on dvb-s channels is also fast and stable
> =

> i'm ready to test any further updates.
> =

> Regards,
> =

> =

> 2008/10/1 Alex Betis <alex.betis@gmail.com>
> =

> Hi all,
> >
> > My description of the solution is here:
> >
> http://www.linuxtv.org/pipermail/linux-dvb/2008-September/029361.html
> >
> > I've also attaching the patches to this thread.
> >
> > Several people reported better lock on DVB-S channels.
> >
> > Just to clarify it, the changes mostly affect DVB-S
> channels scanning, it
> > doesn't help with DVB-S2 locking problem since the
> code is totally different
> > for S and S2 signal search.
> >
> > I've increased a timer for S2 signal search and
> decreased the search step,
> > this helps to lock on "good" S2 channels
> that were locked anyway with
> > several attempts, but this time it locks from first
> attempt. The "bad"
> > channels finds the signal, but the FEC is unable to
> lock.
> > Since searching of S2 channels is done in the card and
> not in the driver,
> > its pretty hard to know what is going on there.
> >
> > Can't say what happens with the lock on
> "good" channels since I don't have
> > any S2 FTA in my sight.
> >
> > If anyone has any progress with S2 lock, let me know,
> I'd like to join the
> > forces.
> >
> >
> >
> > On Tue, Sep 30, 2008 at 12:48 PM, Alex Betis
> <alex.betis@gmail.com> wrote:
> >
> >> I'll send the patches to the list as soon as
> I'll finish some more
> >> debugging and clean the code from all the garbage
> I've added there.
> >>
> >> Meanwhile I'd also like to wait for few people
> responses who test those
> >> patches. So far one person with Twinhan 1041 card
> confirmed that the changes
> >> "improved a lot" the locking. Waiting
> for few more people with TT S2-3200 to
> >> confirm it.
> >>
> >>
> >> On Tue, Sep 30, 2008 at 12:35 PM, Newsy Paper <
> >> newspaperman_germany@yahoo.com> wrote:
> >>
> >>> Hi Alex!
> >>>
> >>> This souds like good news!
> >>> Hope you could help us with a patch from you.
> >>>
> >>> kind regards
> >>>
> >>>
> >>> Newsy
> >>>
> >>>
> >>> --- Alex Betis <alex.betis@gmail.com>
> schrieb am Mo, 29.9.2008:
> >>>
> >>> > Von: Alex Betis
> <alex.betis@gmail.com>
> >>> > Betreff: Re: [linux-dvb] Re : Re : TT
> S2-3200 driver
> >>> > An: "Jelle De Loecker"
> <skerit@kipdola.com>
> >>> > CC: "linux-dvb"
> <linux-dvb@linuxtv.org>
> >>> > Datum: Montag, 29. September 2008, 16:13
> >>> > Does that card use stb0899 drivers as
> Twinhan 1041?
> >>> >
> >>> > I've done some changes to the
> algorithm that provide
> >>> > constant lock.
> >>> >
> >>> > 2008/9/29 Jelle De Loecker
> <skerit@kipdola.com>
> >>> >
> >>> > >
> >>> > > manu schreef:
> >>> > >
> >>> > > Le 13.09.2008 19:10:31, Manu Abraham
> a =E9crit :
> >>> > >
> >>> > >
> >>> > >  manu wrote:
> >>> > >
> >>> > >
> >>> > >  I forgot the logs...
> >>> > >
> >>> > >
> >>> > >  Taking a look at it. Please do note
> that, i will have
> >>> > to go through
> >>> > > it
> >>> > > very patiently.
> >>> > >
> >>> > > Thanks for the logs.
> >>> > >
> >>> > >
> >>> > >
> >>> > >  You're more than welcome. I
> tried to put some
> >>> > printk's but the only
> >>> > > thing I got is that even when the
> carrier is correctly
> >>> > detected, the
> >>> > > driver does not detect the data
> (could that be related
> >>> > to the different
> >>> > > FEC?).
> >>> > > Anyway let me know if you need more
> testing.
> >>> > > Bye
> >>> > > Manu
> >>> > >
> >>> > >
> >>> > > I'm unable to scan the channels
> on the Astra 23,5
> >>> > satellite
> >>> > > Frequency 11856000
> >>> > > Symbol rate 27500000
> >>> > > Vertical polarisation
> >>> > > FEC 5/6
> >>> > >
> >>> > > Is this because of the same bug? I
> should be getting
> >>> > Discovery Channel HD,
> >>> > > National Geographic Channel HD,
> Brava HDTV and Voom HD
> >>> > International, but
> >>> > > I'm only getting a time out.
> >>> > >
> >>> > >
> >>> > > *Met vriendelijke groeten,*
> >>> > >
> >>> > > *Jelle De Loecker*
> >>> > > Kipdola Studios - Tomberg
> >>> > >
> >>> > >
> >>> > >
> >>> > >
> _______________________________________________
> >>> > > linux-dvb mailing list
> >>> > > linux-dvb@linuxtv.org
> >>> > >
> >>> >
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >>> > >
> >>> >
> _______________________________________________
> >>> > linux-dvb mailing list
> >>> > linux-dvb@linuxtv.org
> >>> >
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >>>
> >>>
> >>>
> >>>
> >>>
> >>>
> _______________________________________________
> >>> linux-dvb mailing list
> >>> linux-dvb@linuxtv.org
> >>>
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >>>
> >>
> >>
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> >
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


      __________________________________________________________
Gesendet von Yahoo! Mail.
Dem pfiffigeren Posteingang.
http://de.overview.mail.yahoo.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
