Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m412QhN7016140
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 22:26:44 -0400
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net
	[151.189.21.50])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m412QFvE026894
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 22:26:16 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080430202547.1765d34c@gaivota>
References: <20080428182959.GA21773@orange.fr>
	<alpine.DEB.1.00.0804282103010.22981@sandbox.cz>
	<20080429192149.GB10635@orange.fr>
	<1209507302.3456.83.camel@pc10.localdom.local>
	<20080430155851.GA5818@orange.fr>
	<1209592608.31036.36.camel@pc10.localdom.local>
	<20080430202547.1765d34c@gaivota>
Content-Type: text/plain
Date: Thu, 01 May 2008 04:25:04 +0200
Message-Id: <1209608704.4381.18.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Card Asus P7131 hybrid > no signal
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

Am Mittwoch, den 30.04.2008, 20:25 -0300 schrieb Mauro Carvalho Chehab:
> > 
> > We have definitely issues on analog, but I can't test SECAM_L.
> > 
> > After ioctl2 conversion, the apps don't let the user select specific
> > subnorms like PAL_I, PAL_BG, PAL_DK and SECAM_L, SECAM_DK, SECAM_Lc
> > anymore.
> 
> Seems to be an issue at the userspace app. SAA7134_NORMS define a mask of supported
> norms. STD_PAL covers all the above PAL_foo. Also, SECAM covers all the above
> SECAM_foo.

I'll take it like that ;)

> If the userspace app sets V4L2_STD_PAL, the driver should run on autodetection
> mode. If, otherwise, the app sets V4L2_STD_PAL_I, the driver will accept and
> select PAL_I only.

At the moment they can't set anything than reported ;)

> > Internally the driver knows about all norms, but we have a clear
> > breakage of application backward compatibility and might see various
> > side effects. Especially, but not only for SECAM, it was important that
> > the users can select the exact norm themselves because of audio carrier
> > detection issues.
> 
> > 
> > It is firstly on 2.6.25.
> > 
> > If you are affected, apps like xawtv or mplayer will only report these
> > TV standards.
> 
> It shouldn't be hard to make enum_std to send all possible supported formats.
> Maybe this could be good for the apps you've mentioned.
> 
> In this case, a patch to videodev.c should replace the code after case
> VIDIOC_ENUMSTD to another one that would report the individual standards, plus
> the grouped ones.
> 
> Cheers,
> Mauro

I still have a story in mind, where an Austrian engineer appeared on
mplayers users list with some early saa7134 v4l2 stuff and what he got
told ;)

I hope we can trust on, that they are more friendly now ;)

Cheers,
Hermann







--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
