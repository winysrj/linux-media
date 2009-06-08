Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:35882 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbZFHGPu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 02:15:50 -0400
Date: Mon, 8 Jun 2009 09:11:32 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Eduardo Valentin <edubezval@gmail.com>,
	"Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCHv5 1 of 8] v4l2_subdev i2c: Add
	v4l2_i2c_new_subdev_board i2c helper function
Message-ID: <20090608061132.GA20224@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1243582408-13084-1-git-send-email-eduardo.valentin@nokia.com> <200906061909.28157.hverkuil@xs4all.nl> <a0580c510906061340j6c1ee990xdf581ccaaad8fe0e@mail.gmail.com> <200906070840.09166.hverkuil@xs4all.nl> <20090607222914.314c3fc7@pedra.chehab.org> <20090608001922.6adcfcaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608001922.6adcfcaa@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

On Mon, Jun 08, 2009 at 05:19:22AM +0200, ext Douglas Schilling Landgraf wrote:
> Hi,
> 
> On Sun, 7 Jun 2009 22:29:14 -0300
> Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> 
> > Em Sun, 7 Jun 2009 08:40:08 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> > > On Saturday 06 June 2009 22:40:21 Eduardo Valentin wrote:
> > > > Hi Hans,
> > > >
> > > > On Sat, Jun 6, 2009 at 8:09 PM, Hans Verkuil <hverkuil@xs4all.nl>
> > > > wrote:
> > > > > On Saturday 06 June 2009 14:49:46 Hans Verkuil wrote:
> > > > > > On Saturday 06 June 2009 13:59:19 Hans Verkuil wrote:

<snip>

> > 
> > No please. We did already lots of change due to the i2c changes, and
> > there are still some occasional complaints at ML about regressions
> > that might be due to i2c changes.
> > 
> > Let's keep 2.6.31 clean, as previously agreed, without new KABI
> > changes. We should focus 2.6.31 on fixing any core issues that may
> > still have. Only with 2.6.30 we'll start to have feedbacks from
> > normal users.

<snip>

> > > >
> > > > I've cloned your tree and took a look at your code. Well, looks
> > > > like the proper way to do this change.
> > > > I didn't take this approach because it touchs other drivers.
> > > > However, concentrating the code  in only one
> > > > function is better. I also saw that you have fixed the kernel
> > > > version check in the v4l2_device_unregister
> > > > function. Great!
> > > >
> > > > I will resend my series without this patch. I will rebase it on
> > > > top of your subdev tree so the new api
> > > > can be used straight. Is that ok?
> > > 
> > > Yes, sure. Just be aware that there may be some small changes to my
> > > patch based on feedback I get. But it is a good test anyway of this
> > > API to see if it works well for you.
> > 
> > Eduardo,
> > 
> > Let's analyze and merge your changes using the current development
> > tree. If you think that Hans approach is better (I haven't analyzed
> > it yet), then it can later be converted to the new approach
> > 
> 
> I have talked with Eduardo during last week and if there is no
> objections, I am ready to request a pull from the current/last
> patches series.

Yes, my series is already in one of Douglas' trees and we have tested it.
However, in that series there is one patch which does partially what Hans is
proposing. Which is: add a way to pass platform info to i2c drivers, using
v4l2 i2c helper functions. They way it is done in this patch it does not affect
any other driver. Hans did also some re-factoring in existing i2c helper function,
besides adding new way to pass platform data.

If you agree we can use it for now and in next window we
change things to have them using the way Hans did (which is more complete).

What do you think?

> 
> Cheers,
> Douglas


Cheers,

-- 
Eduardo Valentin
