Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40722 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751443AbdAYLj0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jan 2017 06:39:26 -0500
Date: Wed, 25 Jan 2017 13:38:51 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-ctrls.c: add NULL check
Message-ID: <20170125113851.GB7139@valkosipuli.retiisi.org.uk>
References: <cbf75ba8-3deb-e82a-3007-7bc3465493c4@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbf75ba8-3deb-e82a-3007-7bc3465493c4@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 25, 2017 at 08:38:07AM +0100, Hans Verkuil wrote:
> Check that the control whose events we want to delete is still there.
> 
> Normally this will always be the case, but I am not 100% certain if there aren't
> any corner cases when a device is forcibly unbound.
> 
> In any case, this will satisfy static checkers and simply make it more robust.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Shaobo <shaobo@cs.utah.edu>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
