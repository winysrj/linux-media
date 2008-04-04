Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m342V0Zi026054
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 22:31:00 -0400
Received: from mail-in-06.arcor-online.net (mail-in-06.arcor-online.net
	[151.189.21.46])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m342UfBV004457
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 22:30:41 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080403221833.34d3c4d6@gaivota>
References: <1115343012.20080318233620@a-j.ru>
	<200803200048.15063@orion.escape-edv.de>
	<1206067079.3362.10.camel@pc08.localdom.local>
	<200803210742.57119@orion.escape-edv.de>
	<1206912674.3520.58.camel@pc08.localdom.local>
	<1063704330.20080331082850@a-j.ru>
	<1206999694.7762.41.camel@pc08.localdom.local>
	<1112443057.20080402224744@a-j.ru>
	<1207179525.14887.13.camel@pc08.localdom.local>
	<1207265002.3364.12.camel@pc08.localdom.local>
	<20080403221833.34d3c4d6@gaivota>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 04:19:05 +0200
Message-Id: <1207275545.3365.26.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Michael Krufky <mkrufky@linuxtv.org>,
	linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT S-1401 problem with kernel 2.6.24 ???
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

Am Donnerstag, den 03.04.2008, 22:18 -0300 schrieb Mauro Carvalho
Chehab:
> On Fri, 04 Apr 2008 01:23:22 +0200
> hermann pitton <hermann-pitton@arcor.de> wrote:
> 
> > Am Donnerstag, den 03.04.2008, 01:38 +0200 schrieb hermann pitton:
> > > Hi again,
> > > 
> > > Am Mittwoch, den 02.04.2008, 22:47 +0400 schrieb Andrew Junev:
> > > > Hello Hermann,
> > > > 
> > > > Thanks a lot for this detailed explanation!
> > > > I really appreciate your help!
> > > > 
> > > > One small question: does it mean that kernels 2.6.24.5 or 2.6.24.6
> > > > _should_ have this patch already included?
> > > > 
> > > 
> > > seems we hang in current stable kernel rules.
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob_plain;f=Documentation/stable_kernel_rules.txt;hb=HEAD
> > > 
> > > If we go back to 2.6.23 level, that patch might have less than 100 lines
> > > with context, but we break the
> > > 
> > >  - It must fix only one thing
> > > 
> > > rule, since we break the 2.6.24 LifeView Trio DVB-S support too then.
> > > 
> > > Seems sombody with such a device should reopen the bug on Bugzilla ...
> > > 
> > 
> > Hi Guys,
> > 
> > should we really let hang it like this on 2.6.24?
> > 
> > I'm not that happy with a recommendation for the distributions to pick
> > something out of it.
> > 
> > If we should go back to 2.6.23 level, so far nobody seems to have
> > realized a improvement for the LifeView Trio stuff, I'm not against it.
> > 
> > The changeset in question to revert is mercurial 6579.
> > 
> > If nobody else is interested and no comments, I also don't care anymore.
> 
> I don't see why to revert changeset 6579. On changeset 7186, an option were added at the frontend structure, to allow specify if diseqc requires a modulated signal or not. It is just a matter of changing the struct. Something like:
> 
>  static struct tda10086_config dvbs_card1 = {
>         .demod_address = 0x0e,
>         .invert = 0,
>         .diseqc_tone = 0,	/* Non-modulated tone - The default behavior after changeset 6579 */
>  };
> 
>  static struct tda10086_config dvbs_card2 = {
>         .demod_address = 0x0e,
>         .invert = 0,
>         .diseqc_tone = 1,	/* modulated tone - The default behavior before changeset 6579 */
>  };
> 
> The problem seems to be related to this struct:
> 
> static struct tda10086_config flydvbs = {
>         .demod_address = 0x0e,
>         .invert = 0,
>         .diseqc_tone = 0,
> };
> 
> is currently in use by several variants:
> 	SAA7134_BOARD_FLYDVB_TRIO,
> 	SAA7134_BOARD_MEDION_MD8800_QUADRO,
> 	SAA7134_BOARD_FLYDVBS_LR300,
> 	SAA7134_BOARD_PHILIPS_SNAKE,
> 	SAA7134_BOARD_MD7134_BRIDGE_2.
> 
> Probably, some of those boards need .diseqc_tone=1 while others require .diseqc_tone=0.
> 
> What are the boards that are currently broken?
> 
> Cheers,
> Mauro

Mauro,

as far I can see on v4l-dvb master, none. On 2.6.25 none. On 2.6.26 we
will have some new fun.

What Hartmut added is fully sufficient.

The problen is only on 2.6.24.something currently.

We can't add the necessarry fix currently, because above 100 lines
including context are not allowed bullshit we have to face. To go below
it, 2.6.23, means to break the Trio DVB-S stuff you took in from
Bugzilla. It is not the first time that something goes wrong here and I
really don't like the _pisszilla_ ;;) at all.

Too much comes easily in to just please and do a favour, but not on
devel and crosschecked level.

We have the right point I think, we can't accept some idiotic 100 lines
restriction including context here for a fix.

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
