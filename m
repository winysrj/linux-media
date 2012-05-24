Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60022 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771Ab2EXPwM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 11:52:12 -0400
Message-ID: <4FBE5928.3040407@iki.fi>
Date: Thu, 24 May 2012 18:52:08 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Thomas Mair <thomas.mair86@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL for v3.5-rc1] media updates for v3.5
References: <4FBE5518.5090705@redhat.com>
In-Reply-To: <4FBE5518.5090705@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24.05.2012 18:34, Mauro Carvalho Chehab wrote:
> Hi Linus,
>
> Please pull from:
>    git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
>
> For a series of patches for 3.5, including:
> 	- some V4L2 API updates needed by embedded devices;
> 	- DVB API extensions for ATSC-MH delivery system, used in US for mobile TV;
> 	- new tuners for fc0011/0012/0013 and tua9001;
> 	- a new dvb driver for af9033/9035;
> 	- a new ATSC-MH frontend (lg2160);
> 	- new remote controller keymaps;
> 	- Removal of a few legacy webcam driver that got replaced by gspca on
> 	  several kernel versions ago;
> 	- a new driver for Exynos 4/5 webcams(s5pp fimc-lite);
> 	- a new webcam sensor driver (smiapp);
> 	- a new video input driver for embedded (sta2x1xx);
> 	- several improvements, fixes, cleanups, etc inside the drivers.

Mauro,
Are you planning to PULL-request another set for the Kernel 3.5?

I wonder if it is possible to get in Thomas Mair Realtek RTL2832 DVB-T 
demod driver which adds support for few RTL2832U based designs.

http://patchwork.linuxtv.org/patch/11319/
http://patchwork.linuxtv.org/patch/11320/
http://patchwork.linuxtv.org/patch/11321/
http://patchwork.linuxtv.org/patch/11322/
http://patchwork.linuxtv.org/patch/11323/

regards
Antti
-- 
http://palosaari.fi/
