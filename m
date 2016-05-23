Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41330 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753564AbcEWNwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 09:52:22 -0400
Date: Mon, 23 May 2016 16:52:16 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4 0/6] R-Car VSP: Add and set media entities functions
Message-ID: <20160523135216.GD26360@valkosipuli.retiisi.org.uk>
References: <1463701232-22008-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1463701232-22008-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 20, 2016 at 02:40:26AM +0300, Laurent Pinchart wrote:
> Hello,
> 
> This patch series adds new media entities functions for video processing and
> video statistics computation, and updates the VSP driver to use the new
> functions.
> 
> Patches 1/6 and 2/6 define and document the new functions. They have been
> submitted previously in the "[PATCH v2 00/54] R-Car VSP improvements for v4.7"
> patch series, this version takes feedback received over e-mail and IRC into
> account.
> 
> Patches 3/6 to 5/6 prepare the VSP driver to report the correct entity
> functions. They make sure that the LIF will never be exposed to userspace as
> no function currently exists for that block, and it isn't clear at the moment
> what new function should be added. As the LIF is only needed when the VSP is
> controlled directly from the DU driver without being exposed to userspace, a
> function isn't needed for the LIF anyway.
> 
> Patch 6/6 finally sets functions for all the VSP entities.
> 
> The code is based on top of the "[PATCH/RFC v2 0/4] Meta-data video device
> type" patch series, although it doesn't strictly depend on it. For convenience
> I've pushed all patches to

Thanks!

For patches 1 and 2:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
