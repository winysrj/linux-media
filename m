Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1882 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1IZJIZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 05:08:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Capture menu reorganization
Date: Mon, 26 Sep 2011 11:07:40 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1314797925-8113-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1314797925-8113-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109261107.40729.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the past few weeks I've been unable to work on V4L due to real-life
interfering :-)

As a result I haven't followed-up on this, but I do have time again so I
intend to have a new patch some time this week incorporating the comments
I received and also reorganizing the radio menu.

Regards.

	Hans

On Wednesday, August 31, 2011 15:38:39 Hans Verkuil wrote:
> I think this is how I would reorganize the capture menu. IMHO it's much easier
> to navigate, and should be even better once the soc-camera sensor drivers can
> be moved to the other sensors.
> 
> For the radio adapters a similar change would be needed (all the ISA drivers
> in particular should be grouped in a submenu).
> 
> Regards,
> 
> 	Hans
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
