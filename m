Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:35202 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbcEDMrw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 08:47:52 -0400
Subject: Re: [PATCH 3/3] v4l: subdev: Call pad init_cfg operation when opening
 subdevs
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1462361133-23887-1-git-send-email-sakari.ailus@linux.intel.com>
 <1462361133-23887-4-git-send-email-sakari.ailus@linux.intel.com>
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5729EF74.1000609@xs4all.nl>
Date: Wed, 4 May 2016 14:47:48 +0200
MIME-Version: 1.0
In-Reply-To: <1462361133-23887-4-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/04/2016 01:25 PM, Sakari Ailus wrote:
> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> The subdev core code currently rely on the subdev open handler to
> initialize the file handle's pad configuration, even though subdevs now
> have a pad operation dedicated for that purpose.
> 
> As a first step towards migration to init_cfg, call the operation
> operation in the subdev core open implementation. Subdevs that are
> haven't been moved to init_cfg yet will just continue implementing pad
> config initialization in their open handler.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
