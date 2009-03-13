Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1977 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbZCMAxt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 20:53:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] Add cx231xx USB driver
Date: Fri, 13 Mar 2009 01:53:42 +0100
Cc: linux-media@vger.kernel.org,
	"Sri Deevi via Mercurial" <srinivasa.deevi@conexant.com>
References: <60934.62.70.2.252.1236856462.squirrel@webmail.xs4all.nl> <20090312102011.2f5672e1@pedra.chehab.org>
In-Reply-To: <20090312102011.2f5672e1@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903130153.42738.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just one last reply, and than we can close this discussion. Luckily the 
conversion of this driver to v4l2_device/subdev is a lot simpler than I 
feared initially. So no harm done in that respect.

On Thursday 12 March 2009 14:20:11 Mauro Carvalho Chehab wrote:
> On Thu, 12 Mar 2009 12:14:22 +0100 (CET)
>
> "Hans Verkuil" <hverkuil@xs4all.nl> wrote:
> > Mauro, you did not answer the question why this driver was just merged
> > without going through a public review? If I'd seen it beforehand I'd
> > have worked together with Sri to get it fixed first. I don't expect him
> > to know about this, but I didn't even get a chance to discuss it and
> > help with it. Everyone else has to go through the normal review
> > channels, but apparently this was just fast-tracked and merged. That's
> > not the way to do it.
>
> It were added one week ago on a temporary public tree, at linuxtv.

Please announce this in the future. I checked the linux-media list and there 
is no mention of this whatsoever. Just putting it up in a tree is not 
sufficient, you have to tell people about it as well.

> > Please back out this driver, put it in a separate tree and let me 1)
> > review this driver first, and 2) help Sri implementing the
> > v4l2_device/v4l2_subdev stuff.
>
> It is better to review it at the tree. I won't merge it upstream until
> the remaining bugs would be fixed. Until then, it will wait on my staging
> -git tree (the pending tree).
>
> > > First of all, except for ivtv drivers, the first conversion to the
> > > new model
> > > occurred just few weeks ago. The new model will bring some gains, but
> > > this shouldn't stop the merge of the drivers whose development
> > > started before we
> > > port the drivers used as example by the developer.
> > >
> > > This is a new model, and we should give people some time to adapt to
> > > it. This
> > > is the way we worked in the past and it is the way we should keep
> > > working.
> >
> > It's not a new model.
>
> It is. The first changeset were committed on Nov, 30, and the last
> internal API changes, according with the docs, happened on Feb, 14. So,
> if we don't touch on it, the first stable version of the framework will
> be available upstream on 2.6.30.
>
> If we keep it stable during 2.6.30, convert the drivers merged on 2.6.30
> to the new framework, and mark the legacy approach as a feature to be
> removed on a patch applied at 2.6.30, then we can remove the previous
> support for 2.6.31.

It's not v4l2_device/v4l2_subdev that's at stake here. It's the removal of 
the old i2c autoprobing behavior. v4l2_device/v4l2_subdev is just the 
fastest way to do this for v4l drivers. As you can see here:

http://i2c.wiki.kernel.org/index.php/Legacy_drivers_to_be_converted

the conversion is almost done. This weekend I hope to finish cx88, cx23885 
and bttv. Hopefully Douglas Landgraf can convert em28xx and I know Mike 
Isely only needs to do some final tweaks for pvrusb2.

I do not expect newly submitted drivers to use v4l2_device/subdev. I know it 
is a very recent development. But it is very easy to implement and all I 
need is a chance to review and help them with that to ensure that dropping 
the old i2c API isn't blocked by a new driver. Not in the least because it 
is likely that the i2c core maintainer will block such a new driver if it 
is the only driver preventing the removal of the old i2c API.

In addition, once a driver is in the v4l-dvb tree I cannot just drop the old 
i2c API support in v4l-dvb since that will just break any driver that uses 
it. So whether it goes to the git tree or not, that doesn't matter for me.

