Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4840 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966226Ab0GQKYt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jul 2010 06:24:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [RFC v4] Multi-plane buffer support for V4L2 API
Date: Sat, 17 Jul 2010 12:27:07 +0200
Cc: "'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
	"'Linux Media Mailing List'" <linux-media@vger.kernel.org>,
	"'Hans de Goede'" <hdegoede@redhat.com>, kyungmin.park@samsung.com
References: <004b01cb1f98$e586ae10$b0940a30$%osciak@samsung.com> <4C3B8923.1040109@redhat.com> <002801cb226f$e462b720$ad282560$%osciak@samsung.com>
In-Reply-To: <002801cb226f$e462b720$ad282560$%osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007171227.08031.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 13 July 2010 11:43:47 Pawel Osciak wrote:
> Hi Mauro,
> 
> thanks for taking the time to look at this.
> 
> >Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> >
> >With Hans proposed changes that you've already acked, I think the proposal is
> >ok,
> >except for one detail:
> >
> >> 4. Format enumeration
> >> ----------------------------------
> >> struct v4l2_fmtdesc, used for format enumeration, does include the
> >v4l2_buf_type
> >> enum as well, so the new types can be handled properly here as well.
> >> For drivers supporting both versions of the API, 1-plane formats should be
> >> returned for multiplanar buffer types as well, for consistency. In other
> >words,
> >> for multiplanar buffer types, the formats returned are a superset of those
> >> returned when enumerating with the old buffer types.
> >>
> >
> >We shouldn't mix types here. If the userspace is asking for multi-planar
> >types,
> >the driver should return just the multi-planar formats.
> >
> >If the userspace wants to know about both, it will just call for both types
> >of
> >formats.
> 
> Yes. Although the idea here is that we wanted to be able to use single-planar
> formats with either the old API or the new multiplane API. In the new API, you
> could just set num_planes=1.
> 
> So multiplanar API != multiplanar format. When you enum_fmt for mutliplanar
> types, you get "all formats you can use with the multiplanar API" and not
> "all formats that have num_planes > 1".
> 
> This can simplify applications - they don't have to switch between APIs when
> switching between formats. They may even choose not to use the old API at all
> (if a driver allows it).
> 
> Do we want to lose the ability to use multiplanar API for single-plane
> formats?

I'm very much opposed to making num_planes=1 a special case in the multiplanar
API. Just like the extended control API can still handle 'normal' controls (well,
they should, at least :-) ), so should the multiplanar API be a superset of the normal
API. Anything else would make applications unnecessarily complex.

Any driver that has multiplanar formats should be using the videobuf2 framework.
Which will hopefully make it very easy to have support for both 1-plane and
multiplanar APIs. Probably the only place where you need to do something special
is in ENUM_FMT: the multiplanar stream type will enumerate all formats, the 'old'
stream types will only enumerate the 1-plane formats.

So minimal impact to the driver, but nicely consistent towards the application.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
