Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57663 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752254AbZFZPFH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 11:05:07 -0400
Date: Fri, 26 Jun 2009 17:05:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH] mt9t031 - migration to sub device frame work
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40139F9E0D9@dlee06.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0906261657170.4449@axis700.grange>
References: <1245874609-15246-1-git-send-email-m-karicheri2@ti.com>
 <Pine.LNX.4.64.0906251944420.4663@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40139F9DEC4@dlee06.ent.ti.com>
 <200906260847.19818.hverkuil@xs4all.nl> <Pine.LNX.4.64.0906260852290.4449@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40139F9E0D9@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 26 Jun 2009, Karicheri, Muralidharan wrote:

> >
> >). I started by converting mx3-camera and mt9t031, and I shall upload an
> >incomplete patch, converting only these drivers to my "testing" area,
> >while I shall start converting the rest of the drivers... So, it is
> >advisable to wait for that patch to appear and base any future (including
> >this one) work on it, because it is a pretty big change and merging would
> >be non-trivial.
> >
> I thought you wanted to offload some of the migration work and I had 
> volunteered to do this since it is of interest to vpfe-capture.

Yes, but these are two unrelated (at least in theory) changes: fixing 
cropping / scaling behaviour of _all_ aoc-camera drivers and the 
soc-camera framework core, and removing the remaining bonds between 
subdevice drivers and the soc-camera framework and replacing it properly 
with v4l2-subdev API.

I thought you would be doing the latter part - v4l2-subdev conversion. 
Which is good. But, you wrote:

> This patch migrates mt9t031 driver from SOC Camera interface to
> sub device interface. This is sent to get a feedback about the
> changes done since I am not sure if some of the functionality
> that is removed works okay with SOC Camera bridge driver or
> not. Following functions are to be discussed and added as needed:-

which I understand like you probably have broken soc-camera functionality 
of this driver, which I cannot accept. Yes, I want to move forward to 
v4l2-subdev, but - we cannot introduce regressions!

> I don't see a point in duplicating the work already done by me.

I don't like duplicating work either, and I don't think we're doing that. 
As I said, what I am doing at the moment is fixing all soc-camera drivers 
for proper cropping / scaling. In principle I welcome your help with the 
v4l2-subdev migration, but currently it conflicts with my above work, and 
it introduces a regression.

> So could you 
> please work with me by reviewing this patch and then use this for your 
> work? I will take care of merging any updates to this based on your 
> patches (like the crop one)

Unfortunately, I do not think I'll be able to review your patch today, 
will have to wait until the next week, sorry.

> >> > >>  {
> >> > >> -    s32 data = i2c_smbus_read_word_data(client, reg);
> >> > >> +    s32 data;
> >> > >> +
> >> > >> +    data = i2c_smbus_read_word_data(client, reg);
> >> > >>      return data < 0 ? data : swab16(data);
> >
> >Looks like it will take me considerable time to review the patch and NAK
> >all changes like this one...
> >
> I didn't get it. Are you referring to the 3 lines of code above? For 
> this patch this code change is unnecessary, but I have to do this if sd 
> is used as argument to this function as suggested by Hans.

Exactly. It is _not_ needed for this patch. Only if we _do_ accept Hans' 
suggestion to use the subdev pointer all the way down to register-access 
functions, _then_ you might need to modify this code.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
