Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from scing.com ([217.160.110.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janne-dvb@grunau.be>) id 1KiIMd-0002GI-P8
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 02:36:20 +0200
From: Janne Grunau <janne-dvb@grunau.be>
To: linux-dvb@linuxtv.org
Date: Wed, 24 Sep 2008 02:36:14 +0200
References: <20080923181628.10797e0b@mchehab.chehab.org>
	<a3ef07920809231506h722c9fd4h1e3b8c3e40ca32cb@mail.gmail.com>
In-Reply-To: <a3ef07920809231506h722c9fd4h1e3b8c3e40ca32cb@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809240236.15144.janne-dvb@grunau.be>
Subject: Re: [linux-dvb] [ANNOUNCE] DVB API improvements
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Wednesday 24 September 2008 00:06:59 VDR User wrote:
> On Tue, Sep 23, 2008 at 2:16 PM, Mauro Carvalho Chehab
>
> <mchehab@infradead.org> wrote:
> > The DVB BOF had the presence of the following LinuxTV members:
> >
> >        Douglas Schilling Landgraf
> >        Hans Verkuil
> >        Mauro Carvalho Chehab
> >        Michael Krufky
> >        Patrick Boettcher
> >        Steven Toth
> >        Thierry Merle
> >        Manjunath Hadlii
>
> At least half of that list already pledged their support for S2API
> and based on past observations, I seriously doubt the meeting was
> unbiased and a decision made based on strictly technical aspects.

So you doubt anyone who previously stated his opinion on multiproto or =

S2API is unable to make a decision on technical merrits? Since most =

linuxtv devs already gave their opinion on the API proposal nobody is =

able to make a decision. =


> I also believe the panel should consist of people intimately familiar
> with DVB, not half people who aren't and the other half people who've
> already made up their mind.  Call me crazy but I don't see how a
> legitimate discussion can take place under those conditions.

Are you going to sponser and organize a meeting of all linuxtv DVB =

developers?
I agree that it would have been nice if more developers and especially =

Manu would have been at the DVB BOF. But more than 2/3 (849/1245) of =

the commits to drivers/media/dvb in the last 1000 days were done by =

people present at the meeting. It's not completly unreasonable to treat =

a decision of that group as a decission of the linuxtv developers.

> > The main arguments in favor of S2API over Multiproto are:
> >
> >        - Future proof =96 the proposal for S2API is more flexible,
> > easily allowing the addition of newer features and new standard
> > support;
> >
> >        - Simplicity =96 S2API patches are very simple, while
> > Multiproto presented a very complex series of changes. Simpler
> > approaches reduces the time for maintaining the source code;
> >
> >        - Capability of allowing improvements even on the existing
> > standards, like allowing diversity control that starts to appear on
> > newer DVB devices.
>
> My previous comment aside, I would like to ask for a more detailed
> explanation that justifies these arguments,

I support that, please be more verbose.

Janne

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
