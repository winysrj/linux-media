Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51575 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751310AbbLINNO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2015 08:13:14 -0500
Date: Wed, 9 Dec 2015 15:13:11 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	jh1009.sung@samsung.com, inki.dae@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv11 15/15] videobuf2-core: fix plane_sizes handling in
 VIDIOC_CREATE_BUFS
Message-ID: <20151209131311.GJ17128@valkosipuli.retiisi.org.uk>
References: <1448037948-36820-1-git-send-email-hverkuil@xs4all.nl>
 <1448037948-36820-16-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1448037948-36820-16-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Nov 20, 2015 at 05:45:48PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The handling of q->plane_sizes was wrong in vb2_core_create_bufs().
> The q->plane_sizes array was global and it was overwritten by create_bufs.
> So if reqbufs was called with e.g. size 100000 then q->plane_sizes[0] would
> be set to 100000. If create_bufs was called afterwards with size 200000,
> then q->plane_sizes[0] would be overwritten with the new value. Calling
> create_bufs again for size 100000 would cause an error since 100000 is now
> less than q->plane_sizes[0].
> 
> This patch fixes this problem by 1) removing q->plane_sizes and using the
> vb->planes[].length field instead, and 2) by introducing a min_length field
> in struct vb2_plane. This field is set to the plane size as returned by
> the queue_setup op and is the minimum required plane size. So user pointers
> or dmabufs should all be at least this size.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
