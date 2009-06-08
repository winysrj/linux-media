Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2416 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbZFHGir (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 02:38:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: eduardo.valentin@nokia.com
Subject: Re: [PATCHv5 1 of 8] v4l2_subdev i2c: Add v4l2_i2c_new_subdev_board i2c helper function
Date: Mon, 8 Jun 2009 08:38:32 +0200
Cc: ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Eduardo Valentin <edubezval@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1243582408-13084-1-git-send-email-eduardo.valentin@nokia.com> <20090608001922.6adcfcaa@gmail.com> <20090608061132.GA20224@esdhcp037198.research.nokia.com>
In-Reply-To: <20090608061132.GA20224@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906080838.32517.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 08 June 2009 08:11:32 Eduardo Valentin wrote:
> Hi guys,
>
> On Mon, Jun 08, 2009 at 05:19:22AM +0200, ext Douglas Schilling Landgraf 
wrote:
> > Hi,
> >
> > On Sun, 7 Jun 2009 22:29:14 -0300
> >
> > Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > > Em Sun, 7 Jun 2009 08:40:08 +0200
> > >
> > > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > > > On Saturday 06 June 2009 22:40:21 Eduardo Valentin wrote:
> > > > > Hi Hans,
> > > > >
> > > > > On Sat, Jun 6, 2009 at 8:09 PM, Hans Verkuil <hverkuil@xs4all.nl>
> > > > >
> > > > > wrote:
> > > > > > On Saturday 06 June 2009 14:49:46 Hans Verkuil wrote:
> > > > > > > On Saturday 06 June 2009 13:59:19 Hans Verkuil wrote:
>
> <snip>
>
> > > No please. We did already lots of change due to the i2c changes, and
> > > there are still some occasional complaints at ML about regressions
> > > that might be due to i2c changes.
> > >
> > > Let's keep 2.6.31 clean, as previously agreed, without new KABI
> > > changes. We should focus 2.6.31 on fixing any core issues that may
> > > still have. Only with 2.6.30 we'll start to have feedbacks from
> > > normal users.
>
> <snip>
>
> > > > > I've cloned your tree and took a look at your code. Well, looks
> > > > > like the proper way to do this change.
> > > > > I didn't take this approach because it touchs other drivers.
> > > > > However, concentrating the code  in only one
> > > > > function is better. I also saw that you have fixed the kernel
> > > > > version check in the v4l2_device_unregister
> > > > > function. Great!
> > > > >
> > > > > I will resend my series without this patch. I will rebase it on
> > > > > top of your subdev tree so the new api
> > > > > can be used straight. Is that ok?
> > > >
> > > > Yes, sure. Just be aware that there may be some small changes to my
> > > > patch based on feedback I get. But it is a good test anyway of this
> > > > API to see if it works well for you.
> > >
> > > Eduardo,
> > >
> > > Let's analyze and merge your changes using the current development
> > > tree. If you think that Hans approach is better (I haven't analyzed
> > > it yet), then it can later be converted to the new approach
> >
> > I have talked with Eduardo during last week and if there is no
> > objections, I am ready to request a pull from the current/last
> > patches series.
>
> Yes, my series is already in one of Douglas' trees and we have tested it.
> However, in that series there is one patch which does partially what Hans
> is proposing. Which is: add a way to pass platform info to i2c drivers,
> using v4l2 i2c helper functions. They way it is done in this patch it
> does not affect any other driver. Hans did also some re-factoring in
> existing i2c helper function, besides adding new way to pass platform
> data.

No, I don't agree with that. Your patch has some issues: no cleanup after 
s_config returns an error, and if we introduce s_config then it should be 
called by *all* v4l2_new_subdev* functions. That way i2c drivers that 
implement this can use it reliably for their initialization.

I see no point in doing the same work twice. We have one clean solution into 
which I put quite a bit of time, and one that hacks new functionality into 
an already flawed API.

This was also the reason why I didn't just sign off on Eduardo's patch. I 
strongly suspected I needed to do some proper refactoring first and when I 
finally had the time to look into this last Saturday I discovered it did 
indeed needed refactoring.

>
> If you agree we can use it for now and in next window we
> change things to have them using the way Hans did (which is more
> complete).

Going with a suboptimal solution when a proper clean one is available is a 
really bad idea IMHO.

Regards,

	Hans

>
> What do you think?
>
> > Cheers,
> > Douglas
>
> Cheers,



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
