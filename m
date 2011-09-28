Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4160 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab1I1JAU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 05:00:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [GIT PULL] Selection API and fixes for v3.2
Date: Wed, 28 Sep 2011 11:00:07 +0200
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org
References: <1316704391-13596-1-git-send-email-m.szyprowski@samsung.com> <201109281001.03564.hverkuil@xs4all.nl> <201109281029.38009.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201109281029.38009.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281100.07662.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, September 28, 2011 10:29:37 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Wednesday 28 September 2011 10:01:03 Hans Verkuil wrote:
> > On Tuesday, September 27, 2011 18:46:10 Tomasz Stanislawski wrote:
> > > On 09/27/2011 04:10 PM, Mauro Carvalho Chehab wrote:
> > > > Em 27-09-2011 10:02, Tomasz Stanislawski escreveu:
> > > >> On 09/26/2011 02:10 PM, Mauro Carvalho Chehab wrote:
> > > >>> Em 26-09-2011 05:42, Tomasz Stanislawski escreveu:
> > > >>>> On 09/24/2011 05:58 AM, Mauro Carvalho Chehab wrote:
> > > >>>>> Em 22-09-2011 12:13, Marek Szyprowski escreveu:
> 
> [snip]
> 
> > > The legacy applications would be supported by simulation of old API
> > > using selection API.
> > 
> > As I said before, G/S_CROP is perfectly valid and will not go away or be
> > deprecated. Just as S_CTRL is not replaced by S_EXT_CTRLS. There is no need
> > to force apps to move to the selection API. The selection API extends the
> > old crop API for good reasons, but for simple cropping S_CROP remains
> > perfectly fine.
> 
> Now, of course. In a couple years time, the story will likely be different, 
> and we might want to deprecate the G/S_CROP API. Shouldn't this message be 
> conveyed to userspace developers ? I like the idea of asking them to favor the 
> selection API over the crop API for new applications.

Why? It's like asking them not to use G_CTRL. Never going to happen.

For one thing even if the new API arrives in, say, kernel 3.2 it will take
at least 3 years before applications can even start to assume that most users
will have upgraded to a selection-aware kernel.

It's fine of course to refer to the selection API in the current crop documentation,
particularly when using the crop API for output devices (since the old API is
very confusing in that particular use-case).

But you just can't deprecate it, nor is there IMHO any reason to do so.

I'm not sure if we ever deprecated any V4L2 API in the past. If we have it
was probably for either unused or ambiguous features that apps couldn't rely
on anyway.

Regards,

	Hans

> > What would be nice is to deprecate the old crop ops for new drivers and
> > (ideally) convert existing drivers that use vidioc_g/s_crop to the new
> > vidioc_g/s_selection (with the final goal of removing vidioc_g/s_crop).
> > 
> > And also note that cropcap is still needed to get the pixelaspect.
> 
> 
