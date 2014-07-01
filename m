Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41408 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaGANJL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jul 2014 09:09:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 07/23] v4l: vsp1: Release buffers at stream stop
Date: Tue, 01 Jul 2014 09:16:53 +0200
Message-ID: <1952390.dyG8uLsand@avalon>
In-Reply-To: <53A9686D.5040508@cogentembedded.com>
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1403567669-18539-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <53A9686D.5040508@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

On Tuesday 24 June 2014 16:00:45 Sergei Shtylyov wrote:
> Hello.
> 
> On 06/24/2014 03:54 AM, Laurent Pinchart wrote:
> > videobuf2 expects no buffer to be owned by the driver when the
> > stop_stream queue operation returns. As the vsp1 driver fails to do so,
> > a warning is generated at stream top time.
> > 
> > Fix this by mark releasing all buffers queued on the IRQ queue in the
> 
> Mark releasing?

I'll fix that, thank you.

> > stop_stream operation handler and marking them as erroneous.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

