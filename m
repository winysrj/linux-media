Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8FLw6SA000941
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 17:58:07 -0400
Received: from mail-in-08.arcor-online.net (mail-in-08.arcor-online.net
	[151.189.21.48])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8FLvpSE027478
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 17:57:51 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080915012640.51c86e04@areia.chehab.org>
References: <48C4FC1F.40509@comcast.net>
	<20080911103801.52629349@mchehab.chehab.org>
	<1221359719.6598.31.camel@pc10.localdom.local>
	<20080915012640.51c86e04@areia.chehab.org>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 23:53:53 +0200
Message-Id: <1221515633.2715.41.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Schultz <n9xmj@yahoo.com>,
	Henry Wong <henry@stuffedcow.net>, v4ldvb@linuxtv.org,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: [PATCH] Add support for MSI TV@nywhere Plus remote
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

Hi,

Am Montag, den 15.09.2008, 01:26 -0300 schrieb Mauro Carvalho Chehab:
> On Sun, 14 Sep 2008 04:35:19 +0200
> hermann pitton <hermann-pitton@arcor.de> wrote:
> 
> > Mauro,
> > 
> > this is the oldest and most important outstanding patch we have.
> > 
> > There are whole generations of cards still without of any IR support,
> > since years, because of that.
> > 
> > If this one should still hang on coding style violations, please let me
> > know.
> 
> I'll handle this patch soon. I'm currently away (in Portland, due to Plumbers
> and KS conferences), so, maybe I'll wait until the next week for committing it.

fine. My small other stuff will cause no merge conflicts.

> > If you would ever find time again, have a look at my patch enabling
> > first support for the new Asus Tiger 3in1, which I have only as an OEM
> > board, but which is coming up to global distribution now and likely will
> > cover all newer boards.
> 
> Could you please forward it me again any pending patches? Better if you can do
> it at the beginning of the next week. If I don't answer about a patch in about
> one week, the better is to ping me about it.
> 
> > I wasted some time again, to fit into the 80 columns rule on
> > saaa7134-dvb.c, and all I can say is, this way not with me.
> 
> The 80 cols rule is just a warning. On some cases, it helps to improve
> readability. Also, it is generally easier to review codes that fit on 80 cols,
> since it helps me to open a window comparing a file and a patched version with
> some tool like kdiff3, where the several file revisions are presented side by side.
> 
> > Please exercise it yourself now, you have all relevant information, show
> > the resulting code and explain, why such crap should be looking good.
> 
> I did my self some coding style patches and the end result was an easier to
> read code. As already discussed, such warnings/errors should be used as a hint
> of troubles, not as absolute rules.
> 

I cooled down next day and a patch within 80 columns is on the lists :)

Please pick up this one first and report any issues.

I'll provide the other few patches then next weekend.

Good times in Portland, peace and cooperation.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
