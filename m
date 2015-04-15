Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58800 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbbDOUbB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2015 16:31:01 -0400
Date: Wed, 15 Apr 2015 22:30:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 2/7] v4l2: replace video op g_mbus_fmt by pad op get_fmt
In-Reply-To: <1428574888-46407-3-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1504152228420.32631@axis700.grange>
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
 <1428574888-46407-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 9 Apr 2015, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The g_mbus_fmt video op is a duplicate of the pad op. Replace all uses
> by the get_fmt pad op and remove the video op.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> Cc: Kamil Debski <k.debski@samsung.com>
> ---

for soc-camera:

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi
