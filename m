Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:33817 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZIOM1E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 08:27:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: RFCv2: Media controller proposal
Date: Tue, 15 Sep 2009 14:28:00 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
References: <200909100913.09065.hverkuil@xs4all.nl> <Pine.LNX.4.64.0909102252190.4458@axis700.grange> <200909102359.20249.hverkuil@xs4all.nl>
In-Reply-To: <200909102359.20249.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909151428.00366.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 10 September 2009 23:59:20 Hans Verkuil wrote:
> On Thursday 10 September 2009 23:28:40 Guennadi Liakhovetski wrote:
> > Hi Hans
> >
> > a couple of comments / questions from the first glance
> >
> > On Thu, 10 Sep 2009, Hans Verkuil wrote:
> >
[snip]

> > > This requires no API changes and is very easy to implement. One problem
> > > is that this is not thread-safe. We can either supply some sort of
> > > locking mechanism, or just tell the application programmer to do the
> > > locking in the application. I'm not sure what is the correct approach
> > > here. A reasonable compromise would be to store the target entity as
> > > part of the filehandle. So you can open the media controller multiple
> > > times and each handle can set its own target entity.
> > >
> > > This also has the advantage that you can have a filehandle 'targeted'
> > > at a resizer and a filehandle 'targeted' at the previewer, etc. If you
> > > want to use the same filehandle from multiple threads, then you have to
> > > implement locking yourself.
> >
> > You mean the driver should only care about internal consistency, and the
> > user is allowed to otherwise shoot herself in the foot? Makes sense to
> > me:-)
> 
> Basically, yes :-)
> 
> You can easily make something like a VIDIOC_MC_LOCK and VIDIOC_MC_UNLOCK
> ioctl that can be used to get exclusive access to the MC. Or we could
> reuse the G/S_PRIORITY ioctls. The first just feels like a big hack to me,
> the second has some merit, I think.

The target entity should really be stored at the file handle level, otherwise 
Very Bad Stuff (TM) will happen. Then, if a multi-threaded application wants 
to access the file handle from multiple threads, it will need to implement its 
own serializing.

I don't think any VIDIOC_MC_LOCK/UNLOCK is required, what would be the use 
cases for them ?

> > > Open issues
> > > ===========

[snip]

> > > 2) There can be a lot of device nodes in complicated boards. One
> > > suggestion is to only register them when they are linked to an entity
> > > (i.e. can be active). Should we do this or not?
> >
> > Really a lot of device nodes? not sub-devices? What can this be? Isn't
> > the decision when to register them board-specific?
> 
> Sub-devices do not in general have device nodes (note that i2c sub-devices
> will have an i2c device node, of course).
> 
> When to register device nodes is in the end driver-specific, but what to do
> when enumerating input device nodes and the device node doesn't exist yet?
> 
> I can't put my finger on it, but my intuition says that doing this is
> dangerous. I can't oversee all the consequences.

Why would it be dangerous ? As long as an input or output device node is not 
connected to anything in the internal board "graph" it will be completely 
pointless for applications to use those device nodes. What do you imagine 
going wrong ?

[snip]

> > > 6) For now I think we should leave enumerating input and output
> > > connectors to the bridge drivers (ENUMINPUT/ENUMOUTPUT). But as a
> > > future step it would make sense to also enumerate those in the media
> > > controller. However, it is not entirely clear what the relationship
> > > will be between that and the existing enumeration ioctls.
> >
> > Why should a bridge driver care? This isn't board-specific, is it?
> 
> I don't follow you. What input and output connectors a board has is by
> definition board specific. If you can enumerate them through the media
> controller, then you can be more precise how they are hooked up. E.g. an
> antenna input is connected to a tuner sub-device, while the composite
> video-in is connected to a video decoder and the audio inputs to an audio
> mixer sub-device. All things that cannot be represented by ENUMINPUT. But
> do we really care about that?
>
> My opinion is that we should leave this alone for now. There is enough to
> do and we can always add it later.

In that end that boils down to a (few) table(s) of static data. It won't make 
drivers more complex, and I think we should support enumerating the input and 
output connectors at the media controller level, if only for the sake of 
completeness and coherency.

-- 
Regards,

Laurent Pinchart
