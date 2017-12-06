Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62675 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752423AbdLFPIX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Dec 2017 10:08:23 -0500
Date: Wed, 6 Dec 2017 16:08:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 3/3 v7] uvcvideo: add a metadata device node
In-Reply-To: <alpine.DEB.2.20.1712051454460.22421@axis700.grange>
Message-ID: <alpine.DEB.2.20.1712061503060.26640@axis700.grange>
References: <1510156814-28645-1-git-send-email-g.liakhovetski@gmx.de> <29678788.jfO5ktnOBC@avalon> <alpine.DEB.2.20.1712051440590.22421@axis700.grange> <3317467.6k60bZc7Ey@avalon> <alpine.DEB.2.20.1712051454460.22421@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

While testing the new patch version, we did introduce a couple of 
differences:

1. We cannot (easily) reuse .vidioc_querycap() - the metadata node uses 
v4l2_fh_open() directly, so, it has a different struct file::private_data 
pointer.

2. After your video device unification, the order has swapped: now 
/dev/video0 is a metadata node and /dev/video1 is a video node. Is that 
how you wanted to have this or you don't mind or shall I swap them back? 
For now I've swapped them back, I think that would be more appropriate.

Thanks
Guennadi
