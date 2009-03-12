Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48046 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbZCLNUU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 09:20:20 -0400
Date: Thu, 12 Mar 2009 10:20:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	"Sri Deevi via Mercurial" <srinivasa.deevi@conexant.com>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] Add cx231xx USB driver
Message-ID: <20090312102011.2f5672e1@pedra.chehab.org>
In-Reply-To: <60934.62.70.2.252.1236856462.squirrel@webmail.xs4all.nl>
References: <60934.62.70.2.252.1236856462.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Thu, 12 Mar 2009 12:14:22 +0100 (CET)
"Hans Verkuil" <hverkuil@xs4all.nl> wrote:

> Mauro, you did not answer the question why this driver was just merged
> without going through a public review? If I'd seen it beforehand I'd have
> worked together with Sri to get it fixed first. I don't expect him to know
> about this, but I didn't even get a chance to discuss it and help with it.
> Everyone else has to go through the normal review channels, but apparently
> this was just fast-tracked and merged. That's not the way to do it.

It were added one week ago on a temporary public tree, at linuxtv.

> Please back out this driver, put it in a separate tree and let me 1)
> review this driver first, and 2) help Sri implementing the
> v4l2_device/v4l2_subdev stuff.

It is better to review it at the tree. I won't merge it upstream until the
remaining bugs would be fixed. Until then, it will wait on my staging -git tree
(the pending tree).

> > First of all, except for ivtv drivers, the first conversion to the new
> > model
> > occurred just few weeks ago. The new model will bring some gains, but this
> > shouldn't stop the merge of the drivers whose development started before
> > we
> > port the drivers used as example by the developer.
> >
> > This is a new model, and we should give people some time to adapt to it.
> > This
> > is the way we worked in the past and it is the way we should keep working.
> 
> It's not a new model.

It is. The first changeset were committed on Nov, 30, and the last internal API
changes, according with the docs, happened on Feb, 14. So, if we don't touch on
it, the first stable version of the framework will be available upstream on
2.6.30. 

If we keep it stable during 2.6.30, convert the drivers merged on 2.6.30 to the
new framework, and mark the legacy approach as a feature to be removed on a
patch applied at 2.6.30, then we can remove the previous support for 2.6.31.

$ hg log linux/Documentation/video4linux/v4l2-framework.txt 

changeset:   10648:e471b963bef6
parent:      10640:4f6c3f9efa58
parent:      10647:63256532f5a7
user:        Mauro Carvalho Chehab <mchehab@redhat.com>
date:        Tue Feb 17 23:44:45 2009 -0300
summary:     merge: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb

changeset:   10644:44b5df81ab02
user:        Hans Verkuil <hverkuil@xs4all.nl>
date:        Sat Feb 14 16:00:53 2009 +0100
summary:     v4l2-subdev: rename dev field to v4l2_dev

changeset:   10643:9eb2f6220a18
user:        Hans Verkuil <hverkuil@xs4all.nl>
date:        Sat Feb 14 15:54:23 2009 +0100
summary:     v4l2-device: allow a NULL parent device when registering.

changeset:   10573:b73e7bdad8c4
user:        Mauro Carvalho Chehab <mchehab@redhat.com>
date:        Mon Feb 16 15:54:29 2009 -0300
summary:     v4l2-framework.txt: Whitespace clenups

changeset:   10571:12a10f808bfd
user:        Mauro Carvalho Chehab <mchehab@redhat.com>
date:        Sat Feb 14 08:51:28 2009 -0200
summary:     v4l2-framework.txt: Fixes the videobuf init functions

changeset:   10570:6f4cff0e7f16
user:        Mauro Carvalho Chehab <mchehab@redhat.com>
date:        Sat Feb 14 08:29:07 2009 -0200
summary:     v4l2-framework: documments videobuf usage on drivers

changeset:   10489:c84416787a43
user:        Mauro Carvalho Chehab <mchehab@redhat.com>
date:        Sat Feb 07 11:07:04 2009 +0100
summary:     doc: use consistent naming conventions for vdev and v4l2_dev.

changeset:   10252:09cabe4f0c63
user:        Hans Verkuil <hverkuil@xs4all.nl>
date:        Thu Jan 15 10:09:05 2009 +0100
summary:     v4l2 doc: explain why v4l2_device_unregister_subdev() has to be called.

