Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41060 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753339AbbIVJut (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 05:50:49 -0400
Date: Tue, 22 Sep 2015 12:50:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Benoit Parrot <bparrot@ti.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [Patch v2] media: v4l2-ctrls: Fix 64bit support in get_ctrl()
Message-ID: <20150922095012.GP3175@valkosipuli.retiisi.org.uk>
References: <1442851401-10864-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1442851401-10864-1-git-send-email-bparrot@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 21, 2015 at 11:03:21AM -0500, Benoit Parrot wrote:
> When trying to use v4l2_ctrl_g_ctrl_int64() to retrieve a
> V4L2_CTRL_TYPE_INTEGER64 type value the internal helper function
> get_ctrl() would prematurely exits because for this control type
> the 'is_int' flag is not set. This would result in v4l2_ctrl_g_ctrl_int64
> always returning 0.
> Also v4l2_ctrl_g_ctrl_int64() is reading and returning the 32bit value
> member instead of the 64bit version, so fixing that as well.
> 
> This patch extend the condition check to allow V4L2_CTRL_TYPE_INTEGER64
> type to continue processing instead of exiting.
> 
> Signed-off-by: Benoit Parrot <bparrot@ti.com>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
