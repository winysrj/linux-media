Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m81E51Qm012046
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 10:05:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m81E4mww008368
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 10:04:48 -0400
Date: Mon, 1 Sep 2008 11:03:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Lee Alkureishi <lee_alkureishi@hotmail.com>
Message-ID: <20080901110337.442e207e@mchehab.chehab.org>
In-Reply-To: <BAY126-W51445FEADC96EC0484E7ABE35D0@phx.gbl>
References: <BAY126-W51445FEADC96EC0484E7ABE35D0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, alkureishi.lee@gmail.com
Subject: Re: em2820, Tena TNF-9533 and V4L
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

On Sun, 31 Aug 2008 19:26:51 +0100
Lee Alkureishi <lee_alkureishi@hotmail.com> wrote:

> 
> Hi all,
> 
> Hoping someone on this list can help me with this frustrating problem:
> 
> I'm running Mythbuntu 8.04, fully updated. I'm trying to set up a USB TV tuner box, and have made progress but haven't quite got it working. 
> 
> The USB box is a Kworld PVR TV 2800 RF. It uses a Empia em2820 chipset, and a Tena TNF-9533-D/IF tuner. Other chips I found under the casing are:
> RM-KUB03 04AEAAC6, HEF4052BT, TEA5767, SAA7113H. 

I have a device with similar chips. All of them are supported. TNF9533-D is PAL, afaik.

> (I had to manally tell modprobe to set the card type (18) and tuner type (61), as it does not have an EPROM. Took me forever to figure that out!

It is possible to add some autodetection for it. Are you using the driver at http://linuxtv.org/hg/v4l-dvb, right? On its dmesg log, it will print some codes that helps to do some tricks for detecting it, based on I2C scan signature.

> The problem arises when I try to do anything with it, though: I've tried a few programs, including mythTV, tvtime and xawtv. I can't find a way to select the TUNER as the input source. The only options are "composite1" or "s-video1".

It seems that you're selecting a different board type.

> I tried cycling through input=1 through 4, but they didn't work either (2 through 4 give an error about the card not being able to set its input).

The proper procedure is to run an usb snoop tool that allows us to know what is the pinup of certain generic entries used to select between tuner/composite/svideo.

> The only thing I can think of, is that the tuner may actually have originated outside the USA (i.e. the UK). Would that stop it from working with NTSC channels? And even so, should the composite input not still work? (And why can't I even select the tuner!?).

The tuner won't work properly in US, since the analog filters inside the tuner is different. Composite should work fine.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
