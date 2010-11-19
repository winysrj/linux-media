Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56000 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0KSNvl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 08:51:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH/RFC] v4l: Add subdev sensor g_skip_frames operation
Date: Fri, 19 Nov 2010 14:51:43 +0100
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de
References: <1290173202-28769-1-git-send-email-laurent.pinchart@ideasonboard.com> <201011191442.31982.hverkuil@xs4all.nl>
In-Reply-To: <201011191442.31982.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011191451.44465.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans,

On Friday 19 November 2010 14:42:31 Hans Verkuil wrote:
> On Friday 19 November 2010 14:26:42 Laurent Pinchart wrote:
> > Some buggy sensors generate corrupt frames when the stream is started.
> > This new operation returns the number of corrupt frames to skip when
> > starting the stream.
> 
> Looks OK, but perhaps the two should be combined to one function?

I'm fine with both. Guennadi, any opinion ?

> I also have my doubts about the sensor_ops in general. I expected
> originally to see a lot of ops here, but apparently there is little or no
> need for it.
> 
> Do we expect to see this grow, or would it make more sense to move the ops
> to video_ops? I'd be interested to hear what sensor specialists think.

Good question. It won't remove the need for the g_skip_frames operation, but 
it's certainly worth asking. Standards are emerging for sensors in specific 
markets (SMIA comes to mind - I'm not sure if the spec is public, but some 
information can be found online) and there will probably be a need to provide 
more sensor information to both "bridge" drivers and userspace applications in 
the future.

-- 
Regards,

Laurent Pinchart
