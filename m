Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42400 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab1FOIJG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 04:09:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 1/4 v9] v4l: add fourcc definitions for compressed formats.
Date: Wed, 15 Jun 2011 10:09:16 +0200
Cc: "'Hans Verkuil'" <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	jtp.park@samsung.com
References: <1308069416-24723-1-git-send-email-k.debski@samsung.com> <201106150839.59635.hverkuil@xs4all.nl> <005501cc2b33$099b4940$1cd1dbc0$%debski@samsung.com>
In-Reply-To: <005501cc2b33$099b4940$1cd1dbc0$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106151009.16791.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Kamil,

On Wednesday 15 June 2011 10:05:42 Kamil Debski wrote:
> On 15 June 2011 08:40 Hans Verkuil wrote:
> > On Tuesday, June 14, 2011 18:36:53 Kamil Debski wrote:
> > > Add fourcc definitions and documentation for the following
> > > compressed formats: H264, H264 without start codes,
> > > MPEG1/2/4 ES, DIVX versions 3.11, 4, 5.0-5.0.2, 5.03 and up,
> > > XVID, VC1 Annex G and Annex L compliant.
> > > 
> > > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

[snip]

> > Just to verify: are all these formats actually used in the driver?
> 
> All but the DIVX and V4L2_PIX_FMT_H264_NO_SC pixel format.
> V4L2_PIX_FMT_H264_NO_SC pixel format was requested by Laurent.

I'm fine with adding it later when a driver will use it.

-- 
Regards,

Laurent Pinchart