> $ hg log linux/Documentation/video4linux/v4l2-framework.txt
>
> changeset:   10648:e471b963bef6
> parent:      10640:4f6c3f9efa58
> parent:      10647:63256532f5a7
> user:        Mauro Carvalho Chehab <mchehab@redhat.com>
> date:        Tue Feb 17 23:44:45 2009 -0300
> summary:     merge: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb
>
> changeset:   10644:44b5df81ab02
> user:        Hans Verkuil <hverkuil@xs4all.nl>
> date:        Sat Feb 14 16:00:53 2009 +0100
> summary:     v4l2-subdev: rename dev field to v4l2_dev
>
> changeset:   10643:9eb2f6220a18
> user:        Hans Verkuil <hverkuil@xs4all.nl>
> date:        Sat Feb 14 15:54:23 2009 +0100
> summary:     v4l2-device: allow a NULL parent device when registering.
>
> changeset:   10573:b73e7bdad8c4
> user:        Mauro Carvalho Chehab <mchehab@redhat.com>
> date:        Mon Feb 16 15:54:29 2009 -0300
> summary:     v4l2-framework.txt: Whitespace clenups
>
> changeset:   10571:12a10f808bfd
> user:        Mauro Carvalho Chehab <mchehab@redhat.com>
> date:        Sat Feb 14 08:51:28 2009 -0200
> summary:     v4l2-framework.txt: Fixes the videobuf init functions
>
> changeset:   10570:6f4cff0e7f16
> user:        Mauro Carvalho Chehab <mchehab@redhat.com>
> date:        Sat Feb 14 08:29:07 2009 -0200
> summary:     v4l2-framework: documments videobuf usage on drivers
>
> changeset:   10489:c84416787a43
> user:        Mauro Carvalho Chehab <mchehab@redhat.com>
> date:        Sat Feb 07 11:07:04 2009 +0100
> summary:     doc: use consistent naming conventions for vdev and
> v4l2_dev.
>
> changeset:   10252:09cabe4f0c63
> user:        Hans Verkuil <hverkuil@xs4all.nl>
> date:        Thu Jan 15 10:09:05 2009 +0100
> summary:     v4l2 doc: explain why v4l2_device_unregister_subdev() has to
> be called.
>
> changeset:   10141:4cc8ed11e2e0
> user:        Hans Verkuil <hverkuil@xs4all.nl>
> date:        Tue Dec 30 11:14:19 2008 +0100
> summary:     v4l2: debugging API changed to match against driver name
> instead of ID.
>
> changeset:   10136:ffe112f306a3
> user:        Hans Verkuil <hverkuil@xs4all.nl>
> date:        Tue Dec 23 17:42:25 2008 +0100
> summary:     v4l2 doc: update v4l2-framework.txt
>
> changeset:   10134:a11cf6774c04
> user:        Hans Verkuil <hverkuil@xs4all.nl>
> date:        Tue Dec 23 16:17:23 2008 +0100
> summary:     v4l2 doc: set v4l2_dev instead of parent.
>
> changeset:   10133:f03ab4ab3f87
> user:        Hans Verkuil <hverkuil@xs4all.nl>
> date:        Mon Dec 22 13:13:11 2008 +0100
> summary:     v4l2-framework: use correct comment style.
>
> changeset:   9943:2e680d8a3b2f
> user:        Hans Verkuil <hverkuil@xs4all.nl>
> date:        Fri Dec 19 14:20:22 2008 +0100
> summary:     v4l2: document video_device.
>
> changeset:   9820:5611723c9512
> parent:      9767:7100e78482d7
> user:        Hans Verkuil <hverkuil@xs4all.nl>
> date:        Sun Nov 30 01:36:58 2008 +0100
> summary:     v4l2: add v4l2_device and v4l2_subdev structs to the v4l2
> framework.
>
> > The I2C core changes went in in 2.6.22.
>
> I'm not referring to i2c core changes, but to v4l2 dev/subdev stuff.

That's all there to implement the i2c core changes. Yes, it will do a lot 
more in the future, but currently its primary purpose is to switch to the 
new i2c API.

> > And please note that the use of the old API isn't the only question I
> > have, there are more oddities with the i2c handling that I'd like to
> > have more information about. Writing i2c registers directly from the
> > adapter driver doesn't look good to me at first sight.
>
> Yes, I'm aware of the I2C GPIO and similar stuff. This is one of the
> reasons why this shouldn't be merged upstream yet.

Well, these are integral i2c devices, so I'm OK with it. Although I didn't 
have time to do a full review, so I may have missed some issues.

> > > The second point is that there's nothing at
> > > Documentation/feature-removal-schedule.txt informing that those stuff
> > > is deprecated.
> >
> > Yes it is, see this from the 2.6.29 kernel:
> >
> > What:   i2c_attach_client(), i2c_detach_client(),
> > i2c_driver->detach_client() When:   2.6.29 (ideally) or 2.6.30 (more
> > likely)
> > Why:    Deprecated by the new (standard) device driver binding model.
> > Use i2c_driver->probe() and ->remove() instead.
> > Who:    Jean Delvare <khali@linux-fr.org>
>
> I'm not referring to the i2c changes, but to the v4l2 framework ones.
>
> Anyway, checkpatch should be generating warning about this, at least on
> my environment. In this case, no warnings are generated.
>
> Hmm... there's no "check" field on its entry.
>
> Jean should have added a line like:
> Check: i2c_attach_client i2c_detach_client i2c_driver->detach_client
>
> to let checkpatch.pl to do his job.
>
> > > Since his driver seems to be based on em28xx, he had no sample on how
> > > to convert it to
> > > v4l2_device/v4l2_subdev/new_i2c model.
> >
> > Again, if I'd known about it I'd be happy to help with it. Why didn't
> > you put me in contact with him? You know I'm spending a lot of time on
> > this.
>
> Why don't you do it, instead of complaining? It is not upstream, and I
> won't move it upstream yet, as I said before.

Of course I'll do it. The point remains that nobody but you got the 
opportunity to review the code before it went into v4l-dvb. The normal 
procedure is to put it up in a tree and ask for a review first.

> Btw, there's another driver that will likely be sent to me on the next
> few days. I'm not sure if it is using the new model or not. I haven't
> seen the code yet, so I'm not sure what functions it is being used. I
> suspect that it is still using the old model, since its development
> started before months ago, before the v4l2 dev/subdev conversion of the
> drivers.

Just put it up for review and I'll look at it and help the developer fix 
anything in this area.

> > > After committing Devin's Austek patches (also seemed to be based on
> > > em28xx), it will
> > > probably be easier for Uri to convert his driver to the new approach.
> >
> > That depends. As I said, there are other i2c issues that need to be
> > clarified, but I *never* got the chance to ask him since you just
> > merged this driver without the customary public review.
>
> You have the chance right now.
>
> That's why we have the staging v4l/dvb -hg tree: to give everybody a view
> of what's is planned. Also, a public announcement is done automatically
> by hg mailbomb scripts, that sends all committed patches to the patch
> announcement ML.

No, since if you merge a driver using e.g. a deprecated API then that will 
prevent it from being removed in v4l-dvb until you have fixed the driver, 
unless you accept that that driver is marked broken in v4l-dvb. Large 
changes or new drivers might have complications for other works in progress 
that you are not aware of, and so it is important that other developers can 
review it first. I don't know everything that is happening with v4l-dvb, 
and neither do you. But if the community can take a look at new code, then 
the chances are that all together we do know (almost) everything and can 
catch potential problems in time.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
