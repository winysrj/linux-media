Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50006 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751983AbaEBMPG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 May 2014 08:15:06 -0400
Date: Fri, 2 May 2014 15:14:31 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3] v4l: subdev: Move [gs]_std operation to video ops
Message-ID: <20140502121431.GY8753@valkosipuli.retiisi.org.uk>
References: <1398714781-5165-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398714781-5165-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 28, 2014 at 09:53:01PM +0200, Laurent Pinchart wrote:
> The g_std and s_std operations are video-related, move them to the video
> ops where they belong.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
