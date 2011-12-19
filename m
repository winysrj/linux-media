Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51621 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1LSATH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Dec 2011 19:19:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: Trying to figure out reasons for lost pictures in UVC driver.
Date: Mon, 19 Dec 2011 01:19:07 +0100
Cc: linux-media@vger.kernel.org
References: <CACKLOr1qSpJXjyptUF3OEWR2b7XNoRdMjiVWzZ9gtuanfgJZDQ@mail.gmail.com>
In-Reply-To: <CACKLOr1qSpJXjyptUF3OEWR2b7XNoRdMjiVWzZ9gtuanfgJZDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112190119.08008.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Thursday 15 December 2011 17:02:47 javier Martin wrote:
> Hi,
> we are testing a logitech Webcam M/N: V-U0012 in the UVC tree (commit
> ef7728797039bb6a20f22cc2d96ef72d9338cba0).
> It is configured at 25fps, VGA.
> 
> We've observed that the following debugging message appears sometimes
> "Frame complete (FID bit toggled).". Whenever this happens a v4l2
> frame is lost (i.e. one sequence number has been skipped).
> 
> Is this behavior expected? What could we do to avoid frame loss?

Could you check the frame intervals to see if a frame is really lost, or if 
the driver erroneously reports frame loss ?

-- 
Regards,

Laurent Pinchart
