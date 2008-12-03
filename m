Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp27.orange.fr ([80.12.242.95])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1L7pMs-0000We-4y
	for linux-dvb@linuxtv.org; Wed, 03 Dec 2008 11:54:07 +0100
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Wed, 3 Dec 2008 11:53:31 +0100
References: <412bdbff0812021455n221ee909nba6c7e546f1a0650@mail.gmail.com>
	<412bdbff0812021521m163a4d61q52e96de4cf3d2518@mail.gmail.com>
	<200812031123.14065.Nicola.Sabbi@poste.it>
In-Reply-To: <200812031123.14065.Nicola.Sabbi@poste.it>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812031153.31517.hftom@free.fr>
Cc: Nico Sabbi <Nicola.Sabbi@poste.it>
Subject: Re: [linux-dvb] Pinnacle 80e support: not going to happen...
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

Le mercredi 3 d=E9cembre 2008 11:23:14 Nico Sabbi, vous avez =E9crit=A0:
> On Wednesday 03 December 2008 00:21:08 Devin Heitmueller wrote:
> > On Tue, Dec 2, 2008 at 6:10 PM, Markus Rechberger
>
> <mrechberger@gmail.com> wrote:
> > > On Tue, Dec 2, 2008 at 11:55 PM, Devin Heitmueller
> > >
> > > <devin.heitmueller@gmail.com> wrote:
> > >> For those of you waiting for Linux support for the Pinnacle 80e,
> > >> I have some bad news:  it's not going to happen.
> > >>
> > >> After investing over 100 hours doing the driver work, adding
> > >> support for the Empia em2874, integrating with the Linux
> > >> tda18271 driver, incorporating the Micronas drx reference driver
> > >> source, and doing all the testing, Micronas has effectively
> > >> killed the project.  They decided that their intellectual
> > >> property was too valuable to make available their reference
> > >> driver code in source code form.  Even worse, because I've seen
> > >> the sources I am effectively prevented from writing any sort of
> > >> reverse engineered driver for the drx-j.
> > >
> > > Not so fast, even though I wasn't involved at knocking this down.
> > > We have a custom player now which is capable of directly
> > > interfacing the I2C chips from those devices. Another feature is
> > > that it supports all the features of those devices, there won't
> > > be any need of different applications anymore. There's also the
> > > thought about publishing an SDK, most applications have problems
> > > of detecting all corresponding devicenodes which are required for
> > > those devices anyway. i2c-dev is an already available and
> > > accepted kernel interface
> > > to userland just as usbfs is.
> >
> > Hello Markus,
> >
> > Yeah, I saw the screenshots for Empia eeeTV on your website a few
> > days ago - it looks like a neat application and there is certainly
> > a place for a well written application to watch TV.
> >
> > For those of you not familiar, Markus is working on his own
> > dedicated TV watching application for Linux and BSD:
> > http://mcentral.de/wiki/index.php5/ISDB-T
> >
> > I agree that it is certainly true that a closed-source application
> > could be used with the Pinnacle 80e (since such application would
> > be able to accommodate the Micronas binary-only licensing), however
> > this approach does restrict access to those devices to that
> > specific application and is not a more general solution that would
> > work with whatever application the user wants to use (such as
> > MythTV, Kaffeine, mplayer, etc).
> >
> > So for many people, this could be a viable approach.
> >
> > Regards,
> >
> > Devin
>
> what makes Micronas believe that in order to have the High Privilege
> of using their products bought with their money people are willing to
> sacrifice their freedom and hope that someone will adapt
> existing players? I can tell you with absolute certainty that mplayer
> will never adapt and I will reject any (unlikely to come) patch to
> support that library

Ack.
Anyway, such a lib will never get its way in Linux distributions.
There is lots of good hardware with linuxtv drivers around.
Maybe someone should tell Micronas that what they are looking for is called =

microsoft.

Giving a reference driver to Devin to say latter "aha, you are damned now" =
is =

not only unpolite but also uncivilized. =


-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
