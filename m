Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33546 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab1I1I3j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 04:29:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL] Selection API and fixes for v3.2
Date: Wed, 28 Sep 2011 10:29:37 +0200
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org
References: <1316704391-13596-1-git-send-email-m.szyprowski@samsung.com> <4E81FDD2.3090501@samsung.com> <201109281001.03564.hverkuil@xs4all.nl>
In-Reply-To: <201109281001.03564.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281029.38009.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 28 September 2011 10:01:03 Hans Verkuil wrote:
> On Tuesday, September 27, 2011 18:46:10 Tomasz Stanislawski wrote:
> > On 09/27/2011 04:10 PM, Mauro Carvalho Chehab wrote:
> > > Em 27-09-2011 10:02, Tomasz Stanislawski escreveu:
> > >> On 09/26/2011 02:10 PM, Mauro Carvalho Chehab wrote:
> > >>> Em 26-09-2011 05:42, Tomasz Stanislawski escreveu:
> > >>>> On 09/24/2011 05:58 AM, Mauro Carvalho Chehab wrote:
> > >>>>> Em 22-09-2011 12:13, Marek Szyprowski escreveu:

[snip]

> > The legacy applications would be supported by simulation of old API
> > using selection API.
> 
> As I said before, G/S_CROP is perfectly valid and will not go away or be
> deprecated. Just as S_CTRL is not replaced by S_EXT_CTRLS. There is no need
> to force apps to move to the selection API. The selection API extends the
> old crop API for good reasons, but for simple cropping S_CROP remains
> perfectly fine.

Now, of course. In a couple years time, the story will likely be different, 
and we might want to deprecate the G/S_CROP API. Shouldn't this message be 
conveyed to userspace developers ? I like the idea of asking them to favor the 
selection API over the crop API for new applications.

> What would be nice is to deprecate the old crop ops for new drivers and
> (ideally) convert existing drivers that use vidioc_g/s_crop to the new
> vidioc_g/s_selection (with the final goal of removing vidioc_g/s_crop).
> 
> And also note that cropcap is still needed to get the pixelaspect.

-- 
Regards,

Laurent Pinchart
