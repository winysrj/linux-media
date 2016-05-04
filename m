Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:35202 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbcEDMrj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 08:47:39 -0400
Subject: Re: [PATCH 2/3] media: Add per-file-handle data support
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1462361133-23887-1-git-send-email-sakari.ailus@linux.intel.com>
 <1462361133-23887-3-git-send-email-sakari.ailus@linux.intel.com>
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5729EF65.6000802@xs4all.nl>
Date: Wed, 4 May 2016 14:47:33 +0200
MIME-Version: 1.0
In-Reply-To: <1462361133-23887-3-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/04/2016 01:25 PM, Sakari Ailus wrote:
> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> The media devnode core associates devnodes with files by storing the
> devnode pointer in the file structure private_data field. In order to
> allow tracking of per-file-handle data introduce a new media devnode
> file handle structure that stores the devnode pointer, and store a
> pointer to that structure in the file private_data field.
> 
> Users of the media devnode code (the only existing user being
> media_device) are responsible for managing their own subclass of the
> media_devnode_fh structure.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
