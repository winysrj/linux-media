Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44794 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752243AbaD3WqV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Apr 2014 18:46:21 -0400
Date: Thu, 1 May 2014 01:45:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 01/26] omap3isp: stat: Rename IS_COHERENT_BUF to
 ISP_STAT_USES_DMAENGINE
Message-ID: <20140430224547.GT8753@valkosipuli.retiisi.org.uk>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1398083352-8451-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398083352-8451-2-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the set! I've been looking forward to see this! :)

On Mon, Apr 21, 2014 at 02:28:47PM +0200, Laurent Pinchart wrote:
> The macro is meant to test whether the statistics engine uses an
> external DMA engine to transfer data or supports DMA directly. As both
> cases will be supported by DMA coherent buffers rename the macro to
> ISP_STAT_USES_DMAENGINE for improved clarity.

Both use DMA, but the ISP just implements its own. How about calling the
macro ISP_STAT_USES_SYSTEM_DMA instead? Up to you.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
