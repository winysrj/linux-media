Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2ID0o1D016488
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 09:00:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2ICxvXJ005169
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 08:59:57 -0400
Date: Tue, 18 Mar 2008 09:59:09 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <20080318095909.4f8830ea@gaivota>
In-Reply-To: <200803181339.13040.zzam@gentoo.org>
References: <200803161131.37966.zzam@gentoo.org>
	<20080318092648.3a517301@gaivota>
	<200803181339.13040.zzam@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	Peter Meszmer <hubblest@web.de>
Subject: Re: [PATCH] Updated analog only support of Avermedia A700 cards -
 adds RF input support via XC2028 tuner (untested)
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

On Tue, 18 Mar 2008 13:39:12 +0100
Matthias Schwarzott <zzam@gentoo.org> wrote:

> On Dienstag, 18. März 2008, Mauro Carvalho Chehab wrote:
> > On Sun, 16 Mar 2008 11:31:37 +0100
> >
> > For this to work, you'll need to set xc3028 parameters. This device needs a
> > reset during firmware load. This is done via xc3028_callback. To reset, you
> > need to turn some GPIO values, and then, return they back to their original
> > values. The GPIO's are device dependent. So, you'll need to check with some
> > software like Dscaler's regspy.exe what pins are changed during reset.
> 
> I can only have a look at the wiring.

This may help, but should be validated with the hardware test, since it may
need to enable/disable more than one bit.

> > Also, there are two ways for audio to work with xc3028/2028: MTS mode and
> > non-mts. You'll need to test both ways.
> >
> > A final notice: most current devices work fine with firmware v2.7. However,
> > a few devices only work if you use an older firmware version.
> >
> > Could you please send us the logs with i2c_scan=1?
> >
> 
> I do not have that hardware. I only have the A700 without XC2028 soldered on 
> it. But maybe Peter can help out on this.

It would be nice if he could help us.
 
> > Please, use the latest version of v4l-dvb, since I did some fixes for cx88
> > and saa7134 there recently.
> >
> I do use latest v4l-dvb tree and create patches on top of this.
> As this card is labled Hybrid+FM I should also add a radio section, I guess.

Yes, but you've already added it. Radio entry is generally identical to TV, on
the devices with xc3028. I suspect that your radio entry should work.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
