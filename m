Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:54303 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab0INJvV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 05:51:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: how can deal with the stream in only on-the-fly-output available HW block??
Date: Tue, 14 Sep 2010 11:51:19 +0200
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	inki.dae@samsung.com, kyungmin.park@samsung.com
References: <026801cb53cb$49f09080$ddd1b180$%kim@samsung.com>
In-Reply-To: <026801cb53cb$49f09080$ddd1b180$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009141151.20404.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Kim,

On Tuesday 14 September 2010 07:11:29 Kim, HeungJun wrote:

[snip]

> > You probably need the upcoming media API to be able to correctly deal with
> > these issues. Check the mailing list for the patches done by Laurent
> > Pinchart.
> > 
> > The current V4L2 API is really not able to handle changes in the internal
> > video stream topology.
> 
> Thanks to Hans. It's very helpful.
> I'll check Laurent's media topology patches.
> 
> Hello, Laurent,
> 
> I'm googling and find your patches, so I'm checking with. But, where can I
> get your patches?? Probably, I would find in this page :
> http://git.linuxtv.org/, so what's your repository?

Clone http://git.linuxtv.org/pinchartl/media.git and checkout the media-0003-
subdev-pad branch.

-- 
Regards,

Laurent Pinchart
