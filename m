Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:46908 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbcEDMn6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 08:43:58 -0400
Subject: Re: [PATCH 1/3] media: Move media_device link_notify operation to an
 ops structure
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1462361133-23887-1-git-send-email-sakari.ailus@linux.intel.com>
 <1462364803-2579-1-git-send-email-sakari.ailus@linux.intel.com>
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5729EE88.6040001@xs4all.nl>
Date: Wed, 4 May 2016 14:43:52 +0200
MIME-Version: 1.0
In-Reply-To: <1462364803-2579-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/04/2016 02:26 PM, Sakari Ailus wrote:
> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> This will allow adding new operations without increasing the
> media_device structure size for drivers that don't implement any media
> device operation.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> Fix compilation error for the omap3isp driver.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
