Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:61040 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3I0LGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Sep 2013 07:06:46 -0400
Date: Fri, 27 Sep 2013 13:06:44 +0200 (CEST)
From: remi <remi@remis.cc>
Reply-To: remi <remi@remis.cc>
To: =?UTF-8?Q?Nguy=E1=BB=85n_Minh_Ho=C3=A0ng?=
	<minhhoang1004@yahoo.com>
Cc: linux-media@vger.kernel.org
Message-ID: <52966910.313114.1380280004856.open-xchange@email.1and1.fr>
In-Reply-To: <293EC746-6C7C-4ED3-9509-1FA868AB9661@yahoo.com>
References: <1379785395.42997.YahooMailNeo@web162903.mail.bf1.yahoo.com> <259638318.304490.1380270295589.open-xchange@email.1and1.fr> <293EC746-6C7C-4ED3-9509-1FA868AB9661@yahoo.com>
Subject: Re: Need help with AverMedia306 driver on linux system.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oh, I am not the person who wrote the driver ... :(


I merly cloned the HC81r, gave it the proper PCI ID, and the correct firmware ,

I also have no DVB either,

Unless I get time to learn V4L API, or the mainter of the "xc2028" finds more
infos too ...

we are prety much at this stage, some analog, but no dvb ...

at my knowlodge .


Best regards

Rémi




> Le 27 septembre 2013 à 12:46, Nguyễn Minh Hoàng <minhhoang1004@yahoo.com> a écrit :
> 
> 
> Thank you for your relying. I know that your patch is not same my revision, i can't apply it. I think i should find and add your patches manually, but there are so much code to do. I am on phone now. I will send you some more detail when i am back to my computer. Pls help me. 
> Ps: i used "option=39" before, my system got it as video and vbi device, not dvb device. Maybe i need some patches in this case as your suggestion today.
> Thank you again!
> 
> Sent from my iPhone
> 
> > On Sep 27, 2013, at 3:24 PM, remi <remi@remis.cc> wrote:
> > 
> > :)
> > 
> > Also,
> > 
> > 
> > by the time I redo the patch,
> > 
> > 
> > You must have seen how i have reached this point,
> > 
> > I have actually started by insering the module with card=39 as an option,
> > 
> > 
> > So you can for now, add theses line to
> > 
> > gpunk@gpunk-Aspire-8930:~$cat /etc/modprobe.d/video-tv.conf
> > 
> > 
> > options tuner-xc2028 firmware_name=xc3028-v27.fw
> > options cx23885 card=39
> > 
> > 
> > I called my file this way ... it's arbitrary, please check the man modprobe of
> > your ditribution/kernel .
> > 
> > 
> > Best regards
> > 
> > Rémi
> > 
> > 
> > 
> >>  Le 21 septembre 2013 à 19:43, "Admin@tydaikho.com" <minhhoang1004@yahoo.com> a écrit :
> >>  
> >>  
> >>  Hi Remi!
> >>  I got my card but i have not finish to install driver. I follow your patch on linuxtv.org but i am not successful. it makes some mistake: "malform" and "hunk" errors.
> >>  =======================
> >>  root@ty-debian:/usr/local/src/linuxtv# patch -p1 < ./cx23885.patch
> >>  can't find file to patch at input line 3
> >>  Perhaps you used the wrong -p or --strip option?
> >>  The text leading up to this was:
> >>  --------------------------
> >>  |--- drivers/media/pci/cx23885/cx23885.h   2013-03-25 05:45:50.000000000 +0100
> >>  |+++ drivers/media/pci/cx23885/cx23885.h      2013-08-21 13:55:20.010625134 +0200
> >>  --------------------------
> >>  File to patch: ./drivers/media/pci/cx23885/cx23885.h                                  
> >>  patching file ./drivers/media/pci/cx23885/cx23885.h
> >>  patch: **** malformed patch at line 4:  #define CX23885_BOARD_PROF_8000                37
> >>  ==========================
> >>  root@ty-debian:/usr/local/src/linuxtv# patch -p1 < ./cx23885-video.patch
> >>  can't find file to patch at input line 4
> >>  Perhaps you used the wrong -p or --strip option?
> >>  The text leading up to this was:
> >>  --------------------------
> >>  |--- drivers/media/pci/cx23885/cx23885-video.c     2013-08-02 05:45:59.000000000 +0200
> >>  |+++ drivers/media/pci/cx23885/cx23885-video.c        2013-08-21 13:55:20.017625046
> >>  |+0200
> >>  --------------------------
> >>  File to patch: ./drivers/media/pci/cx23885/cx23885-video.c
> >>  patching file ./drivers/media/pci/cx23885/cx23885-video.c
> >>  Hunk #1 FAILED at 511.
> >>  Hunk #2 FAILED at 1888.
> >>  2 out of 2 hunks FAILED -- saving rejects to file ./drivers/media/pci/cx23885/cx23885-video.c.rej
> >>  ============================
> >>  root@ty-debian:/usr/local/src/linuxtv# patch -p1 < ./cx23885-cards.patch
> >>  can't find file to patch at input line 4
> >>  Perhaps you used the wrong -p or --strip option?
> >>  The text leading up to this was:
> >>  --------------------------
> >>  |--- drivers/media/pci/cx23885/cx23885-cards.c     2012-12-28 00:04:05.000000000 +0100
> >>  |+++ drivers/media/pci/cx23885/cx23885-cards.c        2013-08-21 14:15:54.173195979
> >>  |+0200
> >>  --------------------------
> >>  File to patch: ./drivers/media/pci/cx23885/cx23885-cards.c
> >>  patching file ./drivers/media/pci/cx23885/cx23885-cards.c
> >>  Hunk #1 FAILED at 604.
> >>  Hunk #2 FAILED at 841.
> >>  Hunk #3 FAILED at 1069.
> >>  Hunk #4 FAILED at 1394.
> >>  Hunk #5 FAILED at 1623.
> >>  Hunk #6 FAILED at 1758.
> >>  6 out of 6 hunks FAILED -- saving rejects to file ./drivers/media/pci/cx23885/cx23885-cards.c.rej
> >>  ===============================
> >>  
> >>  If you don't mind, i need your support to get my card works well. Thank you very much!
> >>  
> >>   
> >>  ----------------------------------------------------------
> >>  Yahoo: minhhoang1004 + Google: minhhoang1004 + Skype: minhhoang1004 + MSN: tydaikho
> >>  ----------------------------------------------------------
> >>  
> >>  (http://tydaikho.com)  VS  (http://vnluser.net)
