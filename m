Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44614 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751482AbcELVWU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2016 17:22:20 -0400
Date: Fri, 13 May 2016 00:22:16 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH/RFC v2 2/4] v4l: Add metadata video device type
Message-ID: <20160512212215.GT26360@valkosipuli.retiisi.org.uk>
References: <1463012283-3078-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1463012283-3078-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1463012283-3078-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patchset!

On Thu, May 12, 2016 at 03:18:01AM +0300, Laurent Pinchart wrote:
> The metadata video device is used to transfer metadata between
> userspace and kernelspace. It supports the metadata buffer type only.

I remember we briefly discussed this before but I have to bring this up
again: do you think we need a different device node type? It depends purely
on the use case for which purpose a DMA engine is used for. The receiver
hardware doesn't even really know whether the data is image data or
metadata; the hardware may well simply write all of it to memory and that's
it.

Should we use a different device node type for metadata, every driver which
uses sensors connected over the CSI-2 bus --- that hardware is designed to
receive metadata using a separate data type which is part of the same stream
--- would be required to create one node for image data and another for
metadata, essentially doubling the number of data device nodes.

Doubling doesn't necessarily sound bad, but modern devices tend to have tens
of DMA engines already.

For what it's worth, multi-plane buffers use video devices as well so this
is not the first time a type of a device node would make use of multiple
buffer types.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
