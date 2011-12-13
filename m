Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33518 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab1LMAka (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 19:40:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH v4 0/3] fbdev: Add FOURCC-based format configuration API
Date: Tue, 13 Dec 2011 01:40:44 +0100
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org
References: <1322562419-9934-1-git-send-email-laurent.pinchart@ideasonboard.com> <201112121708.30839.laurent.pinchart@ideasonboard.com> <4EE64CC2.5090906@gmx.de>
In-Reply-To: <4EE64CC2.5090906@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112130140.45045.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Monday 12 December 2011 19:49:38 Florian Tobias Schandinat wrote:
> On 12/12/2011 04:08 PM, Laurent Pinchart wrote:
> > On Tuesday 29 November 2011 11:26:56 Laurent Pinchart wrote:
> >> Hi everybody,
> >> 
> >> Here's the fourth version of the fbdev FOURCC-based format configuration
> >> API.
> > 
> > Is there a chance this will make it to v3.3 ?
> 
> Yes, that's likely. I thought you wanted to post a new version of 2/3?

Oops, seems I forgot to send it. Sorry :-/ I'll post a new version tomorrow.

> I think you also want to do something with red, green, blue, transp when
> entering FOURCC mode, at least setting them to zero or maybe even requiring
> that they are zero to enter FOURCC mode (as additional safety barrier).

Agreed. The FOURCC mode documentation already requires those fields to be set 
to 0 by applications.

I'll enforce this in fb_set_var() if info->fix has the FB_CAP_FOURCC 
capability flag set.

-- 
Regards,

Laurent Pinchart
