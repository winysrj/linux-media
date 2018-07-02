Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43944 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751535AbeGBMsm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 08:48:42 -0400
Date: Mon, 2 Jul 2018 15:48:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH] media: mark entity-intf links as IMMUTABLE
Message-ID: <20180702124840.wjqsxmmewm554fxh@valkosipuli.retiisi.org.uk>
References: <7a8dae57-3161-d787-c1bd-95abbdae5633@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a8dae57-3161-d787-c1bd-95abbdae5633@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 02, 2018 at 02:43:02PM +0200, Hans Verkuil wrote:
> Currently links between entities and an interface are just marked as
> ENABLED. But (at least today) these links cannot be disabled by userspace
> or the driver, so they should also be marked as IMMUTABLE.
> 
> It might become possible that drivers can disable such links (if for some
> reason the device node cannot be used), so we might need to add a new link
> flag at some point to mark interface links that can be changed by the driver
> but not by userspace.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
