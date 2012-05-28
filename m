Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46019 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2E1V3p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 17:29:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de, linux-doc@vger.kernel.org
Subject: Re: [PATCHv6 02/13] Documentation: media: description of DMABUF importing in V4L2
Date: Mon, 28 May 2012 23:30:05 +0200
Message-ID: <3552222.dzY4fiG81O@avalon>
In-Reply-To: <1337775027-9489-3-git-send-email-t.stanislaws@samsung.com>
References: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com> <1337775027-9489-3-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.


On Wednesday 23 May 2012 14:10:16 Tomasz Stanislawski wrote:
> This patch adds description and usage examples for importing
> DMABUF file descriptor in V4L2.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: linux-doc@vger.kernel.org

[snip]

> @@ -103,6 +105,7 @@ as the &v4l2-format; <structfield>type</structfield>
> field. See <xref <entry><structfield>memory</structfield></entry>
>  	    <entry>Applications set this field to
>  <constant>V4L2_MEMORY_MMAP</constant> or
> +<constant>V4L2_MEMORY_DMABUF</constant> or
>  <constant>V4L2_MEMORY_USERPTR</constant>. See <xref linkend="v4l2-memory"
>  />.</entry>
>  	  </row>

If you resubmit to fix the compat-ioctl issue in 01/13, could you please 
replace this with

<entry>Applications set this field to
<constant>V4L2_MEMORY_MMAP</constant>,
<constant>V4L2_MEMORY_DMABUF</constant> or
<constant>V4L2_MEMORY_USERPTR</constant>. See <xref linkend="v4l2-memory"/>.
</entry>

like in v5 ?

-- 
Regards,

Laurent Pinchart