changeset:   10141:4cc8ed11e2e0
user:        Hans Verkuil <hverkuil@xs4all.nl>
date:        Tue Dec 30 11:14:19 2008 +0100
summary:     v4l2: debugging API changed to match against driver name instead of ID.

changeset:   10136:ffe112f306a3
user:        Hans Verkuil <hverkuil@xs4all.nl>
date:        Tue Dec 23 17:42:25 2008 +0100
summary:     v4l2 doc: update v4l2-framework.txt

changeset:   10134:a11cf6774c04
user:        Hans Verkuil <hverkuil@xs4all.nl>
date:        Tue Dec 23 16:17:23 2008 +0100
summary:     v4l2 doc: set v4l2_dev instead of parent.

changeset:   10133:f03ab4ab3f87
user:        Hans Verkuil <hverkuil@xs4all.nl>
date:        Mon Dec 22 13:13:11 2008 +0100
summary:     v4l2-framework: use correct comment style.

changeset:   9943:2e680d8a3b2f
user:        Hans Verkuil <hverkuil@xs4all.nl>
date:        Fri Dec 19 14:20:22 2008 +0100
summary:     v4l2: document video_device.

changeset:   9820:5611723c9512
parent:      9767:7100e78482d7
user:        Hans Verkuil <hverkuil@xs4all.nl>
date:        Sun Nov 30 01:36:58 2008 +0100
summary:     v4l2: add v4l2_device and v4l2_subdev structs to the v4l2 framework.

> The I2C core changes went in in 2.6.22.

I'm not referring to i2c core changes, but to v4l2 dev/subdev stuff.

> And please note that the use of the old API isn't the only question I
> have, there are more oddities with the i2c handling that I'd like to have
> more information about. Writing i2c registers directly from the adapter
> driver doesn't look good to me at first sight.

Yes, I'm aware of the I2C GPIO and similar stuff. This is one of the reasons
why this shouldn't be merged upstream yet.

> > The second point is that there's nothing at
> > Documentation/feature-removal-schedule.txt informing that those stuff is
> > deprecated.
> 
> Yes it is, see this from the 2.6.29 kernel:
> 
> What:   i2c_attach_client(), i2c_detach_client(), i2c_driver->detach_client()
> When:   2.6.29 (ideally) or 2.6.30 (more likely)
> Why:    Deprecated by the new (standard) device driver binding model. Use
>         i2c_driver->probe() and ->remove() instead.
> Who:    Jean Delvare <khali@linux-fr.org>

I'm not referring to the i2c changes, but to the v4l2 framework ones.

Anyway, checkpatch should be generating warning about this, at least on my
environment. In this case, no warnings are generated.

Hmm... there's no "check" field on its entry. 

Jean should have added a line like:
Check: i2c_attach_client i2c_detach_client i2c_driver->detach_client

to let checkpatch.pl to do his job.

> > Since his driver seems to be based on em28xx, he had no sample on how to
> > convert it to
> > v4l2_device/v4l2_subdev/new_i2c model.
> 
> Again, if I'd known about it I'd be happy to help with it. Why didn't you
> put me in contact with him? You know I'm spending a lot of time on this.

Why don't you do it, instead of complaining? It is not upstream, and I won't
move it upstream yet, as I said before.

Btw, there's another driver that will likely be sent to me on the next few days.
I'm not sure if it is using the new model or not. I haven't seen the code yet,
so I'm not sure what functions it is being used. I suspect that it is still
using the old model, since its development started before months ago, before
the v4l2 dev/subdev conversion of the drivers.

> > After committing Devin's Austek patches (also seemed to be based on
> > em28xx), it will
> > probably be easier for Uri to convert his driver to the new approach.
> 
> That depends. As I said, there are other i2c issues that need to be
> clarified, but I *never* got the chance to ask him since you just merged
> this driver without the customary public review.

You have the chance right now. 

That's why we have the staging v4l/dvb -hg tree: to give everybody a view of
what's is planned. Also, a public announcement is done automatically by hg
mailbomb scripts, that sends all committed patches to the patch announcement ML.

Cheers,
Mauro
