Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:45619 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415AbbBZI6V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 03:58:21 -0500
Message-ID: <54EEE023.6010209@xs4all.nl>
Date: Thu, 26 Feb 2015 09:58:11 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sudip JAIN <sudip.jain@st.com>,
	Jeremiah Mahler <jmmahler@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 0001-media-vb2-Fill-vb2_buffer-with-bytesused-from-user.patch;
 kernel version 3.10.69
References: <AE3729EDFAD6D548827A31E3191F1E5B0138E8D7@EAPEX1MAIL1.st.com>,<20150225182308.GB27977@hudson.localdomain> <AE3729EDFAD6D548827A31E3191F1E5B0138E8DF@EAPEX1MAIL1.st.com>
In-Reply-To: <AE3729EDFAD6D548827A31E3191F1E5B0138E8DF@EAPEX1MAIL1.st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jeremiah,

On 02/26/15 06:18, Sudip JAIN wrote:
> Hello Jeremiah,
> 
> Please find the patch  "inline"
> 
> commit 3390900680e5182998916c8fa231bc79cd84046b
> Author: Sudip Jain <sudip.jain@st.com>
> Date:   Thu Feb 26 10:40:34 2015 +0530
> 
>     media: vb2: Fill vb2_buffer with bytesused from user
>     
>     In vb2_qbuf for dmabuf memory type, userside bytesused is not read to
>     vb2 buffer. This leads garbage value being copied from __qbuf_dmabuf()
>     back to user in __fill_v4l2_buffer().
>     
>     As a default case, the vb2 framework must trust the userside value,
>     and also allow driver's buffer prepare function prefer modify/update
>     or not to.
>     
>     Applied on kernel version 3.10.69

This kernel is way, way too old. If you provide a patch then you should
use the latest released kernel, or, even better, the master branch of the
media development git repository: http://git.linuxtv.org/cgit.cgi/media_tree.git/

Also, bytesused only needs to be set for output buffers, never for capture
buffers: the driver will set bytesused when a frame is captured. So this
patch makes no sense.

Regards,

	Hans

>     
>     Change-Id: Ieda389403898935f59c2e2994106f3e5238cfefd
>     Signed-off-by: Sudip Jain <sudip.jain@st.com>
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 5e47ba4..54fe9c9 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -919,6 +919,8 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>                                         b->m.planes[plane].m.fd;
>                                 v4l2_planes[plane].length =
>                                         b->m.planes[plane].length;
> +                               v4l2_planes[plane].bytesused =
> +                                       b->m.planes[plane].bytesused;
>                                 v4l2_planes[plane].data_offset =
>                                         b->m.planes[plane].data_offset;
>                         }
> @@ -943,6 +945,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>                 if (b->memory == V4L2_MEMORY_DMABUF) {
>                         v4l2_planes[0].m.fd = b->m.fd;
>                         v4l2_planes[0].length = b->length;
> +                       v4l2_planes[0].bytesused = b->bytesused;
>                         v4l2_planes[0].data_offset = 0;
>                 }
> 
> Thanks,
> Sudip

