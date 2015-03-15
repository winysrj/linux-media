Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40553 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751638AbbCOAXZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 20:23:25 -0400
Date: Sun, 15 Mar 2015 02:23:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-ioctl: allow all controls if ctrl_class == 0
Message-ID: <20150315002322.GB11954@valkosipuli.retiisi.org.uk>
References: <550461A9.7040105@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <550461A9.7040105@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 14, 2015 at 05:28:25PM +0100, Hans Verkuil wrote:
> The check_ext_ctrls() function in v4l2-ioctl.c checks if all controls in the
> control array are from the same control class as c->ctrl_class. However,
> that check should only be done if c->ctrl_class != 0. A 0 value means
> that this restriction does not apply.
> 
> So return 1 (OK) if c->ctrl_class == 0.
> 
> Found by running v4l2-compliance on the uvc driver.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
