Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46573 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933805Ab2HWKoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 06:44:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [media-ctl PATCH 1/1] Count users for entities
Date: Thu, 23 Aug 2012 12:45:15 +0200
Message-ID: <2829548.6q3LBXixyM@avalon>
In-Reply-To: <1345476735-14570-1-git-send-email-sakari.ailus@iki.fi>
References: <1345476735-14570-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Monday 20 August 2012 18:32:15 Sakari Ailus wrote:
> The subdev nodes used to be closed immediately on v4l2_subdev_close(), now
> the subdev is only closed if there are no users left anymore. This changes
> the API from immediate effect (close) to a reference counting one.
> 
> Also make functions opening subdevs to close them before returning. This
> resolves issues on some machines where not all subdevs can be opened at the
> same time. Power management wise this is a sound choice since it forces to
> make the decision when to keep a device powered rather than keeping
> everything open all the time.

This doesn't apply. Could you please rebase it on the latest master branch ?

-- 
Regards,

Laurent Pinchart
