Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60062 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510AbbHZO7O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2015 10:59:14 -0400
Date: Wed, 26 Aug 2015 11:59:05 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
	devel@driverdev.osuosl.org, shuahkh@osg.samsung.com
Subject: Re: [PATCH v7 11/44] [media] media: use entity.graph_obj.mdev
 instead of .parent
Message-ID: <20150826115905.3a953918@recife.lan>
In-Reply-To: <CAKocOOM7_mgp1ORz1mLzso9AZxSTuEcHAef64_LQ-NZVp5FASw@mail.gmail.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<dc1be98277c46ddd87e431148fc7e332176828ab.1440359643.git.mchehab@osg.samsung.com>
	<55DC0D08.10504@xs4all.nl>
	<CAKocOOM7_mgp1ORz1mLzso9AZxSTuEcHAef64_LQ-NZVp5FASw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Aug 2015 13:25:15 -0600
Shuah Khan <shuahkhan@gmail.com> escreveu:

> On Tue, Aug 25, 2015 at 12:36 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On 08/23/2015 10:17 PM, Mauro Carvalho Chehab wrote:
> >> From: Javier Martinez Canillas <javier@osg.samsung.com>
> >>
> >> The struct media_entity has a .parent field that stores a pointer
> >> to the parent struct media_device. But recently a media_gobj was
> >> embedded into the entities and since struct media_gojb already has
> >> a pointer to a struct media_device in the .mdev field, the .parent
> >> field becomes redundant and can be removed.
> >>
> >> This patch replaces all the usage of .parent by .graph_obj.mdev so
> >> that field will become unused and can be removed on a later patch.
> >>
> >> No functional changes.
> >>
> >> The transformation was made using the following coccinelle spatch:
> >>
> >> @@
> >> struct media_entity *me;
> >> @@
> >>
> >> - me->parent
> >> + me->graph_obj.mdev
> >>
> >> @@
> >> struct media_entity *link;
> >> @@
> >>
> >> - link->source->entity->parent
> >> + link->source->entity->graph_obj.mdev
> >>
> >> @@
> >> struct exynos_video_entity *ve;
> >> @@
> >>
> >> - ve->vdev.entity.parent
> >> + ve->vdev.entity.graph_obj.mdev
> >>
> >> Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >>
> >> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The change looks good to me. I would really like to see a before and after
> media graph with these changes, this patch and series in general.

Well, it shouldn't change. If something changes, things would be wrong
:)

Btw, Javier is doing a before/after tests on OMAP3. There are a few
fixup things to be added/adjusted (unfortunately, OMAP3 doesn't compile
on x86 COMPILE_TEST), but on his tests, the differences between before
and after, with media-ctl are zero.

As media-ctl is using the legacy API, it shouldn't have any changes
there, otherwise something is broken and should be fixed ;)

I'll spin this patch series with Javier fixes for OMAP at the next 
version of this patch series.

> 
> thanks,
> -- Shuah
