Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:50234 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935810Ab1JFMGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 08:06:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller framework and add video format detection
Date: Thu, 6 Oct 2011 14:06:13 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	linux-media@vger.kernel.org, Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com> <201110060923.14797.hverkuil@xs4all.nl> <4E8D9633.5040303@infradead.org>
In-Reply-To: <4E8D9633.5040303@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110061406.13117.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 06 October 2011 13:51:15 Mauro Carvalho Chehab wrote:
> Em 06-10-2011 04:23, Hans Verkuil escreveu:
> > On Thursday, October 06, 2011 09:09:26 Hans Verkuil wrote:
> >> On Thursday, October 06, 2011 02:32:33 Mauro Carvalho Chehab wrote:
> >>> Also, I couldn't see a consense about input selection on drivers that
> >>> implement MC: they could either implement S_INPUT, create one V4L
> >>> device node for each input, or create just one devnode and let
> >>> userspace (somehow) to discover the valid inputs and set the pipelines
> >>> via MC/pad.
> >> 
> >> I don't follow. I haven't seen any MC driver yet that uses S_INPUT as
> >> that generally doesn't make sense. But for a device like tvp5150 we
> >> probably need it since the tvp5150 has multiple inputs. This is
> >> actually an interesting challenge how to implement this as this is
> >> platform-level knowledge. I suspect that the only way to do this that
> >> is sufficiently generic is to model this with MC links.
> 
> $ git grep s_input drivers/media/video/s5p-*
> drivers/media/video/s5p-fimc/fimc-capture.c:      .vidioc_s_input          
>       = fimc_cap_s_input,
> 
> The current code does nothing, but take a look at what was there before
> changeset 3e002182.
> 
>  From the discussions we had at the pull request that s_input code were
> being changed/removed, It became clear to me that omap3 drivers took one
> direction, and s5p drivers took another direction, in terms on how to
> associate the V4L2 device nodes with the IP blocks.

>From what I remember the s5p drivers converged/are converging on the same
approach as omap3. I don't believe there is any discussion anymore on what is 
the correct method.

> >> All these libraries are on Laurent's site. Can we please move it to
> >> linuxtv?
> 
> Yes, please.
> 
> >> Mauro, wouldn't it be a good idea to create a media-utils.git and merge
> >> v4l-utils, dvb-apps and these new media utils/libs in there?
> 
> I like that idea. I remember that some dvb people argued against when we
> first come to it, but I think that merging both is the right thing to do.
> 
> In any case, libmediactl/libv4l2subdev should, IMHO, be part of the
> v4l-utils.
> 
> I suggest to open a separate thread for this subject.
> 
> For stable distros, merging packages are painful, as their policies may
> forbid package source removal. So, maybe it makes sense to have something
> like: "./configure --disable-[feature]" in order to allow them to keep
> maintaining separate sources for separate parts of a media-utils tree.
> That also means that a "--disable-libv4l" would force libv4l-aware
> applications to be built statically linked.

Seems very complicated to me. But I'll start a separate thread for this.

...

> >> Whether or not you include a scaler in the default pipeline is optional
> >> as far as I am concerned.
> 
> I think that such default pipeline should include a scaler, especially if
> the sensor(s)/demod(s) on such pipeline don't have it.

That would be the ideal situation, yes, but for now I'd be happy just to get a 
picture out of an SoC :-)

Regards,

	Hans
