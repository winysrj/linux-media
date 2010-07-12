Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:42243 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab0GLPeg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jul 2010 11:34:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: macbook webcam no longer works on .35-rc
Date: Mon, 12 Jul 2010 17:34:28 +0200
Cc: linux-media@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <1277932269.11050.1.camel@jlt3.sipsolutions.net> <201007051023.40923.laurent.pinchart@ideasonboard.com> <1278938186.5870.18.camel@jlt3.sipsolutions.net>
In-Reply-To: <1278938186.5870.18.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007121734.29394.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Johannes,

On Monday 12 July 2010 14:36:26 Johannes Berg wrote:
> On Mon, 2010-07-05 at 10:23 +0200, Laurent Pinchart wrote:
> > Could you please test the following patch when you will have time ?
> 
> That fixes it, thank you.

The fix has been applied to 
http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=shortlog 
and should end up in the next 2.6.35-rc.

-- 
Regards,

Laurent Pinchart
