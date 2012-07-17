Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38327 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab2GQLT6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 07:19:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Documentation: DocBook DRM framework documentation
Date: Tue, 17 Jul 2012 13:20:01 +0200
Message-ID: <1396693.MbzetZmM0M@avalon>
In-Reply-To: <1342137623-7628-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1342137623-7628-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 13 July 2012 02:00:23 Laurent Pinchart wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/DocBook/drm.tmpl | 2835 ++++++++++++++++++++++++++++---------
>  1 files changed, 2226 insertions(+), 609 deletions(-)
> 
> Hi everybody,
> 
> Here's the DRM kernel framework documentation previously posted to the
> dri-devel mailing list. The documentation has been reworked, converted to
> DocBook and merged with the existing DocBook DRM documentation stub. The
> result doesn't cover the whole DRM API but should hopefully be good enough
> for a start.
> 
> I've done my best to follow a natural flow starting at initialization and
> covering the major DRM internal topics. As I'm not a native English speaker
> I'm not totally happy with the result, so if anyone wants to edit the text
> please feel free to do so. Review will as usual be appreciated, and acks
> will be even more welcome (I've been working on this document for longer
> than I feel comfortable with).

Just for information, a compiled copy of the DRM documentation with this patch 
applied can be found at http://www.ideasonboard.org/media/drm/. That might be 
easier to review than the patch.

-- 
Regards,

Laurent Pinchart

