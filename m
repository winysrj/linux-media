Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49739 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554AbaGWIVW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 04:21:22 -0400
Date: Wed, 23 Jul 2014 16:21:19 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: Re: [linuxtv-media:master 378/499] ERROR: "__udivdi3"
 [drivers/media/dvb-frontends/rtl2832_sdr.ko] undefined!
Message-ID: <20140723082119.GB315@localhost>
References: <53cf9a8e.E95mSmw/U7btaj7k%fengguang.wu@intel.com>
 <53CF597C.6050708@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CF597C.6050708@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

This is just a notification. It's up to human to decide the impact and
whether or not to do the rebase (which very much depends on the
publicness of the tree and git committer's work style).

Thanks,
Fengguang

On Wed, Jul 23, 2014 at 09:43:08AM +0300, Antti Palosaari wrote:
> Moikka!
> 
> 
> On 07/23/2014 02:20 PM, kbuild test robot wrote:
> >tree:   git://linuxtv.org/media_tree.git master
> >head:   eb9da073bd002f2968c84129a5c49625911a3199
> >commit: 77bbb2b049c1c3e935f5bec510bec337d94ae8f8 [378/499] rtl2832_sdr: move from staging to media
> >config: i386-randconfig-ha2-0723 (attached as .config)
> >
> >Note: the linuxtv-media/master HEAD eb9da073bd002f2968c84129a5c49625911a3199 builds fine.
> >       It only hurts bisectibility.
> >
> >All error/warnings:
> >
> >>>ERROR: "__udivdi3" [drivers/media/dvb-frontends/rtl2832_sdr.ko] undefined!
> 
> 
> Could you say what I should do for that? Bug is fixed and solution is merged
> as that patch:
> 
> commit a98ccfcf4804beb2651b9f44a4bc5cbb387019ec
> Author: Antti Palosaari <crope@iki.fi>
> Date:   Tue Jul 22 00:18:19 2014 -0300
> 
>     [media] rtl2832_sdr: remove plain 64-bit divisions
> 
> Do you want Mauro to rebase whole media/master in order to make
> bisectibility possible in any case?
> 
> regards
> Antti
> 
> -- 
> http://palosaari.fi/
