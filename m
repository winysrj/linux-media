Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48902 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726555AbeHYQhk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Aug 2018 12:37:40 -0400
Date: Sat, 25 Aug 2018 15:58:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv18 23/35] vb2: add init_buffer buffer op
Message-ID: <20180825125845.wtsxkzobszrmamxz@valkosipuli.retiisi.org.uk>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
 <20180814142047.93856-24-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180814142047.93856-24-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 14, 2018 at 04:20:35PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> We need to initialize the request_fd field in struct vb2_v4l2_buffer
> to -1 instead of the default of 0. So we need to add a new op that
> is called when struct vb2_v4l2_buffer is allocated.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
