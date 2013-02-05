Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40848 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3BEJIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 04:08:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sean V Kelley <sean.v.kelley@intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: Implement videobuf2 .wait_prepare and .wait_finish operations
Date: Tue, 05 Feb 2013 10:08:52 +0100
Message-ID: <1596838.QUSgh4fGy1@avalon>
In-Reply-To: <CA+qSnqj25NRCGXnS4-AJ34zpa+kOCTM--RY95Qfd0mZfcrhTHQ@mail.gmail.com>
References: <1358765501-29285-1-git-send-email-laurent.pinchart@ideasonboard.com> <CA+qSnqj25NRCGXnS4-AJ34zpa+kOCTM--RY95Qfd0mZfcrhTHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

On Monday 04 February 2013 12:36:47 Sean V Kelley wrote:
> On Mon, Jan 21, 2013 at 2:51 AM, Laurent Pinchart wrote:
> > Those optional operations are used to release and reacquire the queue
> > lock when videobuf2 needs to perform operations that sleep for a long
> > time, such as waiting for a buffer to be complete. Implement them to
> > avoid blocking qbuf or streamoff calls when a dqbuf is in progress.
> 
> Speaking of UVC, are there plans to look into supporting UVC 1.5
> specification?  Are you aware of any development in that area for new
> controls?

There's work in progress to implement UVC 1.5 but I'm not sure how much 
details I can share. I should get a progress report in two weeks at the ELC in 
San Francisco, will you happen to be there by any chance ?

You're the third Intel developer who contacts me about UVC in the last 3 days, 
I assume that's not a coincidence. If you ever need consulting services on the 
uvcvideo driver (or just if you think collaboration would be helpful) please 
feel free to contact me.

-- 
Regards,

Laurent Pinchart

