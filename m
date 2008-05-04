Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m44N310M002440
	for <video4linux-list@redhat.com>; Sun, 4 May 2008 19:03:01 -0400
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net
	[151.189.21.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m44N2f9x018222
	for <video4linux-list@redhat.com>; Sun, 4 May 2008 19:02:41 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <481E219C.50008@t-online.de>
References: <20080428182959.GA21773@orange.fr>
	<alpine.DEB.1.00.0804282103010.22981@sandbox.cz>
	<20080429192149.GB10635@orange.fr>
	<1209507302.3456.83.camel@pc10.localdom.local>
	<20080430155851.GA5818@orange.fr>
	<1209592608.31036.36.camel@pc10.localdom.local>
	<20080430202547.1765d34c@gaivota>  <481E219C.50008@t-online.de>
Content-Type: text/plain
Date: Mon, 05 May 2008 01:01:24 +0200
Message-Id: <1209942084.2555.14.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
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

Am Sonntag, den 04.05.2008, 22:50 +0200 schrieb Hartmut Hackmann:
> Hi, Mauro
> 
> Mauro Carvalho Chehab schrieb:
> >> We have definitely issues on analog, but I can't test SECAM_L.
> >>
> >> After ioctl2 conversion, the apps don't let the user select specific
> >> subnorms like PAL_I, PAL_BG, PAL_DK and SECAM_L, SECAM_DK, SECAM_Lc
> >> anymore.
> > 
> > Seems to be an issue at the userspace app. SAA7134_NORMS define a mask of supported
> > norms. STD_PAL covers all the above PAL_foo. Also, SECAM covers all the above
> > SECAM_foo.
> > 
> > If the userspace app sets V4L2_STD_PAL, the driver should run on autodetection
> > mode. If, otherwise, the app sets V4L2_STD_PAL_I, the driver will accept and
> > select PAL_I only.
> > 
> >> Internally the driver knows about all norms, but we have a clear
> >> breakage of application backward compatibility and might see various
> >> side effects. Especially, but not only for SECAM, it was important that
> >> the users can select the exact norm themselves because of audio carrier
> >> detection issues.
> > 
> It is not only Audio carrier selection:
> SECAM-L is the only standard with positive modulation of the vision carrier.
> The tuner needs to know this. So in the case of SECAM-L, we need the *exact*
> standard.
> The insmod option secam=l transfers the exact standard to the tuner.
> 
> By the way: I just noticed this: If saa713x does not identify the color system
> (improperly forced), tvtime will say "no signal"
> 
> >> It is firstly on 2.6.25.
> >>
> >> If you are affected, apps like xawtv or mplayer will only report these
> >> TV standards.
> > 
> > It shouldn't be hard to make enum_std to send all possible supported formats.
> > Maybe this could be good for the apps you've mentioned.
> > 
> > In this case, a patch to videodev.c should replace the code after case
> > VIDIOC_ENUMSTD to another one that would report the individual standards, plus
> > the grouped ones.
> > 
> > Cheers,
> > Mauro
> > 
> Best regards
>    Hartmut


We also can't set the tuner type per card anymore, for the benefit to
fix the eeprom detection of tuners, that prior ability, which Gerd did
hold above eeprom tuner detection, likely to escape from too much
cleverness on bttv, is lost and glued to the card.

If we are going to run in circles, we should decide something viable
soon.

Cheers,
Hermann
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
