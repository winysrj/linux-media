Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:63311 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaGWMVY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 08:21:24 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9500GEVZNM3350@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Jul 2014 08:21:22 -0400 (EDT)
Date: Wed, 23 Jul 2014 09:21:17 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-media@vger.kernel.org,
	kbuild-all@01.org
Subject: Re: [linuxtv-media:master 378/499] ERROR: "__udivdi3"
 [drivers/media/dvb-frontends/rtl2832_sdr.ko] undefined!
Message-id: <20140723092117.570cfb38.m.chehab@samsung.com>
In-reply-to: <53CF7BF4.6060205@iki.fi>
References: <53cf9a8e.E95mSmw/U7btaj7k%fengguang.wu@intel.com>
 <53CF597C.6050708@iki.fi> <20140723082119.GB315@localhost>
 <53CF7BF4.6060205@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 23 Jul 2014 12:10:12 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Moikka Fengguang
> OK, lets Mauro decide how to handle that 32-bit(?) build error.

Once the patch is merged, I don't care anymore about avoiding bisect,
especially on 32 bits kernels. The harm of rebasing my tree is worse
than breaking bisectability, specially on 32 bits, as almost all
developers do git bisect on x86_64 nowadays.

> 
> Could you change kbuild test robot clock to current time. It seems to 
> live still in future :)
> 
> regards
> Antti
> 
> 
> On 07/23/2014 11:21 AM, Fengguang Wu wrote:
> > Hi Antti,
> >
> > This is just a notification. It's up to human to decide the impact and
> > whether or not to do the rebase (which very much depends on the
> > publicness of the tree and git committer's work style).
> >
> > Thanks,
> > Fengguang
> >
> > On Wed, Jul 23, 2014 at 09:43:08AM +0300, Antti Palosaari wrote:
> >> Moikka!
> >>
> >>
> >> On 07/23/2014 02:20 PM, kbuild test robot wrote:
> >>> tree:   git://linuxtv.org/media_tree.git master
> >>> head:   eb9da073bd002f2968c84129a5c49625911a3199
> >>> commit: 77bbb2b049c1c3e935f5bec510bec337d94ae8f8 [378/499] rtl2832_sdr: move from staging to media
> >>> config: i386-randconfig-ha2-0723 (attached as .config)
> >>>
> >>> Note: the linuxtv-media/master HEAD eb9da073bd002f2968c84129a5c49625911a3199 builds fine.
> >>>        It only hurts bisectibility.
> >>>
> >>> All error/warnings:
> >>>
> >>>>> ERROR: "__udivdi3" [drivers/media/dvb-frontends/rtl2832_sdr.ko] undefined!
> >>
> >>
> >> Could you say what I should do for that? Bug is fixed and solution is merged
> >> as that patch:
> >>
> >> commit a98ccfcf4804beb2651b9f44a4bc5cbb387019ec
> >> Author: Antti Palosaari <crope@iki.fi>
> >> Date:   Tue Jul 22 00:18:19 2014 -0300
> >>
> >>      [media] rtl2832_sdr: remove plain 64-bit divisions
> >>
> >> Do you want Mauro to rebase whole media/master in order to make
> >> bisectibility possible in any case?
> >>
> >> regards
> >> Antti
> >>
> >> --
> >> http://palosaari.fi/
> 
