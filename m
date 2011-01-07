Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35491 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1AGNgd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 08:36:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 2/5] v4l2-subdev: add (un)register internal ops
Date: Fri, 7 Jan 2011 14:37:16 +0100
Cc: linux-media@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
References: <1294404455-22050-1-git-send-email-hverkuil@xs4all.nl> <2bce44c24896652e068d2c2a679e13c6bd820b65.1294402580.git.hverkuil@xs4all.nl>
In-Reply-To: <2bce44c24896652e068d2c2a679e13c6bd820b65.1294402580.git.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101071437.16632.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for the patch.

On Friday 07 January 2011 13:47:32 Hans Verkuil wrote:
> Some subdevs need to call into the board code after they are registered
> and have a valid struct v4l2_device pointer. The s_config op was abused
> for this, but now that it is removed we need a cleaner way of solving this.
> 
> So this patch adds a struct with internal ops that the v4l2 core can call.
> 
> Currently only two ops exist: register and unregister. Subdevs can
> implement these to call the board code and pass it the v4l2_device
> pointer, which the board code can then use to get access to the struct
> that embeds the v4l2_device.
> 
> It is expected that in the future open and close ops will also be added.
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
