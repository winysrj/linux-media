Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35146 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755720AbcEXQ0h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:26:37 -0400
Date: Tue, 24 May 2016 19:26:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH/RFC v2 1/4] v4l: Add metadata buffer type and format
Message-ID: <20160524162632.GG26360@valkosipuli.retiisi.org.uk>
References: <1463012283-3078-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1463012283-3078-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <5742D6CC.8040909@xs4all.nl>
 <20160524152831.GF26360@valkosipuli.retiisi.org.uk>
 <5744750A.5070205@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5744750A.5070205@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, May 24, 2016 at 05:36:42PM +0200, Hans Verkuil wrote:
> On 05/24/2016 05:28 PM, Sakari Ailus wrote:
> > Hi Hans,
> > 
> >> Should it be mentioned here that changing the video format might change
> >> the buffersize? In case the buffersize is always a multiple of the width?
> > 
> > Isn't that the case in general, as with pixel formats? buffersize could also
> > be something else than a multiple of width (there's no width for metadata
> > formats) due to e.g. padding required by hardware.
> 
> Well, I don't think it is obvious that the metadata buffersize depends on the
> video width. Perhaps developers who are experienced with CSI know this, but
> if you know little or nothing about CSI, then it can be unexpected (hey, that
> was the case for me!).
> 
> I think it doesn't hurt to mention this relation.

Ah, I think I misunderstood you first.

Typically the metadata width is the same as the image data width, that's
true. And it's how the hardware works. This is still visible in the media
bus format and the solution belongs rather to how multiple streams over a
single link are supported.

It's just that setting the image media bus format affects the metadata media
bus format. I guess that could be mentioned albeit it's hardware specific,
on some sensors metadata width is independent of the image width. Even then
this is not where I'd put it. I'd get back to the topic when documenting how
the API for multiple streams over a single link works.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
