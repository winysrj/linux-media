Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45306 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbaKPKUc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Nov 2014 05:20:32 -0500
Date: Sun, 16 Nov 2014 08:20:23 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Pavel Machek <pavel@ucw.cz>,
	Konrad Zapalowicz <bergo.torino@gmail.com>,
	Christian Resell <christian.resell@gmail.com>,
	devel@driverdev.osuosl.org, askb23@gmail.com,
	linux-kernel@vger.kernel.org, yongjun_wei@trendmicro.com.cn,
	hans.verkuil@cisco.com, pali.rohar@gmail.com,
	fengguang.wu@intel.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: media: bcm2048: fix coding style error
Message-ID: <20141116082023.73460409@recife.lan>
In-Reply-To: <20141115212503.GA21773@kroah.com>
References: <20141115194337.GF15904@Kosekroken.jensen.com>
	<20141115201218.GC8088@t400>
	<20141115205934.GB21240@amd>
	<20141115212503.GA21773@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Nov 2014 13:25:03 -0800
Greg KH <gregkh@linuxfoundation.org> escreveu:

> On Sat, Nov 15, 2014 at 09:59:34PM +0100, Pavel Machek wrote:
> > On Sat 2014-11-15 21:12:18, Konrad Zapalowicz wrote:
> > > On 11/15, Christian Resell wrote:
> > > > Simple style fix (checkpatch.pl: "space prohibited before that ','").
> > > > For the eudyptula challenge (http://eudyptula-challenge.org/).
> > > 
> > > Nice, however we do not need the information about the 'eudyptula
> > > challenge' in the commit message.
> > > 
> > > If you want to include extra information please do it after the '---'
> > > line (just below the signed-off). You will find more details in the
> > > SubmittingPatches (chapter 15) of the kernel documentation.
> > 
> > Greg is staging tree maintainer... And if single extra space is all
> > you can fix in the driver, perhaps it is not worth the patch?
> 
> I am not the maintainer of drivers/staging/media/ please look at
> MAINTAINERS before you make statements like that.
> 
> And yes, one space fixes is just fine, that's why the code is in
> staging.

Yes, space fixes is OK for staging.

I'll apply this patch, removing the line that comments about the challenge,
as we don't need to keep this information forever at the Kernel history.

Regards,
Mauro
