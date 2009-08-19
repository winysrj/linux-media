Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7J1daTO007534
	for <video4linux-list@redhat.com>; Tue, 18 Aug 2009 21:39:36 -0400
Received: from mail-in-14.arcor-online.net (mail-in-14.arcor-online.net
	[151.189.21.54])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7J1dHJh009577
	for <video4linux-list@redhat.com>; Tue, 18 Aug 2009 21:39:18 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
In-Reply-To: <829197380908181754u71db6cb7sdaaa7443ebb765bb@mail.gmail.com>
References: <80f602570908181155v71e96a45q4563cd330ee4e5f0@mail.gmail.com>
	<829197380908181204u5df55094l94b43141570f7f37@mail.gmail.com>
	<1250637598.4012.9.camel@localhost.localdomain>
	<829197380908181754u71db6cb7sdaaa7443ebb765bb@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 03:33:24 +0200
Message-Id: <1250645604.3224.27.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: fbtv 3.95 & vdr 1.4.5: closing fbtv causes vdr freeze
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Am Dienstag, den 18.08.2009, 20:54 -0400 schrieb Devin Heitmueller:
> On Tue, Aug 18, 2009 at 7:19 PM, Christian Neumair<cneumair@gnome.org> wrote:
> > Am Dienstag, den 18.08.2009, 15:04 -0400 schrieb Devin Heitmueller:
> >> On Tue, Aug 18, 2009 at 2:55 PM, Christian Neumair<cneumair@gnome.org> wrote:
> >> > Dear video4linux-list,
> >> >
> >> > I observed a problem with an ancient easyVDR distribution from 2007 which
> >> > uses vdr 1.4.5 (c't vdr), fbtv 3.95, and kernel 2.6.22.5: As soon as I quit
> >> > fbtv with ctrl-c, vdr turns into a CPU hog and has to be killed. This is
> >> > unfortunate, because in my setup I only want to use the local fbtv frontend
> >> > occassionally, while permanently using the remote VOMP plugin. Is this a
> >> > known issue? Can you reproduce it with recent vdr and fbtv versions? Can I
> >> > do anything to debug the issue?
> >> >
> >> > Thanks in advance!
> >> >
> >> > best regards,
> >> >  Christian Neumair
> >>
> >> You're probably not going to find a developer willing to spend the
> >> cycles to debug an ancient version of VDR on an ancient kernel.  Your
> >> best bet is to update to the latest version and see if the problem
> >> still occurs.  Fortunately it seems like the issue is highly
> >> reproducible for you, so seeing if it occurs in the latest version
> >> should be pretty straightforward.
> >>
> >> So if you are looking to help debug the issue, answer your own
> >> question: "Can you reproduce it with recent vdr and fbtv versions?"
> >
> > Come on, we are all developers.
> >
> > In an attempt to keep my running and carefully configured system intact,
> > I can not blindly upgrade anything. I prefer to apply a patch for this
> > very specific issue. Upgrading the entire system wouldn't help either
> > because it does not help me to isolate the cause of the bug.
> >
> > Unfortunately, I don't have a clue about the precise vdr/fbtv/v4l IPC.
> > If anybody could give me an overview over the mechanisms or code paths,
> > I could try to grep in the sources myself.
> >
> > Thanks in advance!
> >
> > best regards,
> >  Christian Neumair
> >
> > PS: As a Nautilus maintainer, the "please upgrade to the latest
> > version(s)" hint is well-known from GNOME bugzilla, and I don't like it
> > at all, to say the least. From a developer perspective, it is always
> > desirable to find out why and how an issue was fixed because otherwise
> > you can't guarantee that it was really fixed, but instead it may have
> > been obfuscated by another issue.
> 
> You shouldn't interpret the above as some sort of insult.  As a open
> source maintainer, I'm sure you are familiar with the notion of being
> understaffed and unable to support every version ever released.  If I
> opened a bug tomorrow saying that I'm running Fedora 7 on PPC and when
> I open Nautilus I get kicked back to the Gnome login prompt, how much
> attention do you think it would get from the Gnome dev team?  We all
> have to live in the real world and make compromises, which in this
> case means we can't burn the cycles to support two year old releases.
> 
> People who need *that* level of support usually have commercial
> support contracts.
> 
> That said, if you really want to debug the issue, the place to start
> is probably to get a serial console hooked up, setup the sysrq key and
> get a stack dump when the thing hangs.  Then at least we might have
> *some* idea where the driver is locking up the system.  You should
> probably also figure out what type of card you have, what driver it
> uses, and what kernel you are running, so there is some context to how
> many thousands of revisions old the v4l-dvb tree you are running is.
> 
> Devin
> 

I agree with both of you ;)

We don't have the resources to provide an ideal world on stuff years
back.

Not to have it ;), is of course a door for all kind of diseases.

And we have those in high density on some uncertain parts!

Other parts are free from such, currently, but it never stops ...

To be a little annoying again. Example, we had hard times to identify
the newer Asus devices, just on the current run for all manufacturers
till now, but got some job done. It helped, that they had different PCI
subsystem IDs, and that I complained endlessly, please don't put them
all on my first working card ever and let's try to become better.

We have a _lot_ of different cards now, we can cover. Next is around.

However, the same has obviously happened on the Pinnacle 310i and, much
later, on Hauppauge saa7134 HVR 1110 variants.

So, we have that mess, and can't get anything out of supposed best
related guys by either method. Do they really try, what fails?

Either praying or kicking doesn't help at all.

/me, confirms that such problems exist on such cards and at all :)

The first Pinnacle 310i was _without_ any LNA support.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
