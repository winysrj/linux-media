Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:54194 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030425Ab2CNIgX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 04:36:23 -0400
Date: Wed, 14 Mar 2012 10:36:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Bhupesh Sharma <bhupesh.sharma@st.com>
Subject: Re: [PATCH] media: Initialize the media core with subsys_initcall()
Message-ID: <20120314083616.GE4220@valkosipuli.localdomain>
References: <bbe7861cb38c036d3c24df908ffbfc125274ea99.1331543025.git.bhupesh.sharma@st.com>
 <1331560967-32396-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331560967-32396-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch!

On Mon, Mar 12, 2012 at 03:02:47PM +0100, Laurent Pinchart wrote:
> Media-related drivers living outside drivers/media/ (such as the UVC
> gadget driver in drivers/usb/gadget/) rely on the media core being
> initialized before they're probed. As drivers/usb/ is linked before
> drivers/media/, this is currently not the case and will lead to crashes
> if the drivers are not compiled as modules.
> 
> Register media_devnode_init() as a subsys_initcall() instead of
> module_init() to fix this.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/media-devnode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
Tested-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
