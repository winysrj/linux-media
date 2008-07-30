Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6UDS9Ws018331
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 09:28:09 -0400
Received: from mail-in-16.arcor-online.net (mail-in-16.arcor-online.net
	[151.189.21.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6UDRs20003742
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 09:27:55 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080730001956.15c67493@gaivota>
References: <20080711231113.13054808@hyperion.delvare>
	<20080729121938.3d4668f4@gaivota>
	<1217385358.2671.28.camel@pc10.localdom.local>
	<20080730001956.15c67493@gaivota>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 15:21:08 +0200
Message-Id: <1217424068.3085.13.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Jean Delvare <khali@linux-fr.org>, v4l-dvb-maintainer@linuxtv.org,
	video4linux-list@redhat.com
Subject: Re: bt832 driver
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


Am Mittwoch, den 30.07.2008, 00:19 -0300 schrieb Mauro Carvalho Chehab:
> On Wed, 30 Jul 2008 04:35:58 +0200
> hermann pitton <hermann-pitton@arcor.de> wrote:
> 
> > Hi,
> > 
> > Am Dienstag, den 29.07.2008, 12:19 -0300 schrieb Mauro Carvalho Chehab:
> > > Hi Jean,
> > > 
> > > On Fri, 11 Jul 2008 23:11:13 +0200
> > > Jean Delvare <khali@linux-fr.org> wrote:
> > > 
> > > > Hi Mauro,
> > > > 
> > > > As part of the next big i2c-core change, I must update all the legacy
> > > > i2c drivers. I was about to update the bt832 driver, but found that
> > > > there was no reference to it in the build system. After adding a
> > > > reference to force it to build, I found that it wouldn't actually
> > > > build, because the last change to the driver broke it and apparently
> > > > nobody noticed. Looking at the code, the driver doesn't appear to be
> > > > functional.
> > > > 
> > > > So rather than wasting my time fixing this broken driver nobody is
> > > > using, I believe that it would be better to delete it. If this is OK
> > > > with you, here's a patch doing that. Thanks.
> > > 
> > > I'm ok with this removal.
> > > 
> > > Since you did your patch against -git, it doesn't apply at -hg. So, I've
> > > re-generated it. Please check if everything is all right. I did a small
> > > additional cleanup at bttv driver, since you've kept a test that is not needed
> > > anymore.
> > > 
> > > Cheers,
> > > Mauro.
> > 
> > I'm not sure, if any of you is aware about the extend of contribution we
> > have from Gunther.
> > 
> > Mauro should at least be a little.
> > 
> > To remove it likely is fine, but there should be at least an attempt to
> > inform the author.
> > 
> > http://www.bttv-gallery.de
> > 
> > is only a minor part of his work, but is still without any even close to
> > it.
> > 
> > Else I'm talking about several hundreds crucial and substantial patches
> > he provided in the past, not to forget that he is a coauthor of tuner.
> > 
> > I don't like that style to proceed, without even trying to reach those
> > on whose back and work we still stand.
> 
> 
> Hermann,
> 
> There's nothing personal on it. 
> 
> The points are:
> 
> - bt832 driver were written on 2002, according with the copyright message on
> the file (so, probably for some old bttv devices with a camera connection - are
> those devices still being used?);
> 
> - the messages on bttv driver states that it is currently not working yet (when
> this message were written? Probably, when the driver were inserted on kernel);
> 
> - the code that would load it or set it up on bttv is commented with #if 0;
> 
> - the Makefile's don't compile this driver.
> 
> I may be wrong, but it seems to me that this driver never worked.
> 
> It is fine for me if Gunther or anyone else wants to fix the driver. However,
> the way it is, I can't see any sense on keeping it on kernel.
> 
> Gunther,
> 
> What's your opinion about this driver?
> 
> Cheers,
> Mauro

Mauro,

I know there is nothing meant personal and the technical arguments seem
to be all correct.

Just, if we have some last known email address, we try to inform the
author, reachable or not, directly too.

This happened now and I think you can proceed.

An answer from Gunther, who is not around on the lists since a while,
would of course be even better.

I also would like to send him documentation about some new cards,
but also don't know if mails really come through currently.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
