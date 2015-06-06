Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50953 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbbFFNKX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2015 09:10:23 -0400
Date: Sat, 6 Jun 2015 15:10:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pali Roh?r <pali.rohar@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	maxx <maxx@spaceboyz.net>
Subject: Re: [PATCH] radio-bcm2048: Enable access to automute and ctrl
 registers
Message-ID: <20150606131018.GE1329@xo-6d-61-c0.localdomain>
References: <1431725511-7379-1-git-send-email-pali.rohar@gmail.com>
 <55718929.6080004@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <55718929.6080004@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 2015-06-05 13:34:01, Hans Verkuil wrote:
> On 05/15/2015 11:31 PM, Pali Rohár wrote:
> > From: maxx <maxx@spaceboyz.net>
> > 
> > This enables access to automute function of the chip via sysfs and
> > gives direct access to FM_AUDIO_CTRL0/1 registers, also via sysfs. I
> > don't think this is so important but helps in developing radio scanner
> > apps.
> > 
> > Patch writen by maxx@spaceboyz.net
> > 
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > Cc: maxx@spaceboyz.net
> 
> As Pavel mentioned, these patches need to be resend with correct Signed-off-by
> lines.
> 
> Regarding this patch: I don't want to apply this since this really should be a
> control. Or just enable it always. If someone wants to make this a control, then
> let me know: there are two other drivers with an AUTOMUTE control: bttv and saa7134.
> 
> In both cases it is implemented as a private control, but it makes sense to
> promote this to a standard user control. I can make a patch for that.
> 
> And for CTRL0/1: if you want direct register access, then implement
> VIDIOC_DBG_G/S_REGISTER. This makes sure you have the right permissions etc.
> 
> More importantly: is anyone working on getting this driver out of staging? It's
> been here for about a year and a half and I haven't seen any efforts to clean it up.

Yes, there are. Unfortunately, this one depends on bluetooth driver, and we have some
fun with that one. So please be patient...

										Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
