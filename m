Return-path: <mchehab@gaivota>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2177 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab1ELUBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 16:01:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [GIT PATCHES FOR 2.6.39] Fix subdev control enumeration
Date: Thu, 12 May 2011 22:00:18 +0200
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com
References: <201105021319.03696.hansverk@cisco.com>
In-Reply-To: <201105021319.03696.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105122200.18449.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

I haven't seen this fix appearing upstream, did it slip through the cracks?

Regards,

	Hans

On Monday, May 02, 2011 13:19:03 Hans Verkuil wrote:
> Hi Mauro,
> 
> This fix is for 2.6.39. Control enumeration for subdev device nodes is broken. 
> The fix is simple and has been tested by Sakari.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 28df73703e738d8ae7a958350f74b08b2e9fe9ed:
>   Mauro Carvalho Chehab (1):
>         [media] xc5000: Improve it to work better with 6MHz-spaced channels
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/hverkuil/media_tree.git ctrl-fix
> 
> Hans Verkuil (1):
>       v4l2-subdev: fix broken subdev control enumeration
> 
>  drivers/media/video/v4l2-subdev.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
