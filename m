Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab2CYMm3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Mar 2012 08:42:29 -0400
Message-ID: <4F6F12A6.6030801@redhat.com>
Date: Sun, 25 Mar 2012 09:42:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Paulo Cavalcanti <promac@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org
Subject: Re: bttv 0.9.19 driver
References: <CAMgUmn=XLnTbKJaOegStdi8bDwO2GfnohuODFr8=UTaSeJeFgg@mail.gmail.com> <4F6CEBBA.6050705@redhat.com> <CAMgUmnnGddUoSh5=oTKOrGmY8jinUZ54tg78BVYe98=mHHMepQ@mail.gmail.com>
In-Reply-To: <CAMgUmnnGddUoSh5=oTKOrGmY8jinUZ54tg78BVYe98=mHHMepQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-03-2012 09:21, Paulo Cavalcanti escreveu:
> 
> 
> 
> 
>     There was a known regression at the radio core. Not sure when it happened, nor on what
>     kernel it were fixed. Could you please test a 3.x kernel?
> 
>     If you're a RHEL6 customer, you can open a case with via the proper
>     Red Hat channels, in order to backport fix it on RHEL6 kernel.
>     Yet, even in this case, it would be important to test the latest kernel,
>     to see if the fixes applied upstream fixes the issue.
> 
>     Thanks,
>     Mauro.
> 
> 
> Hi, Mauro
> 
> I tested other card ids, and the one that has always been chosen by the kernel (72) is working now:
> 
> options bttv card=72 radio=1 tuner=69 audiomux=0x21,0x20,0x23,0x23,0x28 gpiomask=0x3f vcr_hack=1 chroma_agc=1
> 
> In the past, this combination of tuner and card id had problems with the TV sound,
> but now either the radio, tv or remote is fine. I only did not test the composite input of the card.

Good.

> However, this is enough for me to maintain the analog radio packages in Fedora.
> 
> Regarding the 3.0 kernel, If I update the video4linux drivers to the latest snapshot (in my case 03/21/2012) doesn't it produce the same result?

It should produce the same results.

> I am also trying to keep rhel6 functional in ATrpms, and I realized that there was also some recent
> change (after 11/24/2011) that forced me to upgrade video4linux drivers to have
> vlc 2.0 working with ISDB-TB in previous kernels:
> 
> http://forum.videolan.org/viewtopic.php?f=13&t=99397 <http://forum.videolan.org/viewtopic.php?f=13&t=99397>

ISDB-T works on older kernels, via an emulation code at the Kernel. Userspace apps
thinks ISDB is DVB-T, so they all work.

The only think that doesn't work, via the emulation code, is radio broadcast. There are some
DVBv5 properties that need to be filled for it:

#define DTV_ISDBT_SOUND_BROADCASTING	19

#define DTV_ISDBT_SB_SUBCHANNEL_ID	20
#define DTV_ISDBT_SB_SEGMENT_IDX	21
#define DTV_ISDBT_SB_SEGMENT_COUNT	22

As there's no equivalent of those on DVB-T, and those parameters aren't automatically
detected by the (current) frontendds. So, only a program prepared to use them would
work. Also, not all ISDB drivers are prepared to work with those properties.

I never tested radio broadcast, as there aren't any such stations in Brazil,
so I can't tell if it works or not.

> I know this is a different topic, but would you know if mplayer is supporting ISDB-TB?

AFAIKT, mplayer doesn't support DVBv5 API, but, provided that you feed it with a proper
channels.conf file under ~/.mplayer, it works fine.

> While vlc and xine/kaffeine work, gstreamer and mplayer are still not working with ISDB-TB for me ...

Never tested gstreamer with ISDB-T.
> 
> Thanks.
> 
> -- 
> Paulo Roma Cavalcanti
> LCG - UFRJ

