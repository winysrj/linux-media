Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3980 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2GSUmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 16:42:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [PATCH 10/10] staging: solo6x10: Avoid extern declaration by reworking module parameter
Date: Thu, 19 Jul 2012 22:41:54 +0200
Cc: Ismael Luceno <ismael.luceno@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com> <201207192148.33665.hverkuil@xs4all.nl> <CALF0-+V2ZvZOsCj_hZuD=wwVL1D7p0smHki4x=YyghiM5Rvdqw@mail.gmail.com>
In-Reply-To: <CALF0-+V2ZvZOsCj_hZuD=wwVL1D7p0smHki4x=YyghiM5Rvdqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207192241.54408.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu July 19 2012 21:55:20 Ezequiel Garcia wrote:
> On Thu, Jul 19, 2012 at 4:48 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Thu July 19 2012 20:41:11 Ismael Luceno wrote:
> >> On Thu, 19 Jul 2012 10:25:09 -0300
> >> Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> >> > On Wed, Jul 18, 2012 at 7:26 PM, Ismael Luceno
> >> > <ismael.luceno@gmail.com> wrote:
> >> > > On Thu, Jun 21, 2012 at 4:52 PM, Ezequiel Garcia
> >> > > <elezegarcia@gmail.com> wrote:
> >> > >> This patch moves video_nr module parameter to core.c
> >> > >> and then passes that parameter as an argument to functions
> >> > >> that need it.
> >> > >> This way we avoid the extern declaration and parameter
> >> > >> dependencies are better exposed.
> >> > > <...>
> >> > >
> >> > > NACK.
> >> > >
> >> > > The changes to video_nr are supposed to be preserved.
> >> >
> >> > Mmm, I'm sorry but I don't see any functionality change in this patch,
> >> > just a cleanup.
> >> >
> >> > What do you mean by "changes to video_nr are supposed to be
> >> > preserved"?
> >>
> >> It is modified by solo_enc_alloc, which is called multiple times by
> >> solo_enc_v4l2_init.
> >
> > You don't need to modify it at all. video_register_device() will start
> > looking for a free video node number starting at video_nr and counting
> > upwards, so increasing video_nr has no purpose. Leaving it out will give
> > you exactly the same result.
> >
> 
> Yes, but perhaps the module author wanted to force a device
> /dev/videoX *start* number,
> as it's documented in the parameter usage string:
> 
>   MODULE_PARM_DESC(video_nr, "videoX start number, -1 is autodetect (default)");
> 
> Now, I don't now why would one want to do that or if it makes sense at all.
> In any case, it seems it's the intended behavior.
> 

But doing video_nr++ is pointless and will not have an effect.

Example: if video_nr is specified as 2, then video_register_device() will attempt
to make a /dev/video2 node, if that's already in use, then it will try /dev/video3,
etc.

So doing video_nr++ after a video_register_device() will not change the outcome
for the next video_register_device() that is called, and has the somewhat odd
side-effect of changing the video_nr module parameter from what the user passed in.
So cat /sys/module/vivi/parameters/video_nr returns 3 instead of 2.

Just don't change it and let video_register_device() do its magic.

Regards,

	Hans
