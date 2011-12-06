Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43672 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933327Ab1LFMeh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 07:34:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [RFC/PATCH 0/5] v4l: New camera controls
Date: Tue, 6 Dec 2011 13:34:45 +0100
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	hverkuil@xs4all.nl, riverful.kim@samsung.com,
	s.nawrocki@samsung.com
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
In-Reply-To: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112061334.45936.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sunday 04 December 2011 16:16:11 Sylwester Nawrocki wrote:
> Hi All,
> 
> I put some effort in preparing a documentation for a couple of new controls
> in the camera control class. It's a preeliminary work, it's mainly just
> documentation. There is yet no patches for any driver using these controls.
> I just wanted to get some possible feedback on them, if this sort of stuff
> is welcome and what might need to be done differently.

Thanks for the patches.

Regarding patches 3/5, 4/5 and 5/5, we should perhaps try to brainstorm this a 
bit. There's more to exposure setting than just those controls, maybe it's 
time to think about a proper exposure API. We could start by gathering 
requirements on the list, and maybe have an IRC meeting if needed.

-- 
Regards,

Laurent Pinchart
