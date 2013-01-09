Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55346 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122Ab3AIWdr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2013 17:33:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: William Swanson <william.swanson@fuel7.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Ken Petit <ken@fuel7.com>, sakari.ailus@iki.fi
Subject: Re: [PATCH] omap3isp: Add support for interlaced input data
Date: Wed, 09 Jan 2013 23:35:26 +0100
Message-ID: <2574136.Nmpnc7I1z4@avalon>
In-Reply-To: <50ECA285.2000909@fuel7.com>
References: <1355796739-2580-1-git-send-email-william.swanson@fuel7.com> <1489481.HbZGQ48duQ@avalon> <50ECA285.2000909@fuel7.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi William,

On Tuesday 08 January 2013 14:49:41 William Swanson wrote:
> On 01/07/2013 04:20 AM, Laurent Pinchart wrote:
> > What do you get in the memory buffers ? Are fields captured in separate
> > buffers or combined in a single buffer ? If they're combined, are they
> > interleaved or sequential in memory ?
> 
> I believe the data is combined in a single buffer, with alternate fields
> interleaved.

Could you please double-check that ? I'd like to be sure, not just believe :-)

In that case the OMAP3 ISP driver should set the v4l2_pix_format::field to 
V4L2_FIELD_INTERLACED in the format-related ioctl when an interlaced format is 
used. I suppose this could be added later - Sakari, any opinion ?

-- 
Regards,

Laurent Pinchart

